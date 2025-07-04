module Nova
  class OrcidRecordsController < ApplicationController
    def show
      orcid_value = CGI.unescape(params[:orcid_id])

      orcid_id = extract_orcid_id(orcid_value)

      if orcid_id && Nova::OrcidValidator.orcid_id_is_valid?(orcid_id)
        response = Nova::OrcidService.fetch_record(orcid_id)
        if response.status == 200
          body = JSON.parse(response.body)
          name = body.dig("person", "name", "credit-name", "value")
          email = body.dig("person", "emails", "email", 0, "email")
          organization = body.dig("activities-summary", "employments", "affiliation-group", 0, "summaries", 0, "employment-summary", "organization", "name")
          resolved_org = resolve_org(organization)
          response_data = {
            status_code: response.status.to_s,
            message: _("ORCID record retrieved."),
            name: name,
            email: email,
            organization: resolved_org
          }
          render json: response_data
        else 
          render json: {
            status_code: response.status.to_s,
            message: _("There was a problem retrieving the ORCiD record.")
          }
        end
      else 
        render json: {
          status_code: 422.to_s,
          message: _("The ORCID iD is not valid.")
        }
      end
    end

    private

    def extract_orcid_id(orcid)
      # Match and extract just the ORCID iD (with hyphens)
      orcid_pattern = /(\d{4}-\d{4}-\d{4}-\d{3}[0-9X])/
      match = orcid.match(orcid_pattern)
      match ? match[1] : nil  # Return the ORCID ID if valid, otherwise nil
    end

    def resolve_org(orcid_org_name)
      # search for match of org in orgs table
      org = Org.find_by(name: orcid_org_name)

      # return object consisting of id, name, and sort_name
      if org
        {
          id: org.id,
          name: org.name,
          sort_name: OrgSelection::SearchService.name_without_alias(name: org.name)
        }
      else 
        nil
      end
    end

  end
end