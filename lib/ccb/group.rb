class CCB
  class Group < CCB::Base
    OBJ_TYPE = "Group" unless defined? OBJ_TYPE
    attr_accessor :id, :name, :membership_type, :description, :address, :public_search_listed, :listed, :meeting_day, :meeting_time, :image, :campus, :calendar_feed, :created, :modified, :inactive, :group_capacity, :area, :department, :leader, :coach, :director, :participants, :current_members, :group_type, :creator, :modifier, :notification, :interraction_type, :addresses, :childcare_provided, :interaction_type, :leaders, :main_leader, :registration_forms, :user_defined_fields

    tracking_methods = [:name, :membership_type, :description, :address, :public_search_listed, :listed, :meeting_day, :meeting_time, :campus, :inactive, :group_capacity, :area, :department, :leader, :coach, :director, :participants, :current_members, :group_type, :notification, :interraction_type, :addresses, :childcare_provided, :interaction_type, :leaders, :main_leader, :user_defined_fields]
    #define_attribute_methods  tracking_methods
    tracking_methods.each do |method|
      assign_attribute method
    end

    SRV = {
      :profiles => "group_profiles",
      :find_by_id => "group_profile_from_id",
      :update => "update_group",
      :create => "create_group"
    } unless defined? SRV

    def self.find( connection, args = {}, filters = {} )
      case
        when args == :all
          self.profiles(connection, {}, filters)
        when args.keys == [:id]
          self.find_by_id(connection, args[:id], filters)
        else
          @profiles = self.profiles(connection, args, filters)
          args.each do |k,v|
            @profiles = @profiles.select {|p| p.send(k).include?(v)}
          end
          @profiles = @profiles[0] if args.keys.any? {|k| k == :id}
          return @profiles
      end
    end

    def self.find_by_id( connection, id, fields = [] )
      args = {"srv" => SRV[__method__], "id" => id}
      fields = []

      response = connection.get(args, fields, OBJ_TYPE)
    end

    def self.profiles(connection, args={}, filters={})
      fields = []
      response = nil
      args["srv"] = SRV[__method__]
      if filters.blank?
        response = connection.get(args.merge(filters), fields, OBJ_TYPE)
      else
        response = connection.post(args.merge(filters), fields)
      end
      response
    end

    def self.create(connection, args={})
      options = {"srv" => SRV[__method__]}
      response = self.send_data(options,args)
      # return response
      self.from_api(response["ccb_api"]["response"]["groups"]["group"])
    end

    def persisted?
      false
    end

    # private

    def self.update(connection, obj)
      response = super(connection, obj)
      self.from_api(response, "group")

    end

  end # end Group Class
end # end CCB module container
