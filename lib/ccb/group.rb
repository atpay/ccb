module CCB
  class Group < CCB::Base
    attr_accessor :id, :name, :membership_type, :description, :address, :public_search_listed, :listed, :meeting_day, :meeting_time, :image, :campus, :calendar_feed, :created, :modified, :inactive, :group_capacity, :area, :department, :leader, :coach, :director, :participants, :current_members, :group_type, :creator, :modifier, :notification, :interraction_type, :addresses, :childcare_provided, :interaction_type, :leaders, :main_leader, :registration_forms, :user_defined_fields

    tracking_methods = [:name, :membership_type, :description, :address, :public_search_listed, :listed, :meeting_day, :meeting_time, :campus, :inactive, :group_capacity, :area, :department, :leader, :coach, :director, :participants, :current_members, :group_type, :notification, :interraction_type, :addresses, :childcare_provided, :interaction_type, :leaders, :main_leader, :user_defined_fields]
    #define_attribute_methods  tracking_methods
    tracking_methods.each do |method|
      assign_attribute method
    end

    SRV = {
      :profiles => "group_profiles",
      :update => "update_group",
      :create => "create_group"
    } unless defined? SRV

    def self.find(args={})
      case args
        when :all
          self.profiles
        else
          @profiles = self.profiles
          args.each do |k,v|
            @profiles = @profiles.select {|p| p.send(k).include?(v)}
          end
          @profiles = @profiles[0] if args.keys.any? {|k| k == :id}
          return @profiles
      end
    end

    def self.profiles(args={})
      # fields = %w{name area_id childcare meet_day_id meet_time_id department_id type_id udf_pulldown_1_id udf_pulldown_2_id udf_pulldown_3_id limit_records_start limit_records_per_page order_by_1 order_by_2 order_by_3 order_by_1_sort order_by_2_sort order_by_3_sort}.collect(&:to_sym)
      fields = []
      args["srv"] = SRV[__method__]

      response = self.request(args,fields)
    end

    def self.create(args={})
      options = {"srv" => SRV[__method__]}
      response = self.send_data(options,args)
      # return response
      self.from_api(response["ccb_api"]["response"]["groups"]["group"])
    end

    def persisted?
      false
    end

    def destroy
      self.class.destroy(self)
    end

    def save
      self.class.save(self)
    end

    private

    def self.save(obj)
      if obj.valid?
        if obj.id && obj.created && obj.changed?
          retval = self.update(obj)
          # binding.pry
          # obj.previously_changed = obj.changes
          obj.changed_attributes.clear
          return retval
        elsif obj.id.nil?
          obj.changed_attributes.clear
          args = obj.to_args
          # obj.previously_changed = changes
          obj.changed_attributes.clear
          return self.create(args)
        end
      else # object is not valid
        raise "#{obj.class.to_s} is not valid"
      end # if valid condition
    end # method

    def self.destroy(obj)
      obj.inactive = "true"
      obj.description = obj.description + "\nDeleted Using the API at #{lambda {Time.zone.now}.call}"
      obj.save
    end

    def self.update(args={})
      unless args.is_a? Hash
        obj = args.dup
        args = {}
        obj.changes.each do |k,v|
          args[k] = v[1]
        end
        args[:id] = obj.id
      end
      options = {"srv" => SRV[__method__], "id" => args.delete(:id)}
      response = self.send_data(options,args)
      # return response
      if response["ccb_api"]["response"]["success"] == "true"
        return self.from_api(response["ccb_api"]["response"]["groups"]["group"])
      else
        return response # direct API response
      end
    end # method

  end # end Group Class
end # end CCB module container
