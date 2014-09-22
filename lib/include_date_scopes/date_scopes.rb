require 'pry'
# Add the below date based scopes to a model.
#
#   between(start_date_or_time, stop_date_or_time)
#   on_or_before(date)
#   before(date)
#   on_or_after(date)
#   after(date)
#   on(date)
#   day(date)
#   last_24_hours()   * DateTime only
#   last_hour()       * DateTime only
#   last_week()
#   last_month()
#   today()
#   yesterday()
#   most_recent()     * this is an order by, not a filter
#
# Example usage (from Payment):
#
#   include_date_scopes_for :payment_date                        # default date scope -- ex: Payment.on(date)
#   include_date_scopes_for :net_payment_settlement_date, true   # prepend field name -- ex: Payment.net_payment_settlement_date_on(date)
#
#
require_relative 'define_timestamp_scopes'
require_relative 'define_date_scopes'
require_relative 'define_common_scopes'

module IncludeDateScopes
  module DateScopes
    extend ActiveSupport::Concern
    module ClassMethods
      include IncludeDateScopes::DefineTimestampScopes
      include IncludeDateScopes::DefineDateScopes
      include IncludeDateScopes::DefineCommonScopes

      def include_date_scopes
        include_date_scopes_for :created_at
      end

      def include_date_scopes_for(column,
                                  prepend_name = false,
                                  column_type = nil)
        column_type ||= column_type_for(column)
        return unless self.table_exists?
        if column_type == :datetime
          define_timestamp_scopes_for column, prepend_name
        elsif column_type == :date
          define_date_scopes_for column, prepend_name
        end
      rescue
        warn "Not including date scopes for #{column} because of an error: #{$!.message}"
      end

      def include_named_date_scopes_for(column)
        include_date_scopes_for column, true
      end

      def column_type_for(column)
        # raise "Cannot find column #{column}" unless columns_hash.include? column.to_s
        columns_hash[column.to_s].type
      end
    end
  end
end

