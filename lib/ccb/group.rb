module CCB
  class Group < CCB::Base
    attr_accessor :id, :name, :membership_type, :description, :address, :public_search_listed, :listed, :meeting_day, :meeting_time, :image, :campus, :calendar_feed, :created, :modified, :inactive, :group_capacity, :area, :department, :leader, :coach, :director, :participants, :current_members, :group_type, :creator, :modifier, :notification, :interraction_type, :addresses, :childcare_provided, :interaction_type, :leaders, :main_leader, :registration_forms, :user_defined_fields

    tracking_methods = [:name, :membership_type, :description, :address, :public_search_listed, :listed, :meeting_day, :meeting_time, :campus, :inactive, :group_capacity, :area, :department, :leader, :coach, :director, :participants, :current_members, :group_type, :notification, :interraction_type, :addresses, :childcare_provided, :interaction_type, :leaders, :main_leader, :user_defined_fields]
    #define_attribute_methods  tracking_methods
    tracking_methods.each do |method|
      assign_attribute method
    end

    OBJ_TYPE = "group" unless defined? OBJ_TYPE
    SRV = {
      :profiles => "group_profiles",
      :find_by_id => "group_profile_from_id",
      :update => "update_group",
      :create => "create_group"
    } unless defined? SRV

    def self.find(args={})
      case
        when args == :all
          self.profiles
        when args.keys == [:id]
          self.find_by_id(args[:id])
        else
          @profiles = self.profiles
          args.each do |k,v|
            @profiles = @profiles.select {|p| p.send(k).include?(v)}
          end
          @profiles = @profiles[0] if args.keys.any? {|k| k == :id}
          return @profiles
      end
    end

    def self.find_by_id(id)
      args = {"srv" => SRV[__method__], "id" => id}
      fields = []

      response = self.request(args,fields)
    end

    def self.profiles(args={})
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
      super
    end

    private

    def self.update(obj)
      response = super
      self.from_api(response, "group")

    end

    def self.destroy(obj)
      # obj.inactive = "true"
      # obj.description = obj.description + "\nDeleted Using the API at #{lambda {Time.zone.now}.call}"
      # obj.save
      super
    end

  end # end Group Class
end # end CCB module container
