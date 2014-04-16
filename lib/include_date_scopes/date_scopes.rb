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

module IncludeDateScopes
  module DateScopes
    extend ActiveSupport::Concern
    module ClassMethods
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

      protected

      def define_timestamp_scopes_for(column_name, prepend_name = false)
        prefix = prepend_name ? "#{column_name}_" : ""
        t = self.arel_table

        define_singleton_method :"#{prefix}between" do |start_date_or_time, stop_date_or_time|
          start_time = (start_date_or_time.is_a?(Date) ? start_date_or_time.to_time : start_date_or_time)
          stop_time = (stop_date_or_time.is_a?(Date) ? stop_date_or_time.to_time + 1.day : stop_date_or_time )
          where(t[column_name].gteq(start_time).and(t[column_name].lt stop_time))
        end

        define_singleton_method :"#{prefix}on_or_before_date" do |date|
          where( t[column_name].lt date.to_date.tomorrow.midnight.gmtime )
        end

        define_singleton_method :"#{prefix}on_or_before" do |time| 
          where(t[column_name].lte (time.is_a?(Date) ? time.to_time : time))
        end

        define_singleton_method :"#{prefix}before" do |time| 
          where(t[column_name].lt (time.is_a?(Date) ? time.to_time : time))
        end

        define_singleton_method :"#{prefix}on_or_after_date" do |time|
          where(t[column_name].gteq time.to_date.midnight.gmtime )
        end

        define_singleton_method :"#{prefix}on_or_after" do |time|
          where(t[column_name].gteq (time.is_a?(Date) ? time.to_time + 1.day : time ))
        end

        define_singleton_method :"#{prefix}after" do |time|
          where(t[column_name].gt (time.is_a?(Date) ? time.to_time + 1.day : time ))
        end

        define_singleton_method :"#{prefix}on" do |day| 
          __send__(:"#{prefix}between", day.midnight, (day + 1.day).midnight)
        end

        define_singleton_method :"#{prefix}day" do |day| 
          __send__(:"#{prefix}on", day)
        end

        define_singleton_method :"#{prefix}last_24_hours" do
          __send__(:"#{prefix}after", 24.hours.ago)
        end

        define_singleton_method :"#{prefix}last_hour" do
          __send__(:"#{prefix}after", 1.hour.ago)
        end

        define_singleton_method :"#{prefix}last_week" do
          __send__(:"#{prefix}after", 1.week.ago)
        end

        define_singleton_method :"#{prefix}last_30days" do
          __send__(:"#{prefix}after", 30.days.ago)
        end

        define_singleton_method :"#{prefix}today" do
          __send__(:"#{prefix}on", Date.today)
        end

        define_singleton_method :"#{prefix}this_week" do
          __send__(:"#{prefix}between", (Date.today - Date.today.wday.days).midnight, (Date.today + 1.day).midnight)
        end

        define_singleton_method :"#{prefix}this_month" do
          __send__(:"#{prefix}between", (Date.today.at_beginning_of_month).midnight, (Date.today + 1.day).midnight)
        end

        define_singleton_method :"#{prefix}yesterday" do
          __send__(:"#{prefix}on", Date.yesterday)
        end

        define_singleton_method :"#{prefix}most_recent" do
          order("#{column_name} desc")
        end

      end

      def define_date_scopes_for(column_name, prepend_name = false)
        prefix = prepend_name ? "#{column_name}_" : ""

        define_singleton_method :"#{prefix}between" do |start_date, stop_date|
          where(t[column_name].gteq(start_date).and(t[column_name].lte stop_date))
        end

        define_singleton_method :"#{prefix}on_or_before" do |date| 
          where( t[column_name].lte date )
        end

        define_singleton_method :"#{prefix}before" do |date| 
          where(t[column_name].lt date)
        end

        define_singleton_method :"#{prefix}on_or_after" do |date|
          where(t[column_name].gteq date)
        end

        define_singleton_method :"#{prefix}after" do |date| 
          where(t[column_name].gt date)
        end

        define_singleton_method :"#{prefix}on" do |date|
          where(t[column_name].eq date)
        end

        define_singleton_method :"#{prefix}day" do |day|
          __send__(:"#{prefix}on", day)
        end

        define_singleton_method :"#{prefix}today" do
          __send__(:"#{prefix}on", Date.today)
        end

        define_singleton_method :"#{prefix}last_week" do
          __send__(:"#{prefix}after", 1.week.ago)
        end

        define_singleton_method :"#{prefix}last_30days" do
          __send__(:"#{prefix}after", 30.days.ago)
        end

        define_singleton_method :"#{prefix}yesterday" do
          __send__(:"#{prefix}on", Date.yesterday)
        end

        define_singleton_method :"#{prefix}most_recent" do
          order("#{column_name} desc")
        end

      end
    end
  end
