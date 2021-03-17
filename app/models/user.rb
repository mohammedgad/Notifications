# frozen_string_literal: true

class User < ApplicationRecord
  AVAILABLE_FILTERS = %w[
    with_locale
    search_name_query
    search_email_query
    search_phone_query
    with_birthdate_before
    with_birthdate_after
  ].freeze

  scope :with_locale, ->(locale) { where(locale: locale) if locale.present? }
  scope :search_name_query, lambda { |query|
    return nil if query.blank?

    query = "%#{query}%"
    where('name ILIKE ?', query)
  }

  scope :search_email_query, lambda { |query|
    return nil if query.blank?

    query = "%#{query}%"
    where('email ILIKE ?', query)
  }

  scope :search_phone_query, lambda { |query|
    return nil if query.blank?

    query = "%#{query}%"
    where('phone ILIKE ?', query)
  }

  scope :with_birthdate_before, lambda { |date|
    return nil if date.blank?

    where('birthdate <= ?', date)
  }

  scope :with_birthdate_after, lambda { |date|
    return nil if date.blank?

    where('birthdate >= ?', date)
  }

  def self.construst_query_from_filters(filters)
    filters.reduce(all) do |scope, (filter_key, filter_value)|
      if AVAILABLE_FILTERS.include? filter_key
        scope.send(filter_key, filter_value)
      else
        scope
      end
    end
  end
end
