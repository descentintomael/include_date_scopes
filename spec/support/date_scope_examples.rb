
shared_examples "between date scope" do |name|
  context 'with time argument' do
    # Not working right now
    # include_examples 'between time scope', name, 1.day
  end

  context 'with date argument' do
    subject do
      test_class.send("#{prefix}#{name}", *arguments).to_a
    end

    let(:after_threshold_obj) { test_class.create! date_column => top_threshold.to_date - 1.second }
    let(:at_top_threshold_obj) { test_class.create! date_column => top_threshold.to_date }
    let(:at_bottom_threshold_obj) { test_class.create! date_column => bottom_threshold.to_date }
    let(:before_threshold_obj) { test_class.create! date_column => bottom_threshold.to_date + 1.second }

    it { should_not include after_threshold_obj }
    it { should include at_top_threshold_obj }
    it { should include at_bottom_threshold_obj }
    it { should_not include before_threshold_obj }
  end
end

shared_examples "date scopes" do |date_column = :show_until, prefix = '' |
  let(:test_class) { Post }
  let(:prefix) { prefix }
  let(:date_column) { date_column }

  describe "date scopes" do
    describe ":between" do
      subject { test_class.send("#{prefix}between", 6.days.ago.to_date, 3.day.ago.to_date).to_a }

      let(:after_threshold_obj) { test_class.create! date_column => 2.days.ago.to_date }
      let(:at_top_threshold_obj) { test_class.create! date_column => 3.days.ago.to_date }
      let(:at_bottom_threshold_obj) { test_class.create! date_column => 6.days.ago.to_date }
      let(:before_threshold_obj) { test_class.create! date_column => 7.days.ago.to_date }

      it { should_not include after_threshold_obj }
      it { should include at_top_threshold_obj }
      it { should include at_bottom_threshold_obj }
      it { should_not include before_threshold_obj }
    end

    describe ":after" do
      subject { test_class.send("#{prefix}after", 3.days.ago.to_date).to_a }

      let(:after_threshold_obj) { test_class.create! date_column => 2.days.ago.to_date }
      let(:on_threshold_obj) { test_class.create! date_column => 3.days.ago.to_date }
      let(:before_threshold_obj) { test_class.create! date_column => 4.days.ago.to_date }

      it { should include after_threshold_obj }
      it { should_not include on_threshold_obj }
      it { should_not include before_threshold_obj }
    end

    describe ":before" do
      subject { test_class.send("#{prefix}before", 3.days.ago.to_date).to_a }

      let(:after_threshold_obj) { test_class.create! date_column => 4.days.ago.to_date }
      let(:on_threshold_obj) { test_class.create! date_column => 3.days.ago.to_date }
      let(:before_threshold_obj) { test_class.create! date_column => 2.days.ago.to_date }

      it { should include after_threshold_obj }
      it { should_not include on_threshold_obj }
      it { should_not include before_threshold_obj }
    end

    describe ":on_or_after" do
      subject { test_class.send("#{prefix}on_or_after", 3.days.ago.to_date).to_a }

      let(:after_threshold_obj) { test_class.create! date_column => 2.days.ago.to_date }
      let(:on_threshold_obj) { test_class.create! date_column => 3.days.ago.to_date }
      let(:before_threshold_obj) { test_class.create! date_column => 4.days.ago.to_date }

      it { should include after_threshold_obj }
      it { should include on_threshold_obj }
      it { should_not include before_threshold_obj }
    end

    describe ":on_or_before" do
      subject { test_class.send("#{prefix}on_or_before", 3.days.ago).to_a }

      let(:after_threshold_obj) { test_class.create! date_column => 4.days.ago.to_date }
      let(:on_threshold_obj) { test_class.create! date_column => 3.days.ago.to_date }
      let(:before_threshold_obj) { test_class.create! date_column => 2.days.ago.to_date }

      it { should include after_threshold_obj }
      it { should include on_threshold_obj }
      it { should_not include before_threshold_obj }
    end

    describe ":today" do
      let(:top_threshold) { Time.now.beginning_of_day }
      let(:bottom_threshold) { Time.now.end_of_day }
      let(:arguments) { [] }
      include_examples 'between date scope','today'
    end

    describe ":yesterday" do
      let(:top_threshold) { 1.day.ago.beginning_of_day }
      let(:bottom_threshold) { 1.day.ago.end_of_day }
      let(:arguments) { [] }
      include_examples 'between date scope','yesterday'
    end

    describe ":tomorrow" do
      let(:top_threshold) { 1.day.from_now.beginning_of_day }
      let(:bottom_threshold) { 1.day.from_now.end_of_day }
      let(:arguments) { [] }
      include_examples 'between date scope','tomorrow'
    end

    describe ":next_day" do
      let(:bottom_threshold) { 1.day.from_now }
      let(:top_threshold) { Time.now }
      let(:arguments) { [] }
      include_examples 'between date scope','next_day'
    end

    describe ":next_week" do
      let(:bottom_threshold) { 1.week.from_now }
      let(:top_threshold) { Time.now }
      let(:arguments) { [] }
      include_examples 'between date scope','next_week'
    end

    describe ":next_month" do
      let(:bottom_threshold) { 1.month.from_now }
      let(:top_threshold) { Time.now }
      let(:arguments) { [] }
      include_examples 'between date scope','next_month'
    end

    describe ":next_year" do
      let(:bottom_threshold) { 1.year.from_now }
      let(:top_threshold) { Time.now }
      let(:arguments) { [] }
      include_examples 'between date scope','next_year'
    end

    describe ":last_day" do
      let(:top_threshold) { 1.day.ago }
      let(:bottom_threshold) { Time.now }
      let(:arguments) { [] }
      include_examples 'between date scope','last_day'
    end

    describe ":last_week" do
      let(:top_threshold) { 1.week.ago }
      let(:bottom_threshold) { Time.now }
      let(:arguments) { [] }
      include_examples 'between date scope','last_week'
    end

    describe ":last_month" do
      let(:top_threshold) { 1.month.ago }
      let(:bottom_threshold) { Time.now }
      let(:arguments) { [] }
      include_examples 'between date scope','last_month'
    end

    describe ":last_year" do
      let(:top_threshold) { 1.year.ago }
      let(:bottom_threshold) { Time.now }
      let(:arguments) { [] }
      include_examples 'between date scope','last_year'
    end

    describe ":last_n_days" do
      let(:top_threshold) { 3.days.ago }
      let(:bottom_threshold) { Time.now }
      let(:arguments) { [3] }
      include_examples 'between date scope','last_n_days'
    end

    describe ":last_n_weeks" do
      let(:top_threshold) { 3.weeks.ago }
      let(:bottom_threshold) { Time.now }
      let(:arguments) { [3] }
      include_examples 'between date scope','last_n_weeks'
    end

    describe ":last_n_months" do
      let(:top_threshold) { 3.months.ago }
      let(:bottom_threshold) { Time.now }
      let(:arguments) { [3] }
      include_examples 'between date scope','last_n_months'
    end

    describe ":last_n_years" do
      let(:top_threshold) { 3.years.ago }
      let(:bottom_threshold) { Time.now }
      let(:arguments) { [3] }
      include_examples 'between date scope','last_n_years'
    end

    describe ":next_n_days" do
      let(:top_threshold) { Time.now }
      let(:bottom_threshold) { 3.days.from_now }
      let(:arguments) { [3] }
      include_examples 'between date scope','next_n_days'
    end

    describe ":next_n_weeks" do
      let(:top_threshold) { Time.now }
      let(:bottom_threshold) { 3.weeks.from_now }
      let(:arguments) { [3] }
      include_examples 'between date scope','next_n_weeks'
    end

    describe ":next_n_months" do
      let(:top_threshold) { Time.now }
      let(:bottom_threshold) { 3.months.from_now }
      let(:arguments) { [3] }
      include_examples 'between date scope','next_n_months'
    end

    describe ":next_n_years" do
      let(:top_threshold) { Time.now }
      let(:bottom_threshold) { 3.years.from_now }
      let(:arguments) { [3] }
      include_examples 'between date scope','next_n_years'
    end

    describe ":last_30_days" do
      let(:top_threshold) { 30.days.ago }
      let(:bottom_threshold) { Time.now }
      let(:arguments) { [] }
      include_examples 'between date scope','last_30_days'
    end

    describe ":this_day" do
      let(:top_threshold) { Time.now.beginning_of_day }
      let(:bottom_threshold) { Time.now.end_of_day }
      let(:arguments) { [] }
      include_examples 'between date scope','this_day'
    end

    describe ":this_week" do
      let(:top_threshold) { Time.now.beginning_of_week }
      let(:bottom_threshold) { Time.now.end_of_week }
      let(:arguments) { [] }
      include_examples 'between date scope','this_week'
    end

    describe ":this_month" do
      let(:top_threshold) { Time.now.beginning_of_month }
      let(:bottom_threshold) { Time.now.end_of_month }
      let(:arguments) { [] }
      include_examples 'between date scope','this_month'
    end

    describe ":this_year" do
      let(:top_threshold) { Time.now.beginning_of_year }
      let(:bottom_threshold) { Time.now.end_of_year }
      let(:arguments) { [] }
      include_examples 'between date scope','this_year'
    end
  end
end