end
  # 
  # module DateScopes
  #   extend ActiveSupport::Concern
  #   
  #   module ClassMethods
  #     def include_date_scopes
  #       include_date_scopes_for :created_at
  #     end
  # 
  #     def include_date_scopes_for(column, prepend_name = false)
  #       return unless self.table_exists?
  #       if self.columns_hash[column.to_s].try(:type) == :datetime
  #         define_timestamp_scopes_for column, prepend_name
  #       elsif self.columns_hash[column.to_s].try(:type) == :date
  #         define_date_scopes_for column, prepend_name
  #       end
  #     end
  # 
  #     def include_named_date_scopes_for(column)
  #       include_date_scopes_for column, true
  #     end
  # 
  #     protected
  # 
  #     def process_timestamp_argument(arg, inclusive_range = false)
  #       if arg.is_a?(Time) || arg.is_a?(DateTime)
  #         return arg
  #       elsif arg.is_a?(Date) && inclusive_range
  #         return arg + 1.day
  #       elsif arg.is_a?(Date) && !inclusive_range
  #         return arg
  #       else
  #         raise ArgumentError, "Unexpected argument class for timestamp scope: #{arg.class.name}"
  #       end
  #     end
  # 
  #     def process_date_argument(arg)
  #       if arg.is_a?(Time) || arg.is_a?(DateTime)
  #         return arg.to_date
  #       elsif arg.is_a?(Date)
  #         return arg
  #       else
  #         raise ArgumentError, "Unexpected argument class for timestamp scope: #{arg.class.name}"
  #       end
  #     end
  # 
  #     def define_timestamp_scopes_for(column_name, prepend_name = false)
  #       prefix = prepend_name ? "#{column_name}_" : ""
  # 
  #       define_singleton_method :"#{prefix}before" do |time,inclusive=false|
  #         time = process_timestamp_argument(time, inclusive)
  #         if inclusive
  #           where{__send__(column_name).lte time}
  #         else
  #           where{__send__(column_name).lt time}
  #         end
  #       end
  # 
  #       define_singleton_method :"#{prefix}after" do |time, inclusive=false|
  #         time = process_timestamp_argument(time, inclusive)
  #         if inclusive
  #           where{__send__(column_name).gte time}
  #         else
  #           where{__send__(column_name).gt time}
  #         end
  #       end
  # 
  #       define_singleton_method :"#{prefix}between" do |start_time, stop_time|
  #         on_or_after(start_time).on_or_before(stop_time)
  #       end
  # 
  #       define_singleton_method :"#{prefix}on_or_after" do |time|
  #         after(time,true)
  #       end
  # 
  #       define_singleton_method :"#{prefix}on_or_before" do |time|
  #         before(time,true)
  #       end
  # 
  #       define_singleton_method :"#{prefix}on_or_before_date" do |time|
  #         on_or_before(time.to_date)
  #       end
  # 
  #       define_singleton_method :"#{prefix}on_or_after_date" do |time|
  #         on_or_after(time)
  #       end
  # 
  #       define_singleton_method :"#{prefix}on" do |day|
  #         between(day.midnight, (day + 1.day).midnight)
  #       end
  # 
  #       define_singleton_method :"#{prefix}day" do |day|
  #         on(day)
  #       end
  # 
  #       define_singleton_method :"#{prefix}last_24_hours" do
  #         after(24.hours.ago)
  #       end
  # 
  #       define_singleton_method :"#{prefix}last_hour" do
  #         after(1.hour.ago)
  #       end
  # 
  #       define_singleton_method :"#{prefix}last_week" do
  #         after(1.week.ago)
  #       end
  # 
  #       define_singleton_method :"#{prefix}last_30days" do
  #         after(30.days.ago)
  #       end
  # 
  #       define_singleton_method :"#{prefix}today" do
  #         on(Date.today)
  #       end
  # 
  #       define_singleton_method :"#{prefix}this_week" do
  #         between((Date.today - Date.today.wday.days).midnight, (Date.today + 1.day).midnight)
  #       end
  # 
  #       define_singleton_method :"#{prefix}this_month" do
  #         between((Date.today.at_beginning_of_month).midnight, (Date.today + 1.day).midnight)
  #       end
  # 
  #       define_singleton_method :"#{prefix}yesterday" do
  #         on(Date.yesterday)
  #       end
  # 
  #       define_singleton_method :"#{prefix}most_recent" do
  #         order("#{column_name} desc")
  #       end
  # 
  #     end
  # 
  #     def define_date_scopes_for(column_name, prepend_name = false)
  #       prefix = prepend_name ? "#{column_name}_" : ""
  # 
  #       define_singleton_method :"#{prefix}before" do |date,inclusive=false|
  #         date = process_date_argument(date)
  #         if inclusive
  #           where{__send__(column_name).lte date}
  #         else
  #           where{__send__(column_name).lt date}
  #         end
  #       end
  # 
  #       define_singleton_method :"#{prefix}after" do |date, inclusive=false|
  #         date = process_date_argument(date)
  #         if inclusive
  #           where{__send__(column_name).gte date}
  #         else
  #           where{__send__(column_name).gt date}
  #         end
  #       end
  # 
  #       define_singleton_method :"#{prefix}on" do |date|
  #         date = process_date_argument(date)
  #         where{__send__(column_name).eq date}
  #       end
  # 
  #       define_singleton_method :"#{prefix}between" do |start_date, stop_date|
  #         on_or_after(start_date).on_or_before(stop_date)
  #       end
  # 
  #       define_singleton_method :"#{prefix}on_or_before" do |date|
  #         before(date,true)
  #       end
  # 
  #       define_singleton_method :"#{prefix}on_or_after" do |date|
  #         after(date,true)
  #       end
  # 
  #       define_singleton_method :"#{prefix}day" do |day|
  #         on(day)
  #       end
  # 
  #       define_singleton_method :"#{prefix}today" do
  #         on(Date.today)
  #       end
  # 
  #       define_singleton_method :"#{prefix}last_week" do
  #         after(1.week.ago)
  #       end
  # 
  #       define_singleton_method :"#{prefix}last_30days" do
  #         after(30.days.ago)
  #       end
  # 
  #       define_singleton_method :"#{prefix}yesterday" do
  #         on(Date.yesterday)
  #       end
  # 
  #       define_singleton_method :"#{prefix}most_recent" do
  #         order("#{column_name} desc")
  #       end
  # 
  #     end
  #   end
  # end

