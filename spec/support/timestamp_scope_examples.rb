shared_examples "between time scope" do |name, difference = 1.second|
    subject do
      test_class.send("#{prefix}#{name}", *arguments).to_a
    end

    # In tests top_threshold and bottom_threshold should have time values,
    # where the interval includes top_threshold but EXCLUDES bottom_threshold
    let(:before_top_threshold_obj) { test_class.create! date_column => top_threshold.to_time - difference }
    let(:at_top_threshold_obj) { test_class.create! date_column => top_threshold.to_time }
    let(:before_bottom_threshold_obj) { test_class.create! date_column => bottom_threshold.to_time - difference }
    let(:at_bottom_threshold_obj) { test_class.create! date_column => bottom_threshold.to_time }

    before do
      # puts "#{prefix}#{name}: #{arguments.to_s}"
      # puts test_class.send("#{prefix}#{name}", *arguments).to_sql
    end

    it { should_not include before_top_threshold_obj }
    it { should include at_top_threshold_obj }
    it { should include before_bottom_threshold_obj }
    it { should_not include at_bottom_threshold_obj }
end

shared_examples "before time scope" do |name|
  subject { test_class.send("#{prefix}#{name}", *arguments).to_a }

  # threshold is NOT included in the interval
  let(:before_top_threshold_obj) { test_class.create! date_column => threshold - 1.second }
  let(:at_top_threshold_obj) { test_class.create! date_column => threshold }

  before do
    # puts "#{prefix}#{name}: #{arguments.to_s}"
    # puts test_class.send("#{prefix}#{name}", *arguments).to_sql
  end

  it { should include before_top_threshold_obj }
  it { should_not include at_top_threshold_obj }
end

shared_examples "after time scope" do |name|
  subject { test_class.send("#{prefix}#{name}", *arguments).to_a }

  # threshold is included in the interval
  let(:before_top_threshold_obj) { test_class.create! date_column => threshold - 1.second }
  let(:at_top_threshold_obj) { test_class.create! date_column => threshold }

  before do
    # puts "#{prefix}#{name}: #{arguments.to_s}"
    # puts test_class.send("#{prefix}#{name}", *arguments).to_sql
  end

  it { should_not include before_top_threshold_obj }
  it { should include at_top_threshold_obj }
end

