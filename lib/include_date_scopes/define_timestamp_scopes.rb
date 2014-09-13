
module IncludeDateScopes
  module DefineTimestampScopes
    def define_timestamp_scopes_for(column_name, prepend_name = false)
      prefix = prepend_name ? "#{column_name}_" : ""
      t = self.arel_table

      define_singleton_method :"#{prefix}between" do |start_date_or_time, stop_date_or_time|
        start_time = (start_date_or_time.is_a?(Date) ? start_date_or_time.to_time : start_date_or_time)
        stop_time = (stop_date_or_time.is_a?(Date) ? stop_date_or_time.to_time + 1.day : stop_date_or_time )
        where(t[column_name].gteq(start_time).and(t[column_name].lteq stop_time))
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
        __send__(:"#{prefix}last_day")
      end

      define_singleton_method :"#{prefix}next_minute" do
        __send__(:"#{prefix}between", Time.now, 1.minute.from_now)
      end

      define_singleton_method :"#{prefix}next_hour" do
        __send__(:"#{prefix}between", Time.now, 1.hour.from_now)
      end

      define_singleton_method :"#{prefix}last_minute" do
        __send__(:"#{prefix}between", 1.minute.ago, Time.now)
      end

      define_singleton_method :"#{prefix}last_hour" do
        __send__(:"#{prefix}between", 1.hour.ago, Time.now)
      end

      define_singleton_method :"#{prefix}last_n_seconds" do |count|
        __send__(:"#{prefix}between", count.seconds.ago, Time.now)
      end

      define_singleton_method :"#{prefix}last_n_minutes" do |count|
        __send__(:"#{prefix}between", count.minutes.ago, Time.now)
      end

      define_singleton_method :"#{prefix}last_n_hours" do |count|
        __send__(:"#{prefix}between", count.hours.ago, Time.now)
      end

      define_singleton_method :"#{prefix}next_n_seconds" do |count|
        __send__(:"#{prefix}between", Time.now, count.seconds.from_now)
      end

      define_singleton_method :"#{prefix}next_n_minutes" do |count|
        __send__(:"#{prefix}between", Time.now, count.minutes.from_now)
      end

      define_singleton_method :"#{prefix}next_n_hours" do |count|
        __send__(:"#{prefix}between", Time.now, count.hours.from_now)
      end

      define_singleton_method :"#{prefix}this_minute" do
        __send__(:"#{prefix}between", Time.now.change(sec: 0), Time.now.change(sec: 59, usec: Rational(999999999, 1000)))
      end

      define_singleton_method :"#{prefix}this_hour" do
        __send__(:"#{prefix}between", 1.hour.ago.end_of_hour, Time.now.end_of_hour)
      end

      define_singleton_method :"#{prefix}this_day" do
        __send__(:"#{prefix}between", 1.day.ago.end_of_day, Time.now.end_of_day)
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
  end
end

