module CCB
  class Person < CCB::Base
    attr_accessor :id, :first_name, :last_name, :phone, :email, :street_address, :city, :state, :zip, :info, :image, :family_position, :giving_number, :gender, :birthday, :anniversary, :active, :created, :modified, :receive_email_from_church, :marital_status, :phones, :attendance

    tracking_methods = [:first_name, :last_name, :email, :street_address, :city, :state, :zip, :info, :image, :family_position, :giving_number, :gender, :birthday, :anniversary, :active, :receive_email_from_church, :marital_status]
    #define_attribute_methods  tracking_methods
    tracking_methods.each do |method|
      assign_attribute method
    end

    SRV = {
      :search => "individual_search",
      :groups => "individual_groups",
      :attendance => "individual_attendance",
      :create => "create_individual",
      :login => "individual_id_from_login_password",
      :from_id => "individual_profile_from_id",
      :all => "individual_profiles",
      :destroy => "individual_inactivate",
      :from_micr => "individual_profile_from_micr"
    } unless defined? SRV

    def self.create(args={})
      options = {"srv" => SRV[__method__]}
      response = send_data(options,args)
      self.from_api(response["ccb_api"]["response"]["individuals"]["individual"])
    end

    def full_name
      first_name + " " + last_name
    end

    def attendance
     args = {"srv" => SRV[__method__], "individual_id" => self.id}
      response = CCB::Person::Attendance.request(args)
      retval = response
    end

    def groups
      args = {"srv" => SRV[__method__], "individual_id" => self.id}
      response = self.class.request(args)
      retval = response.instance_variable_get("@groups")["group"].collect do |g|
        CCB::UserGroup.from_api(g)
      end
      retval.each {|g| g.user_id = id}
      retval
    end

    def self.destroy(id,confirmation=false)
      raise "Confirmation must be set to true: destroy(id,true)" unless confirmation == true
      args = {"individual_id" => id}
      args["srv"] = SRV[__method__]
      puts args.inspect
      response = self.request(args)

    end

    def self.login(args={})
      args = args.select {|k,v| [:username,:password].include?(k)}
      args[:login] = args.delete :username
      args["srv"] = SRV[__method__]
      if args[:login] && args[:password]
        response = self.request(args)
        return self.from_id(response.id)
      else
        return nil
      end
      args
    end

    def self.all(since=nil)
      args = {"srv" => SRV[__method__]}
      response = self.request(args)
    end

    def self.find(args={})
      if args.is_a?(Symbol) && args == :all
        return self.all
      elsif args.is_a?(Hash) && args[:id]
        return self.from_id(args[:id])
      elsif args.is_a?(Hash) && (args[:routing_number] || args[:account_number])
        return self.from_micr(args)
      else
        return self.search(args)
      end
    end

    def self.from_micr(args={})
      fields = %w{routing_number account_number}.collect(&:to_sym)
      raise "Please include both of #{fields.join(', ')}" unless [args.keys].flatten.sort == fields.sort
      args["srv"] = SRV[__method__]
      response = self.request(args, fields)
    end

    def self.search(args={})
      fields = %w{first_name last_name phone email street_address city state zip}.collect(&:to_sym)
      raise "Please include one of #{fields.join(', ')}" if args.keys.empty?
      args["srv"] = SRV[__method__]
      response = self.request(args, fields)
    end

    def self.from_id(id)
      fields = %w{id}
      id = id.to_s
      args = {}
      args["srv"] = SRV[__method__]
      args["individual_id"] = id
      response = self.request(args, fields)
    end
  end
end
