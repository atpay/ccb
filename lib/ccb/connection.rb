require 'active_support/core_ext'

class CCB
  class Connection < CCB::Base
    def initialize(config)
      @config = config
      @base_url = @config['url']
      @session = Faraday.new(url: @base_url)
      # @session = Faraday.new(url: @base_url) do |builder|
      #   builder.use :cookie_jar
      #   builder.adapter Faraday.default_adapter
      # end
      @session.basic_auth( @config['username'], @config['password'] )
      session.options.timeout = 900
    end

    def base_url
      @base_url
    end

    def session
      @session
    end

    def send_line(options,data)
      options = options.collect {|a,b| "#{a}=#{b}"}.join("&")
      options = options.merge data
      response = session.post("?" + options)
    end


    def get( options = nil, fields = [], object_class )
      options = HashWithIndifferentAccess.new options
      full_uri = ""
      if options.blank?
        full_uri = ""
      else
        fields.dup.each do |key|
          next if key == "srv"
          options.delete key unless fields.include?(key)
        end
        full_uri =  "?" + options.map {|k,v| "#{k}=#{v}"}.join("&")
      end
      # options = filters.map {|name,value| "#{name}=#{URI.encode_www_form_component(value)}"}.join("&")
      # binding.pry
      response = session.get(full_uri)
      response = Hash.from_xml(response.body)
      response = response["ccb_api"]["response"]
      response = response.values[-1] if response.respond_to?(:values)
      count = response.delete("count").to_i if response.respond_to? :delete
      if count && count > 0
        response = response[response.keys.first]
        if response.is_a? Array
            response = response.collect {|item| from_api(item, object_class)}
            return response
        else
            return self.from_api(response, object_class)
        end
      else
        return response
      end

    end

    def clear_session_cookie
      @session_cookie = nil
    end

    def session_cookie
      @session_cookie ||= nil
      @session_started_at ||= Time.now - 3600
      if @session_cookie.nil? || (Time.now - @session_started_at) > 300
        r = self.get
        @session_started_at = Time.now
        @session_cookie = r.headers["set-cookie"].split("; ").detect {|h| h.include?("SESSID")}.split("=")[-1]
      end
      @session_cookie

    end

  end # session class
end # ccb module
