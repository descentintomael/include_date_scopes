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
          where(t[column_name].lteq (time.is_a?(Date) ? time.to_time : time))
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
          __send__(:"#{prefix}between", day.beginning_of_day, day.end_of_day)
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

        define_singleton_method :"#{prefix}last_n_seconds" do |count|
          __send__(:"#{prefix}on_or_after", count.seconds.ago)
        end

        define_singleton_method :"#{prefix}last_n_minutes" do |count|
          __send__(:"#{prefix}on_or_after", count.minutes.ago)
        end

        define_singleton_method :"#{prefix}last_n_hours" do |count|
          __send__(:"#{prefix}on_or_after", count.hours.ago)
        end

        define_singleton_method :"#{prefix}next_n_seconds" do |count|
          __send__(:"#{prefix}on_or_before", count.seconds.from_now)
        end

        define_singleton_method :"#{prefix}next_n_minutes" do |count|
          __send__(:"#{prefix}on_or_before", count.minutes.from_now)
        end

        define_singleton_method :"#{prefix}next_n_hours" do |count|
          __send__(:"#{prefix}on_or_before", count.hours.from_now)
        end

        define_singleton_method :"#{prefix}this_minute" do
          __send__(:"#{prefix}between", Time.now.change(sec: 0), Time.now.change(sec: 59, usec: Rational(999999999, 1000)))
        end

        define_singleton_method :"#{prefix}this_hour" do
          __send__(:"#{prefix}between", 1.hour.ago.end_of_hour, Time.now.end_of_hour)
        end

        define_singleton_method :"#{prefix}this_week" do
          __send__(:"#{prefix}between", 1.week.ago.end_of_week, Time.now.end_of_week)
        end

        define_singleton_method :"#{prefix}this_month" do
          __send__(:"#{prefix}between", 1.month.ago.end_of_month, Time.now.end_of_month)
        end

        define_singleton_method :"#{prefix}this_year" do
          __send__(:"#{prefix}between", 1.year.ago.end_of_year, Time.now.end_of_year)
        end

        define_common_scopes t, prefix, column_name
      end

      def define_date_scopes_for(column_name, prepend_name = false)
        prefix = prepend_name ? "#{column_name}_" : ""
        t = self.arel_table

        define_singleton_method :"#{prefix}between" do |start_date, stop_date|
          where(t[column_name].gteq(start_date).and(t[column_name].lteq stop_date))
        end

        define_singleton_method :"#{prefix}on_or_before" do |date| 
          where( t[column_name].lteq date )
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

        define_singleton_method :"#{prefix}this_week" do
          __send__(:"#{prefix}between", Date.today.beginning_of_week, Date.today.end_of_week)
        end

        define_singleton_method :"#{prefix}this_month" do
          __send__(:"#{prefix}between", Date.today.beginning_of_month, Date.today.end_of_month)
        end

        define_singleton_method :"#{prefix}this_year" do
          __send__(:"#{prefix}between", Date.today.beginning_of_year, Date.today.end_of_year)
        end

        define_common_scopes t, prefix, column_name
      end

      def define_common_scopes(arel, prefix, column_name)
        t = arel

        define_singleton_method :"#{prefix}day" do |day|
          __send__(:"#{prefix}on", day)
        end

        define_singleton_method :"#{prefix}today" do
          __send__(:"#{prefix}on", Date.today)
        end

        define_singleton_method :"#{prefix}yesterday" do
          __send__(:"#{prefix}on", Date.yesterday)
        end

        define_singleton_method :"#{prefix}last_week" do
          __send__(:"#{prefix}after", 1.week.ago)
        end

        define_singleton_method :"#{prefix}last_month" do
          __send__(:"#{prefix}after", 1.month.ago)
        end

        define_singleton_method :"#{prefix}last_year" do
          __send__(:"#{prefix}after", 1.year.ago)
        end

        define_singleton_method :"#{prefix}last_n_days" do |count|
          __send__(:"#{prefix}on_or_after", count.days.ago)
        end

        define_singleton_method :"#{prefix}last_n_months" do |count|
          __send__(:"#{prefix}on_or_after", count.months.ago)
        end

        define_singleton_method :"#{prefix}last_n_years" do |count|
          __send__(:"#{prefix}on_or_after", count.years.ago)
        end

        define_singleton_method :"#{prefix}next_n_days" do |count|
          __send__(:"#{prefix}on_or_before", count.days.from_now)
        end

        define_singleton_method :"#{prefix}next_n_months" do |count|
          __send__(:"#{prefix}on_or_before", count.months.from_now)
        end

        define_singleton_method :"#{prefix}next_n_years" do |count|
          __send__(:"#{prefix}on_or_before", count.years.from_now)
        end

        define_singleton_method :"#{prefix}last_30days" do
          __send__(:"#{prefix}after", 30.days.ago)
        end

        define_singleton_method :"#{prefix}most_recent" do
          order("#{column_name} desc")
        end
      end
    end
  end
end

