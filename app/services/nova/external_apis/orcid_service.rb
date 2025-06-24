require 'faraday'
require 'json'

module Nova

  module ExternalApis

    class OrcidService

      def self.fetch_record(orcid_id)
        access_token = get_access_token

        orcid_records_endpoint = "https://api.#{'sandbox.' if ENV["ORCID_SANDBOX"]}orcid.org/v3.0"

        orcid_record_url = "#{orcid_records_endpoint}/#{orcid_id}/record"

        connection = Faraday.new do |faraday|
          faraday.adapter Faraday.default_adapter
          faraday.options.timeout = 5
        end

        response = connection.get(orcid_record_url) do |request|
          request.headers['Authorization'] = "Bearer #{access_token}"
          request.headers['Accept'] = 'application/json'
        end

        response
      end
    
      private 
    
      def self.get_access_token
        orcid_tokens_endpoint = "https://#{'sandbox.' if ENV["ORCID_SANDBOX"]}orcid.org/oauth/token"

        connection = Faraday.new(url: orcid_tokens_endpoint) do |faraday|
          faraday.adapter Faraday.default_adapter
        end

        body = {
          "client_id" => ENV["ORCID_CLIENT_ID"],
          "client_secret" => ENV["ORCID_CLIENT_SECRET"],
          "grant_type" => "client_credentials",
          "scope" => "/read-public"
        }

        response = connection.post do |request|
          request.headers['Content-Type'] = "application/x-www-form-urlencoded"
          request.body = URI.encode_www_form(body)
          request.options.timeout = 5
        end

        response_body = JSON.parse(response.body)

        response_body["access_token"]
      end
    
    end

  end

end