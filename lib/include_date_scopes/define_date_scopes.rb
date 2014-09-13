
module IncludeDateScopes
  module DefineDateScopes
    def define_date_scopes_for(column_name, prepend_name = false)
      prefix = prepend_name ? "#{column_name}_" : ""
      t = self.arel_table

      define_singleton_method :"#{prefix}between" do |start_date, stop_date|
        where(t[column_name].gteq(start_date.to_date).and(t[column_name].lteq(stop_date.to_date)))
      end

      define_singleton_method :"#{prefix}on_or_before" do |date| 
        where t[column_name].lteq date.to_date
      end

      define_singleton_method :"#{prefix}before" do |date| 
        where t[column_name].lt date.to_date
      end

      define_singleton_method :"#{prefix}on_or_after" do |date|
        where t[column_name].gteq date.to_date
      end

      define_singleton_method :"#{prefix}after" do |date| 
        where t[column_name].gt date.to_date
      end

      define_singleton_method :"#{prefix}on" do |date|
        where t[column_name].eq date.to_date
      end

      define_singleton_method :"#{prefix}this_day" do
        __send__(:"#{prefix}today")
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

  end
end
