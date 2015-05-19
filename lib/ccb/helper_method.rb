class CCB
	class HelperMethod
		def self.string_attribute(value)
			puts value.inspect
		end

		def self.date_attribute(value)
			Date.parse(value)
		end
	end
end
