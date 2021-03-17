# frozen_string_literal: true

module Filterable
  extend ActiveSupport::Concern
  included do
    # SQL TYPES
    DATE_SQL_TYPE   = 'date'
    STRING_SQL_TYPE = 'character varying'
    DATETIME_SQL_TYPE = 'timestamp(6) without time zone'

    # String Fields Scopes
    scope :with_field_equal, lambda { |field_name, field_value|
      field_name = prepare_column_name(field_name)
      where("#{field_name} = ?", field_value.to_s) if field_name
    }

    scope :with_field_like, lambda { |field_name, field_value|
      field_name = prepare_column_name(field_name)
      where("#{field_name} ilike ?", "%#{field_value}%") if field_name
    }

    scope :with_field_starts, lambda { |field_name, field_value|
      field_name = prepare_column_name(field_name)
      where("#{field_name} ilike ?", "#{field_value}%") if field_name
    }

    scope :with_field_ends, lambda { |field_name, field_value|
      field_name = prepare_column_name(field_name)
      where("#{field_name} ilike ?", "%#{field_value}") if field_name
    }

    # Date Fields Scopes
    scope :with_date_between, lambda { |field_name, start_date, end_date|
      field_name = prepare_column_name(field_name, DATE_SQL_TYPE)
      where("#{field_name} >= ? AND #{field_name} <= ?", start_date, end_date) if field_name
    }

    scope :with_date_before, lambda { |field_name, field_value|
      field_name = prepare_column_name(field_name, DATE_SQL_TYPE)
      where("#{field_name} <= ?", field_value) if field_name
    }

    scope :with_date_after, lambda { |field_name, field_value|
      field_name = prepare_column_name(field_name, DATE_SQL_TYPE)
      where("#{field_name} >= ?", field_value) if field_name
    }

    # Datetime Fields Scopes
    scope :with_datetime_between, lambda { |field_name, start_datetime, end_datetime|
      field_name = prepare_column_name(field_name, DATETIME_SQL_TYPE)
      where("#{field_name} >= ? AND #{field_name} <= ?", start_datetime, end_datetime) if field_name
    }

    scope :with_datetime_before, lambda { |field_name, field_value|
      field_name = prepare_column_name(field_name, DATETIME_SQL_TYPE)
      where("#{field_name} <= ?", field_value) if field_name
    }

    scope :with_datetime_after, lambda { |field_name, field_value|
      field_name = prepare_column_name(field_name, DATETIME_SQL_TYPE)
      where("#{field_name} >= ?", field_value) if field_name
    }

    # TODO: Construct from filters hash

    def self.construst_filters(filters)
      scope = all
      scope = construnct_from_strings(scope, filters['strings']) if filters['strings']
      scope = construnct_from_date(scope, filters['date']) if filters['date']
      scope = construnct_from_datetime(scope, filters['datetime']) if filters['datetime']
    end

    def self.construnct_from_strings(scope = all, filters)
      filters.reduce(scope) do |filter|
      end
    end

    def self.construnct_from_date(scope = all, filters)
      filters.reduce(scope) do |filter|
      end
    end

    def self.construnct_from_datetime(scope = all, filters)
      filters.reduce(scope) do |filter|
      end
    end

    def self.prepare_column_name(field_name, type = STRING_SQL_TYPE)
      column_names = User.columns.map do |field|
        field.name if field.sql_type == type
      end

      return unless column_names.include? field_name

      ActiveRecord::Base.connection.quote_column_name(field_name) if column_names.include? field_name
    end
  end
end