shared_examples "timestamp scopes" do |date_column = :created_at, prefix = '' |
  let(:test_class) { Post }
  let(:prefix) { prefix }
  let(:date_column) { date_column }

  describe "timestamp arguments" do
    describe ':between' do
      let(:top_threshold) { 5.minutes.ago }
      let(:bottom_threshold) { 5.minutes.from_now }
      let(:arguments) { [5.minutes.ago, 5.minutes.from_now] }
      include_examples "between time scope", 'between'
    end

    describe ":after" do
      let(:threshold) { 5.minutes.ago + 1.second }
      let(:arguments) { [ 5.minutes.ago ] }

      include_examples 'after time scope', 'after'
    end

    describe ":before" do
      let(:threshold) { 5.minutes.ago }
      let(:arguments) { [ 5.minutes.ago ] }

      include_examples 'before time scope', 'before'
    end

    describe ":on_or_after" do
      let(:threshold) { 5.minutes.ago }
      let(:arguments) { [ 5.minutes.ago ] }

      include_examples 'after time scope', 'on_or_after'
    end

    describe ":on_or_before" do
      let(:threshold) { 5.minutes.ago + 1.second }
      let(:arguments) { [ 5.minutes.ago ] }

      include_examples 'before time scope', 'on_or_before'
    end
  end

  describe "date arguments" do
    describe ":between" do
      let(:top_threshold) { Date.today.midnight }
      let(:bottom_threshold) { Date.today.midnight + 1.day }
      let(:arguments) { [Date.today, Date.today] }
      include_examples "between time scope", 'between'
    end

    describe ":on_or_before_date" do
      let(:threshold) { Date.tomorrow.midnight }
      let(:arguments) { [ Date.today ] }

      include_examples 'before time scope', 'on_or_before_date'
    end

    describe ":on_or_before" do
      let(:threshold) { Date.tomorrow.midnight }
      let(:arguments) { [ Date.today ] }

      include_examples 'before time scope', 'on_or_before'
    end

    describe ":before" do
      let(:threshold) { Date.today.midnight }
      let(:arguments) { [ Date.today ] }

      include_examples 'before time scope', 'before'
    end

    describe ":on_or_after_date" do
      let(:threshold) { Date.today.midnight }
      let(:arguments) { [ Date.today ] }

      include_examples 'after time scope', 'on_or_after_date'
    end

    describe ":on_or_after" do
      let(:threshold) { Date.today.midnight }
      let(:arguments) { [ Date.today ] }

      include_examples 'after time scope', 'on_or_after'
    end

    describe ":after" do
      let(:threshold) { Date.tomorrow.midnight }
      let(:arguments) { [ Date.today ] }

      include_examples 'after time scope', 'after'
    end

    describe ":on" do
      let(:top_threshold) { Date.today.midnight }
      let(:bottom_threshold) { Date.tomorrow.midnight }
      let(:arguments) { [ Date.today ] }

      include_examples "between time scope", 'on'
    end
  end

  describe "implicit argument" do
    describe ":today" do
      let(:top_threshold) { Time.now.beginning_of_day }
      let(:bottom_threshold) { Time.now.beginning_of_day + 1.day }
      let(:arguments) { [] }
      include_examples 'between time scope','today'
    end

    describe ":yesterday" do
      let(:top_threshold) { 1.day.ago.beginning_of_day }
      let(:bottom_threshold) { Time.now.beginning_of_day }
      let(:arguments) { [] }
      include_examples 'between time scope','yesterday'
    end

    describe ":tomorrow" do
      let(:top_threshold) { 1.day.from_now.beginning_of_day }
      let(:bottom_threshold) { 2.day.from_now.beginning_of_day }
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
      let(:bottom_threshold) { Time.now + 1.second }
      let(:arguments) { [] }
      include_examples 'between time scope','last_minute'
    end

    describe ":last_hour" do
      let(:top_threshold) { 1.hour.ago }
      let(:bottom_threshold) { Time.now + 1.second }
      let(:arguments) { [] }
      include_examples 'between time scope','last_hour'
    end

    describe ":last_24_hours" do
      let(:top_threshold) { 1.day.ago }
      let(:bottom_threshold) { Time.now + 1.second }
      let(:arguments) { [] }
      include_examples 'between time scope','last_24_hours'
    end

    describe ":last_day" do
      let(:top_threshold) { 1.day.ago }
      let(:bottom_threshold) { Time.now + 1.second }
      let(:arguments) { [] }
      include_examples 'between time scope','last_day'
    end

    describe ":last_week" do
      let(:top_threshold) { 1.week.ago }
      let(:bottom_threshold) { Time.now + 1.second }
      let(:arguments) { [] }
      include_examples 'between time scope','last_week'
    end

    describe ":last_month" do
      let(:top_threshold) { 1.month.ago }
      let(:bottom_threshold) { Time.now + 1.second }
      let(:arguments) { [] }
      include_examples 'between time scope','last_month'
    end

    describe ":last_year" do
      let(:top_threshold) { 1.year.ago }
      let(:bottom_threshold) { Time.now + 1.second }
      let(:arguments) { [] }
      include_examples 'between time scope','last_year'
    end

    describe ":last_n_seconds" do
      let(:top_threshold) { 3.seconds.ago }
      let(:bottom_threshold) { Time.now + 1.second }
      let(:arguments) { [3] }
      include_examples 'between time scope','last_n_seconds'
    end

    describe ":last_n_minutes" do
      let(:top_threshold) { 3.minutes.ago }
      let(:bottom_threshold) { Time.now + 1.second }
      let(:arguments) { [3] }
      include_examples 'between time scope','last_n_minutes'
    end

    describe ":last_n_hours" do
      let(:top_threshold) { 3.hours.ago }
      let(:bottom_threshold) { Time.now + 1.second }
      let(:arguments) { [3] }
      include_examples 'between time scope','last_n_hours'
    end

    describe ":last_n_days" do
      let(:top_threshold) { 3.days.ago }
      let(:bottom_threshold) { Time.now + 1.second }
      let(:arguments) { [3] }
      include_examples 'between time scope','last_n_days'
    end

    describe ":last_n_weeks" do
      let(:top_threshold) { 3.weeks.ago }
      let(:bottom_threshold) { Time.now + 1.second }
      let(:arguments) { [3] }
      include_examples 'between time scope','last_n_weeks'
    end

    describe ":last_n_months" do
      let(:top_threshold) { 3.months.ago }
      let(:bottom_threshold) { Time.now + 1.second }
      let(:arguments) { [3] }
      include_examples 'between time scope','last_n_months'
    end

    describe ":last_n_years" do
      let(:top_threshold) { 3.years.ago }
      let(:bottom_threshold) { Time.now + 1.second }
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
      let(:bottom_threshold) { Time.now + 1.second }
      let(:arguments) { [] }
      include_examples 'between time scope','last_30_days'
    end

    describe ":this_minute" do
      let(:top_threshold) { Time.now.change(sec: 0) }
      let(:bottom_threshold) { Time.now.change(sec: 0) + 1.minute }
      let(:arguments) { [] }
      include_examples 'between time scope','this_minute'
    end

    describe ":this_hour" do
      let(:top_threshold) { Time.now.beginning_of_hour }
      let(:bottom_threshold) { Time.now.beginning_of_hour + 1.hour }
      let(:arguments) { [] }
      include_examples 'between time scope','this_hour'
    end

    describe ":this_day" do
      let(:top_threshold) { Time.now.beginning_of_day }
      let(:bottom_threshold) { Time.now.beginning_of_day + 1.day }
      let(:arguments) { [] }
      include_examples 'between time scope','this_day'
    end

    describe ":this_week" do
      let(:top_threshold) { Time.now.beginning_of_week }
      let(:bottom_threshold) { Time.now.beginning_of_week + 1.week }
      let(:arguments) { [] }
      include_examples 'between time scope','this_week'
    end

    describe ":this_month" do
      let(:top_threshold) { Time.now.beginning_of_month }
      let(:bottom_threshold) { Time.now.beginning_of_month + 1.month }
      let(:arguments) { [] }
      include_examples 'between time scope','this_month'
    end

    describe ":this_year" do
      let(:top_threshold) { Time.now.beginning_of_year }
      let(:bottom_threshold) { Time.now.beginning_of_year + 1.year }
      let(:arguments) { [] }
      include_examples 'between time scope','this_year'
    end
  end
end

