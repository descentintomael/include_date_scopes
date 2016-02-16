module IncludeDateScopes
  module DefineTimestampScopes
 
    def define_timestamp_scopes_for(column_name, prepend_name = false)
      prefix = prepend_name ? "#{column_name}_" : ""
      t = self.arel_table

      define_singleton_method :"#{prefix}between" do |start_date_or_time, stop_date_or_time|
        # If start_date_or_time is a Date, the interval INCLUDES the start of the day; otherwise, the interval INCLUDES the argument time.
        # If stop_date_or_time is a Date, the interval INCLUDES the end date; otherwise, the interval EXCLUDES the argument time.
        # For example between(Date.today, Date.today) is equivalent to between(Date.today.midnight, Date.tomorrow.midnight).
        start_time = (start_date_or_time.is_a?(Date) ? start_date_or_time.to_time : start_date_or_time)
        stop_time = (stop_date_or_time.is_a?(Date) ? stop_date_or_time.to_time + 1.day : stop_date_or_time )
        where(t[column_name].gteq(start_time).and(t[column_name].lt stop_time))
      end

      define_singleton_method :"#{prefix}on_or_before_date" do |date|
        where( t[column_name].lt date.to_date.tomorrow.midnight.gmtime )
      end

      define_singleton_method :"#{prefix}on_or_before" do |time|
        if time.is_a?(Date)
          where(t[column_name].lt time.to_time + 1.day)
        else
          where(t[column_name].lteq time)
        end
      end

      define_singleton_method :"#{prefix}before" do |time| 
        where(t[column_name].lt time)
      end

      define_singleton_method :"#{prefix}on_or_after_date" do |time|
        where(t[column_name].gteq time.to_date.midnight.gmtime ) # TODO: Why .gmtime here?
      end

      define_singleton_method :"#{prefix}on_or_after" do |time|
        where(t[column_name].gteq time.to_time)
      end

      define_singleton_method :"#{prefix}after" do |time|
        if time.is_a?(Date)
          where(t[column_name].gteq time.to_time + 1.day)
        else
          where(t[column_name].gt time)
        end
      end

      define_singleton_method :"#{prefix}on" do |day| 
        __send__(:"#{prefix}between", day.to_date, day.to_date)
      end

      define_singleton_method :"#{prefix}last_24_hours" do
        __send__(:"#{prefix}last_day")
      end

      [:minute, :hour].each do |time_unit|
        define_singleton_method :"#{prefix}next_#{time_unit}" do
         __send__(:"#{prefix}between", Time.now, 1.send(time_unit).from_now)
        end

        define_singleton_method :"#{prefix}last_#{time_unit}" do
          __send__(:"#{prefix}between", 1.send(time_unit).ago, Time.now + 1.second)
        end
      end

      [:seconds, :minutes, :hours].each do |time_unit|
        define_singleton_method :"#{prefix}last_n_#{time_unit}" do |count|
          __send__(:"#{prefix}between", count.send(time_unit).ago, Time.now + 1.second)
        end

        define_singleton_method :"#{prefix}next_n_#{time_unit}" do |count|
          __send__(:"#{prefix}between", Time.now, count.send(time_unit).from_now)
        end
      end

      define_singleton_method :"#{prefix}this_minute" do
        start_time = Time.now.change(sec: 0)
        __send__(:"#{prefix}between", start_time, start_time + 1.minute)
      end

      [:hour, :day, :week, :month, :year].each do |time_unit|
        define_singleton_method :"#{prefix}this_#{time_unit}" do
          start_time = Time.now.send(:"beginning_of_#{time_unit}")
          __send__(:"#{prefix}between", start_time, start_time.send(:"end_of_#{time_unit}"))
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

