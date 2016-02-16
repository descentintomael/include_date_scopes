
module IncludeDateScopes
  module DefineCommonScopes
    def define_common_scopes(prefix, column_name)
      define_singleton_method :"#{prefix}day" do |day|
        __send__(:"#{prefix}on", day)
      end

      define_singleton_method :"#{prefix}today" do
        __send__(:"#{prefix}on", Date.today)
      end

      define_singleton_method :"#{prefix}yesterday" do
        __send__(:"#{prefix}on", Date.yesterday)
      end

      define_singleton_method :"#{prefix}tomorrow" do
        __send__(:"#{prefix}on", Date.tomorrow)
      end

      [:day, :week, :month, :year].each do |time_unit|
        define_singleton_method :"#{prefix}next_#{time_unit}" do
          now = Time.now
          __send__(:"#{prefix}between", now, now + 1.send(time_unit))
        end
        define_singleton_method :"#{prefix}last_#{time_unit}" do
          now = Time.now
          __send__(:"#{prefix}between", now - 1.send(time_unit), now + 1.second)
        end
        define_singleton_method :"#{prefix}next_n_#{time_unit}s" do |count|
          now = Time.now
          __send__(:"#{prefix}between", now, now + count.send(time_unit))
        end
        define_singleton_method :"#{prefix}last_n_#{time_unit}s" do |count|
          now = Time.now
          __send__(:"#{prefix}between", now - count.send(time_unit), now + 1.second)
        end
      end

      define_singleton_method :"#{prefix}last_30_days" do
        __send__(:"#{prefix}last_n_days", 30)
      end

      define_singleton_method :"#{prefix}most_recent" do
        order("#{column_name} desc")
      end
    end
  end
end
