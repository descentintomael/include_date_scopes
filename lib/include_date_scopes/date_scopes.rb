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

      def include_date_scopes_for(column, prepend_name = false)
        return unless self.table_exists?
        if self.columns_hash[column.to_s].type == :datetime
          define_timestamp_scopes_for column, prepend_name
        elsif self.columns_hash[column.to_s].type == :date
          define_date_scopes_for column, prepend_name
        end
      end

      def include_named_date_scopes_for(column)
        include_date_scopes_for column, true
      end
    end
  end
end

