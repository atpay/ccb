<<<<<<< HEAD
class Address
  def initialize(args={})
=======
module CCB
  class Address
  	attr_accessor :type, :street_address, :city, :state, :zip, :country_code, :latitude, :longitude

  	def initialize(args={})
  	  # setup
  	  args.each do |k,v|
  	  	send(:instance_variable_set, "@#{k}", v) if respond_to? k
  	  end
  	  @country = CCB::Country.from_api(@country) if @country && !@country.is_a?(String)
  	end

    def line1
      street_address
    end

    def line2
      line = [city, state, zip].compact.join(" ")
    end

  	def self.from_api(data)
  	  # parse
  	  data.dup.each do |k,v|
  	  	data.delete k
  	  	data[k.to_sym] = v
  	  end
  	  self.new data
  	end
>>>>>>> c1a30e60c22f331cfc5daad12bb51cabb9e85a70
  end
end