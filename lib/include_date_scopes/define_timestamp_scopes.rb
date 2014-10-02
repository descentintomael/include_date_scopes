
module IncludeDateScopes
  module DefineTimestampScopes
 
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
        where(t[column_name].lteq time_object(time))
      end

      define_singleton_method :"#{prefix}before" do |time| 
        where(t[column_name].lt time_object(time))
      end

      define_singleton_method :"#{prefix}on_or_after_date" do |time|
        where(t[column_name].gteq time.to_date.midnight.gmtime )
      end

      define_singleton_method :"#{prefix}on_or_after" do |time|
        where(t[column_name].gteq time_object(time))
      end

      define_singleton_method :"#{prefix}after" do |time|
        where(t[column_name].gt (time.is_a?(Date) ? time.to_time + 1.day : time ))
      end

      define_singleton_method :"#{prefix}on" do |day| 
        __send__(:"#{prefix}between", day.beginning_of_day, day.end_of_day)
      end

      define_singleton_method :"#{prefix}last_24_hours" do
        __send__(:"#{prefix}last_day")
      end

      [:minute, :hour].each do |time_unit|
        define_singleton_method :"#{prefix}next_#{time_unit}" do
         __send__(:"#{prefix}between", Time.now, 1.send(time_unit).from_now)
        end

        define_singleton_method :"#{prefix}last_#{time_unit}" do
          __send__(:"#{prefix}between", 1.send(time_unit).ago, Time.now)
        end
      end

      [:seconds, :minutes, :hours].each do |time_unit|
        define_singleton_method :"#{prefix}last_n_#{time_unit}" do |count|
          __send__(:"#{prefix}between", count.send(time_unit).ago, Time.now)
        end

        define_singleton_method :"#{prefix}next_n_#{time_unit}" do |count|
          __send__(:"#{prefix}between", Time.now, count.send(time_unit).from_now)
        end
      end

      define_singleton_method :"#{prefix}this_minute" do
        __send__(:"#{prefix}between", Time.now.change(sec: 0), Time.now.change(sec: 59, usec: Rational(999999999, 1000)))
      end

      [:hour, :day, :week, :month, :year].each do |time_unit|
        define_singleton_method :"#{prefix}this_#{time_unit}" do
          __send__(:"#{prefix}between", 1.send(time_unit).ago.send(:"end_of_#{time_unit}"), Time.now.send(:"end_of_#{time_unit}"))
        end
      end

      define_common_scopes prefix, column_name
    end

    private

    def time_object(time)
      time.is_a?(Date) ? time.to_time + 1.day : time
    end
  end
end

