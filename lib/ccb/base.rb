require 'active_support/hash_with_indifferent_access'
module CCB
  class Base

    include ActiveModel::Validations
    include ActiveModel::Conversion
    include ActiveModel::Dirty 
    extend ActiveModel::Naming
    extend ActiveModel::Callbacks

    include HTTParty
    base_uri BASE_URI
    basic_auth(CCBAUTH[:username], CCBAUTH[:password])

    def self.send_line(options,data)
      options = options.collect {|a,b| "#{a}=#{b}"}.join("&")
      options = options.merge data
      response = self.post(self.base_uri + "?" + options)
    end

    def self.send_data(options,data)
      options = options.collect {|a,b| "#{a}=#{b}"}.join("&")
      response = self.post(self.base_uri + "?" + options, :body => data )
    end

    def self.request(options,fields=[])
      options = HashWithIndifferentAccess.new options
      fields.dup.each do |key|
        next if key == "srv"
        options.delete key unless fields.include?(key)
      end
      response = self.get(self.base_uri + "?" + options.collect {|a,b| "#{a}=#{URI.encode_www_form_component(b)}"}.join("&") )
      response = response["ccb_api"]["response"]
      response = response.values[-1] if response.respond_to?(:values)
      count = response.delete("count").to_i if response.respond_to? :delete
      if count && count > 0
        response = response[response.keys.first]
        if response.is_a? Array
            response = response.collect {|item| self.from_api(item)}
            return response
        else
            return self.from_api(response)
        end
      else
        return response
      end
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

    def initialize(args={})
      fields = args.keys
      fields.each do |field_name|
        send(:instance_variable_set,"@#{field_name.to_s}", args[field_name]) if self.respond_to? field_name
      end
      ["owner", "modifier"].each do |att|
        var = instance_variable_get("@#{att}")
        if var
          obj = CCB::Person.new(:id => var["id"], :full_name => var["__content__"])
          instance_variable_set("@#{att}", obj)
        end
      end
      @info = args[:info] || {}
      @changed_attributes = {}
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


    def self.update(obj)
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
      obj.inactive = "true"
      obj.description = obj.description + "\nDeleted Using the API at #{lambda {Time.now}.call}" if obj.respond_to? :description
      obj.save
    end

    def self.from_api(args, cname=nil)
      args = args["ccb_api"]["response"]["#{cname}s"][cname] if cname
      new_args = {}
      args.dup.keys.each do |key|
        new_args[key.to_sym] = args.delete(key) if self.method_defined?(key.to_sym)
      end
      args = args.merge(new_args[:info]) if new_args[:info]
      new_args[:info] = args
      return self.new(new_args)
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
