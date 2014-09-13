
module IncludeDateScopes
  module DefineDateScopes
    def define_date_scopes_for(column_name, prepend_name = false)
      prefix = prepend_name ? "#{column_name}_" : ""
      t = self.arel_table

      define_singleton_method :"#{prefix}between" do |start_date, stop_date|
        where(t[column_name].gteq(start_date.to_date).and(t[column_name].lteq(stop_date.to_date)))
      end

      {:on_or_before => :lteq, :before => :lt, :on_or_after => :gteq, :after => :gt, :on => :eq}.each do |label, op|
        define_singleton_method :"#{prefix}#{label}" do |date| 
          where t[column_name].send op, date.to_date
        end
      end

      define_singleton_method :"#{prefix}this_day" do
        __send__(:"#{prefix}today")
      end

      [:week, :month, :year].each do |time_unit|
        define_singleton_method :"#{prefix}this_#{time_unit}" do
          __send__(:"#{prefix}between", Date.today.send(:"beginning_of_#{time_unit}"), Date.today.send(:"end_of_#{time_unit}"))
        end
      end

      define_common_scopes t, prefix, column_name
    end
  end
end