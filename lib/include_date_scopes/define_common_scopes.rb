
module IncludeDateScopes
  module DefineCommonScopes
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

      define_singleton_method :"#{prefix}tomorrow" do
        __send__(:"#{prefix}on", Date.tomorrow)
      end

      define_singleton_method :"#{prefix}next_day" do
        __send__(:"#{prefix}between", Time.now, 1.day.from_now)
      end

      define_singleton_method :"#{prefix}next_week" do
        __send__(:"#{prefix}between", Time.now, 1.week.from_now)
      end

      define_singleton_method :"#{prefix}next_month" do
        __send__(:"#{prefix}between", Time.now, 1.month.from_now)
      end

      define_singleton_method :"#{prefix}next_year" do
        __send__(:"#{prefix}between", Time.now, 1.year.from_now)
      end

      define_singleton_method :"#{prefix}last_day" do
        __send__(:"#{prefix}between", 1.day.ago, Time.now)
      end

      define_singleton_method :"#{prefix}last_week" do
        __send__(:"#{prefix}between", 1.week.ago, Time.now)
      end

      define_singleton_method :"#{prefix}last_month" do
        __send__(:"#{prefix}between", 1.month.ago, Time.now)
      end

      define_singleton_method :"#{prefix}last_year" do
        __send__(:"#{prefix}between", 1.year.ago, Time.now)
      end

      define_singleton_method :"#{prefix}last_n_days" do |count|
        __send__(:"#{prefix}between", count.days.ago, Time.now)
      end

      define_singleton_method :"#{prefix}last_n_weeks" do |count|
        __send__(:"#{prefix}between", count.weeks.ago, Time.now)
      end

      define_singleton_method :"#{prefix}last_n_months" do |count|
        __send__(:"#{prefix}between", count.months.ago, Time.now)
      end

      define_singleton_method :"#{prefix}last_n_years" do |count|
        __send__(:"#{prefix}between", count.years.ago, Time.now)
      end

      define_singleton_method :"#{prefix}next_n_days" do |count|
        __send__(:"#{prefix}between", Time.now, count.days.from_now)
      end

      define_singleton_method :"#{prefix}next_n_weeks" do |count|
        __send__(:"#{prefix}between", Time.now, count.weeks.from_now)
      end

      define_singleton_method :"#{prefix}next_n_months" do |count|
        __send__(:"#{prefix}between", Time.now, count.months.from_now)
      end

      define_singleton_method :"#{prefix}next_n_years" do |count|
        __send__(:"#{prefix}between", Time.now, count.years.from_now)
      end

      define_singleton_method :"#{prefix}last_30_days" do
        __send__(:"#{prefix}between", 30.days.ago, Time.now)
      end

      define_singleton_method :"#{prefix}most_recent" do
        order("#{column_name} desc")
      end
    end
  end
end
