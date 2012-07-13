require 'faraday'

module Classmate
  module Api
    class Response
      attr_reader :status, :body, :headers
      
      def initialize(status, body, headers)
        @status  = status
        @body    = body
        @headers = headers
      end
      
      def error?
        body.is_a?(Hash) && body['error_code'].present?
      end
    end
    
    class Client
      REST_API_URL = "http://api.odnoklassniki.ru/fb.do"
      
      attr_accessor :session_key, :session_secret_key
      
      def initialize(session_key, session_secret_key)
        self.session_key = session_key
        self.session_secret_key = session_secret_key
      end
      
      def call(method, specific_params = {})
        result = make_request(method, specific_params)
        
        raise APIError.new({"type" => "HTTP #{result.status.to_s}", "message" => "Response body: #{result.body}"}) if result.status >= 500
        
        body = begin
          JSON.parse(result.body.to_s)
        rescue Exception => e
          result.body.to_s.gsub(/\"/, "")
        end

        Classmate::Api::Response.new(result.status.to_i, body, result.headers)
      end

      def signed_call_params(method, specific_params = {})
        params = {
          :method      => method,
          :application_key  => Classmate::Config.default.public_key,
          :format      => 'json'
        }.merge(specific_params.symbolize_keys)

        params.merge!(:session_key => session_key) if session_key
          
        sig = calculate_signature(params)

        params.merge(:sig => sig)
      end
  
      protected
      
        def make_request(method, specific_params)
          Faraday.new(REST_API_URL).get do |request|
            request.params = signed_call_params(method, specific_params)
          end
        rescue Exception => e
          ::Rails.logger.error("Exception: #{e.inspect}")
        end
        
        def calculate_signature(params)
          param_string = params.except(:sig, :resig).sort.map{|key, value| "#{key}=#{value}"}.join
          
          secret_key = params[:session_key] ? session_secret_key : Classmate::Config.default.secret_key

          Digest::MD5.hexdigest(param_string + secret_key)
        end
    end
  end
end