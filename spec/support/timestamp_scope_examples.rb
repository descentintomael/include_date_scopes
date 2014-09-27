
shared_examples "between time scope" do |name, difference = 1.second|
    subject do
      test_class.send "#{prefix}#{name}", *arguments
    end

    let(:after_threshold_obj) { test_class.create! date_column => top_threshold - difference }
    let(:at_top_threshold_obj) { test_class.create! date_column => top_threshold }
    let(:at_bottom_threshold_obj) { test_class.create! date_column => bottom_threshold }
    let(:before_threshold_obj) { test_class.create! date_column => bottom_threshold + difference }

    it { should_not include after_threshold_obj }
    it { should include at_top_threshold_obj }
    it { should_not include at_bottom_threshold_obj }
    it { should_not include before_threshold_obj }
end

shared_examples "open ended time scope (exclusive)" do |name|
  subject { test_class.send("#{prefix}#{name}", *arguments) }

  let(:after_threshold_obj) { test_class.create! date_column => threshold + 1.second }
  let(:on_threshold_obj) { test_class.create! date_column => threshold }
  let(:before_threshold_obj) { test_class.create! date_column => threshold - 1.second }

  it { should include after_threshold_obj }
  it { should_not include on_threshold_obj }
  it { should_not include before_threshold_obj }
end

