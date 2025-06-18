module Nova

  class OrcidValidator < ActiveModel::EachValidator
    
    def validate_each(record, attribute, value)
      return if value.blank?

      unless self.class.orcid_id_is_valid?(value)
        record.errors.add(attribute, 'ORCID iD is invalid')
      end
    end

    def self.orcid_id_is_valid?(orcid_id)
      digits = orcid_id.gsub("-", "") 
      total = 0
      # compute checksum
      digits.each_char do |char| 
        total = (total * 2 + char.to_i) % 11
      end
      check_digit = (12 - total % 11) % 11
      check_digit = check_digit == 10 ? 'X' : check_digit.to_s
      # verify check digit
      check_digit == digits[-1]
    end

    def self.extract_orcid_id(orcid)
      # Match and extract just the ORCID iD (with hyphens)
      orcid_pattern = /(\d{4}-\d{4}-\d{4}-\d{3}[0-9X])/
      match = orcid.match(orcid_pattern)
      match ? match[1] : nil  # Return the ORCID ID if valid, otherwise nil
    end

  end

end