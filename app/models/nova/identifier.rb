module Nova 
  # frozen_string_literal: true

  # == Schema Information
  #
  # Table name: identifiers
  #
  #  id                   :integer          not null, primary key
  #  attrs                :text
  #  identifiable_type    :string
  #  value                :string           not null
  #  created_at           :datetime
  #  updated_at           :datetime
  #  identifiable_id      :integer
  #  identifier_scheme_id :integer          not null
  #
  # Indexes
  #
  #  index_identifiers_on_identifiable_type_and_identifiable_id  (identifiable_type,identifiable_id)
  #

  # Object that represents an identifier for an object
  class Identifier < ApplicationRecord
    # ================
    # = Associations =
    # ================

    belongs_to :identifiable, polymorphic: true

    belongs_to :identifier_scheme, optional: true

    # ===============
    # = Validations =
    # ===============

    validates :value, presence: { message: PRESENCE_MESSAGE }

    validates :identifiable, presence: { message: PRESENCE_MESSAGE }

    validate :value_uniqueness_with_scheme, if: :schemed?

    validate :value_uniqueness_without_scheme, unless: :schemed?

    validates :value, orcid: true, allow_blank: true, if: -> { identifier_scheme&.name == 'orcid' }

    # ===============
    # = Scopes =
    # ===============

    def self.by_scheme_name(scheme, identifiable_type)
      scheme_id = if scheme.instance_of?(IdentifierScheme)
                    scheme.id
                  else
                    IdentifierScheme.by_name(scheme).first&.id
                  end
      where(identifier_scheme_id: scheme_id,
            identifiable_type: identifiable_type)
    end

    # =========================
    # = Custom Accessor Logic =
    # =========================

    # Ensure that the value of attrs is a hash
    # TODO: evaluate this vs the Serialize approach in condition.rb
    def attrs=(hash)
      super(hash.is_a?(Hash) ? hash.to_json.to_s : '{}')
    end

    # Appends the identifier scheme's prefix to the identifier if necessary
    # For example:
    #   value   '0000-0000-0000-0001'
    #   becomes 'https://orcid.org/0000-0000-0000-0001'
    # rubocop:disable Metrics/AbcSize
    def value=(val)
      if identifier_scheme&.name == 'orcid'
        orcid_id = Nova::OrcidValidator.extract_orcid_id(val)
        if orcid_id && Nova::OrcidValidator.orcid_id_is_valid?(orcid_id)
          prefix = ENV["ORCID_SANDBOX"] ? 'https://sandbox.orcid.org/' : identifier_scheme.identifier_prefix
          val = prefix + orcid_id
        end
      end
      super(val)
    end
    # rubocop:enable Metrics/AbcSize

    # ===========================
    # = Public instance methods =
    # ===========================

    # Determines the format of the identifier based on the scheme or value
    def identifier_format
      scheme = identifier_scheme&.name
      return scheme if %w[orcid ror fundref].include?(scheme)

      return 'ark' if value.include?('ark:')

      doi_regex = %r{(doi:)?[0-9]{2}\.[0-9]+/.}
      return 'doi' if value.match?(doi_regex)

      return 'url' if value.starts_with?('http')

      'other'
    end

    # Returns the value sans the identifier scheme's prefix.
    # For example:
    #   value   'https://orcid.org/0000-0000-0000-0001'
    #   becomes '0000-0000-0000-0001'
    def value_without_scheme_prefix
      return value unless identifier_scheme.present? &&
                          identifier_scheme.identifier_prefix.present?

      base = identifier_scheme.identifier_prefix
      value.gsub(base, '').sub(%r{^/}, '')
    end

    private

    # ==============
    # = VALIDATION =
    # ==============

    # Simple check used by :validate methods above
    def schemed?
      identifier_scheme.present?
    end

    # Verify the uniqueness of :value across :identifiable
    def value_uniqueness_without_scheme
      # if scheme is nil, then just unique for identifiable
      return unless Nova::Identifier.where(identifiable: identifiable, value: value).any?

      errors.add(:value, _('must be unique'))
    end

    # Ensure that the identifiable only has one identifier for the scheme
    def value_uniqueness_with_scheme
      if new_record? && Nova::Identifier.where(identifier_scheme: identifier_scheme,
                                        identifiable: identifiable).any?
        errors.add(:identifier_scheme, _('already assigned a value'))
      end
    end
  end
end