shared_examples "timestamp scopes" do |date_column = :created_at, prefix = '' |
  let(:test_class) { Post }
  let(:prefix) { prefix }
  let(:date_column) { date_column }

  describe "timestamp scopes" do
    describe ':between' do
      let(:top_threshold) { 5.minutes.ago }
      let(:bottom_threshold) { 5.minutes.from_now }
      let(:arguments) { [5.minutes.ago, 5.minutes.from_now] }
      include_examples "between time scope", 'between'
    end

    describe ":after" do
      let(:threshold) { 5.minutes.ago }
      let(:arguments) { [ 5.minutes.ago ] }

      include_examples 'open ended time scope (exclusive)', 'after'
    end

    describe ":before" do

      subject { test_class.send("#{prefix}before", 5.minutes.ago) }

      let(:after_threshold_obj) { test_class.create! date_column => 5.minutes.ago + 1.second }
      let(:on_threshold_obj) { test_class.create! date_column => 5.minutes.ago }
      let(:before_threshold_obj) { test_class.create! date_column => 5.minutes.ago - 1.second }

      it { should_not include after_threshold_obj }
      it { should_not include on_threshold_obj }
      it { should include before_threshold_obj }
    end

    describe ":on_or_after" do
      subject { test_class.send("#{prefix}on_or_after", 5.minutes.ago) }

      let(:after_threshold_obj) { test_class.create! date_column => 5.minutes.ago + 1.second }
      let(:on_threshold_obj) { test_class.create! date_column => 5.minutes.ago }
      let(:before_threshold_obj) { test_class.create! date_column => 5.minutes.ago - 1.second }

      it { should include after_threshold_obj }
      it { should include on_threshold_obj }
      it { should_not include before_threshold_obj }
    end

    describe ":on_or_before" do
      subject { test_class.send("#{prefix}on_or_before", 5.minutes.ago) }

      let(:after_threshold_obj) { test_class.create! date_column => 5.minutes.ago + 1.second }
      let(:on_threshold_obj) { test_class.create! date_column => 5.minutes.ago }
      let(:before_threshold_obj) { test_class.create! date_column => 5.minutes.ago - 1.second }

      it { should_not include after_threshold_obj }
      it { should include on_threshold_obj }
      it { should include before_threshold_obj }
    end

    describe ":today" do
      let(:top_threshold) { Time.now.beginning_of_day }
      let(:bottom_threshold) { Time.now.end_of_day }
      let(:arguments) { [] }
      include_examples 'between time scope','today'
    end

    describe ":yesterday" do
      let(:top_threshold) { 1.day.ago.beginning_of_day }
      let(:bottom_threshold) { 1.day.ago.end_of_day }
      let(:arguments) { [] }
      include_examples 'between time scope','yesterday'
    end

    describe ":tomorrow" do
      let(:top_threshold) { 1.day.from_now.beginning_of_day }
      let(:bottom_threshold) { 1.day.from_now.end_of_day }
      let(:arguments) { [] }
      include_examples 'between time scope','tomorrow'
    end

    describe ":next_minute" do
      let(:bottom_threshold) { 1.minute.from_now }
      let(:top_threshold) { Time.now }
      let(:arguments) { [] }
      include_examples 'between time scope','next_minute'
    end

    describe ":next_hour" do
      let(:bottom_threshold) { 1.hour.from_now }
      let(:top_threshold) { Time.now }
      let(:arguments) { [] }
      include_examples 'between time scope','next_hour'
    end

    describe ":next_day" do
      let(:bottom_threshold) { 1.day.from_now }
      let(:top_threshold) { Time.now }
      let(:arguments) { [] }
      include_examples 'between time scope','next_day'
    end

    describe ":next_week" do
      let(:bottom_threshold) { 1.week.from_now }
      let(:top_threshold) { Time.now }
      let(:arguments) { [] }
      include_examples 'between time scope','next_week'
    end

    describe ":next_month" do
      let(:bottom_threshold) { 1.month.from_now }
      let(:top_threshold) { Time.now }
      let(:arguments) { [] }
      include_examples 'between time scope','next_month'
    end

    describe ":next_year" do
      let(:bottom_threshold) { 1.year.from_now }
      let(:top_threshold) { Time.now }
      let(:arguments) { [] }
      include_examples 'between time scope','next_year'
    end

    describe ":last_minute" do
      let(:top_threshold) { 1.minute.ago }
      let(:bottom_threshold) { Time.now }
      let(:arguments) { [] }
      include_examples 'between time scope','last_minute'
    end

    describe ":last_hour" do
      let(:top_threshold) { 1.hour.ago }
      let(:bottom_threshold) { Time.now }
      let(:arguments) { [] }
      include_examples 'between time scope','last_hour'
    end

    describe ":last_24_hours" do
      let(:top_threshold) { 1.day.ago }
      let(:bottom_threshold) { Time.now }
      let(:arguments) { [] }
      include_examples 'between time scope','last_24_hours'
    end

    describe ":last_day" do
      let(:top_threshold) { 1.day.ago }
      let(:bottom_threshold) { Time.now }
      let(:arguments) { [] }
      include_examples 'between time scope','last_day'
    end

    describe ":last_week" do
      let(:top_threshold) { 1.week.ago }
      let(:bottom_threshold) { Time.now }
      let(:arguments) { [] }
      include_examples 'between time scope','last_week'
    end

    describe ":last_month" do
      let(:top_threshold) { 1.month.ago }
      let(:bottom_threshold) { Time.now }
      let(:arguments) { [] }
      include_examples 'between time scope','last_month'
    end

    describe ":last_year" do
      let(:top_threshold) { 1.year.ago }
      let(:bottom_threshold) { Time.now }
      let(:arguments) { [] }
      include_examples 'between time scope','last_year'
    end

    describe ":last_n_seconds" do
      let(:top_threshold) { 3.seconds.ago }
      let(:bottom_threshold) { Time.now }
      let(:arguments) { [3] }
      include_examples 'between time scope','last_n_seconds'
    end

    describe ":last_n_minutes" do
      let(:top_threshold) { 3.minutes.ago }
      let(:bottom_threshold) { Time.now }
      let(:arguments) { [3] }
      include_examples 'between time scope','last_n_minutes'
    end

    describe ":last_n_hours" do
      let(:top_threshold) { 3.hours.ago }
      let(:bottom_threshold) { Time.now }
      let(:arguments) { [3] }
      include_examples 'between time scope','last_n_hours'
    end

    describe ":last_n_days" do
      let(:top_threshold) { 3.days.ago }
      let(:bottom_threshold) { Time.now }
      let(:arguments) { [3] }
      include_examples 'between time scope','last_n_days'
    end

    describe ":last_n_weeks" do
      let(:top_threshold) { 3.weeks.ago }
      let(:bottom_threshold) { Time.now }
      let(:arguments) { [3] }
      include_examples 'between time scope','last_n_weeks'
    end

    describe ":last_n_months" do
      let(:top_threshold) { 3.months.ago }
      let(:bottom_threshold) { Time.now }
      let(:arguments) { [3] }
      include_examples 'between time scope','last_n_months'
    end

    describe ":last_n_years" do
      let(:top_threshold) { 3.years.ago }
      let(:bottom_threshold) { Time.now }
      let(:arguments) { [3] }
      include_examples 'between time scope','last_n_years'
    end

    describe ":next_n_seconds" do
      let(:top_threshold) { Time.now }
      let(:bottom_threshold) { 3.seconds.from_now }
      let(:arguments) { [3] }
      include_examples 'between time scope','next_n_seconds'
    end

    describe ":next_n_minutes" do
      let(:top_threshold) { Time.now }
      let(:bottom_threshold) { 3.minutes.from_now }
      let(:arguments) { [3] }
      include_examples 'between time scope','next_n_minutes'
    end

    describe ":next_n_hours" do
      let(:top_threshold) { Time.now }
      let(:bottom_threshold) { 3.hours.from_now }
      let(:arguments) { [3] }
      include_examples 'between time scope','next_n_hours'
    end

    describe ":next_n_days" do
      let(:top_threshold) { Time.now }
      let(:bottom_threshold) { 3.days.from_now }
      let(:arguments) { [3] }
      include_examples 'between time scope','next_n_days'
    end

    describe ":next_n_weeks" do
      let(:top_threshold) { Time.now }
      let(:bottom_threshold) { 3.weeks.from_now }
      let(:arguments) { [3] }
      include_examples 'between time scope','next_n_weeks'
    end

    describe ":next_n_months" do
      let(:top_threshold) { Time.now }
      let(:bottom_threshold) { 3.months.from_now }
      let(:arguments) { [3] }
      include_examples 'between time scope','next_n_months'
    end

    describe ":next_n_years" do
      let(:top_threshold) { Time.now }
      let(:bottom_threshold) { 3.years.from_now }
      let(:arguments) { [3] }
      include_examples 'between time scope','next_n_years'
    end

    describe ":last_30_days" do
      let(:top_threshold) { 30.days.ago }
      let(:bottom_threshold) { Time.now }
      let(:arguments) { [] }
      include_examples 'between time scope','last_30_days'
    end

    describe ":this_minute" do
      let(:top_threshold) { Time.now.change(sec: 0) }
      let(:bottom_threshold) { Time.now.change(sec: 59, usec: Rational(999999999, 1000)) }
      let(:arguments) { [] }
      include_examples 'between time scope','this_minute'
    end

    describe ":this_hour" do
      let(:top_threshold) { Time.now.beginning_of_hour }
      let(:bottom_threshold) { Time.now.end_of_hour }
      let(:arguments) { [] }
      include_examples 'between time scope','this_hour'
    end

    describe ":this_day" do
      let(:top_threshold) { Time.now.beginning_of_day }
      let(:bottom_threshold) { Time.now.end_of_day }
      let(:arguments) { [] }
      include_examples 'between time scope','this_day'
    end

    describe ":this_week" do
      let(:top_threshold) { Time.now.beginning_of_week }
      let(:bottom_threshold) { Time.now.end_of_week }
      let(:arguments) { [] }
      include_examples 'between time scope','this_week'
    end

    describe ":this_month" do
      let(:top_threshold) { Time.now.beginning_of_month }
      let(:bottom_threshold) { Time.now.end_of_month }
      let(:arguments) { [] }
      include_examples 'between time scope','this_month'
    end

    describe ":this_year" do
      let(:top_threshold) { Time.now.beginning_of_year }
      let(:bottom_threshold) { Time.now.end_of_year }
      let(:arguments) { [] }
      include_examples 'between time scope','this_year'
    end
  end
end

