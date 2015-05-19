class CCB
  class Base

    include ActiveModel::Validations
    include ActiveModel::Conversion
    include ActiveModel::Dirty
    extend ActiveModel::Naming
    extend ActiveModel::Callbacks

    def initialize(args={}, connection=nil)
      fields = args.keys
      fields.each do |field_name|
        send(:instance_variable_set,"@#{field_name.to_s}", args[field_name]) if self.respond_to? field_name
      end
      ["owner", "modifier", "main_leader"].each do |att|
        var = instance_variable_get("@#{att}")
        if var && !var.blank? && !var.is_a?(String)
          var.dup.each do |k,v|
            var.delete k
            var[k.to_sym] = v
          end
          obj = CCB::Person.new(var)
          instance_variable_set("@#{att}", obj)
        end
      end
      @info = args[:info] || {}
      @changed_attributes = {}
    end

    def send_line(options,data)
      options = options.collect {|a,b| "#{a}=#{b}"}.join("&")
      options = options.merge data
      response = self.post(self.base_uri + "?" + options)
    end

    def send_data(connection, options,data)
      options = options.collect {|a,b| "#{a}=#{b}"}.join("&")
      response = connection.post(self.base_uri + "?" + options, body: data )
    end

    def request(connection, options, fields=[], cname=nil)
      # options = HashWithIndifferentAccess.new options
      # fields.dup.each do |key|
      #   next if key == "srv"
      #   options.delete key unless fields.include?(key)
      # end
      # response = connection.get("?" + options.collect {|name,value| "#{name}=#{URI.encode_www_form_component(value)}"}.join("&") )
      # response = response["ccb_api"]["response"]
      # response = response.values[-1] if response.respond_to?(:values)
      # count = response.delete("count").to_i if response.respond_to? :delete
      # if count && count > 0
      #   response = response[response.keys.first]
      #   if response.is_a? Array
      #       response = response.collect {|item| self.from_api(item, cname)}
      #       return response
      #   else
      #       return self.from_api(response)
      #   end
      # else
      #   return response
      # end
      nil
    end

    def to_args
      args = {}
      self.instance_variables.each do |var|
        var = var.to_s
        ignored_atts = %w{@errors @info @changed_attributes @validation_context}
        next if ignored_atts.include?(var)
        key = var[1..-1]
        args[key] = instance_variable_get(var)
      end
      return args
    end


    def save
      return nil if self.class == CCB::Base
      self.class.save(self)
    end

    def self.save(obj)
      if obj.valid?
        if obj.id && obj.created && obj.changed?
          retval = obj.class.update(obj)
          # obj.previously_changed = obj.changes
          obj.changed_attributes.clear
          return retval
        elsif obj.id.nil?
          args = obj.to_args
          # obj.previously_changed = changes
          obj.changed_attributes.clear
          return obj.class.create(args)
        end
      else # object is not valid
        raise "#{obj.class.to_s} is not valid"
      end # if valid condition
    end # method


    def self.update(connection, obj)
      @options ||= {"srv" => obj.class::SRV[__method__], "id" => obj.id}
      args = {}
      obj.changes.each do |k,v|
        args[k] = v[1]
      end
      response = self.send_data(@options,args)
      # return response
      return response # direct API response
    end # method

    def destroy
      self.class.destroy(self)
    end

    def self.destroy(obj)
      obj.inactive = true
      obj.description = obj.description + "\nDeleted Using the API at #{lambda {Time.now}.call}" if obj.respond_to? :description
      obj.save
    end

    def from_api(args, cname)
      klass = ("CCB::" + cname).constantize
      new_args = {}
      args.dup.keys.each do |key|
        new_args[key.to_sym] = args.delete(key) if klass.method_defined?(key.to_sym)
      end
      args = args.merge(new_args[:info]) if new_args[:info]
      new_args[:info] = args
      return klass.new(new_args)
    end

    private

    def from_ccb_hash(attribute, key)
      value = self.instance_variable_get("@" + attribute.to_s)
      if value && value.is_a?(Hash)
        value = value[key]
      end
      self.instance_variable_set("@#{attribute}", value) if value

    end

    def self.assign_attribute(name, value=nil)
      self.__send__(:define_attribute_methods, [name.to_s.underscore.to_sym])
      self.create_method(name.to_s.underscore.to_sym) do
        instance_variable_get("@#{name.to_s.underscore}")
      end #unless self.respond_to? name.to_s.underscore.to_sym
      self.create_method("#{name.to_s.underscore}=") do |value|
        send("#{name.to_s.underscore}_will_change!".to_sym) unless value == instance_variable_get("@#{name.to_s.underscore}")
        instance_variable_set("@#{name.to_s.underscore}",value)
      end
    #self.__send__("#{name.to_s.underscore}=".to_sym, value)
    end


    def self.create_method( name, &block )
      self.send( :define_method, name, &block )
    end

  end # class
end # module
