shared_examples "between date scope" do |name|
  # agruments may be Date or Time values
  # top_threshold and bottom_threshold should be Date values

  subject { test_class.send("#{prefix}#{name}", *arguments).to_a }

  before do
    # puts "#{prefix}#{name}: #{arguments.to_s}"
    # puts test_class.send("#{prefix}#{name}", *arguments).to_sql
  end

  let(:before_threshold_obj) { test_class.create! date_column => top_threshold.to_date - 1.day }
  let(:at_top_threshold_obj) { test_class.create! date_column => top_threshold.to_date }
  let(:at_bottom_threshold_obj) { test_class.create! date_column => bottom_threshold.to_date }
  let(:after_threshold_obj) { test_class.create! date_column => bottom_threshold.to_date + 1.day }

  it { should_not include before_threshold_obj }
  it { should include at_top_threshold_obj }
  it { should include at_bottom_threshold_obj }
  it { should_not include after_threshold_obj }
end

shared_examples "before date scope" do |name|
  # agruments may be Date or Time values
  # threshold should be a Date value

  subject { test_class.send("#{prefix}#{name}", *arguments).to_a }

  # threshold is most recent date NOT included in the interval
  let(:before_top_threshold_obj) { test_class.create! date_column => threshold - 1.day }
  let(:at_top_threshold_obj) { test_class.create! date_column => threshold }

  before do
    # puts "#{prefix}#{name}: #{arguments.to_s}"
    # puts test_class.send("#{prefix}#{name}", *arguments).to_sql
  end

  it { should include before_top_threshold_obj }
  it { should_not include at_top_threshold_obj }
end

shared_examples "after date scope" do |name|
  subject { test_class.send("#{prefix}#{name}", *arguments).to_a }

  # threshold is oldest date included in the interval
  let(:before_top_threshold_obj) { test_class.create! date_column => threshold - 1.day }
  let(:at_top_threshold_obj) { test_class.create! date_column => threshold }

  before do
    # puts "#{prefix}#{name}: #{arguments.to_s}"
    # puts test_class.send("#{prefix}#{name}", *arguments).to_sql
  end

  it { should_not include before_top_threshold_obj }
  it { should include at_top_threshold_obj }
end

shared_examples "date scopes" do |date_column = :show_until, prefix = '' |
  let(:test_class) { Post }
  let(:prefix) { prefix }
  let(:date_column) { date_column }

    [:to_date, :to_time].each do |postfix|
      describe ":between" do
        let(:top_threshold) { 6.days.ago.to_date }
        let(:bottom_threshold) { 3.days.ago.to_date }
        let(:arguments) { [6.days.ago.send(postfix), 3.day.ago.send(postfix)] }
        include_examples 'between date scope','between'
      end

      describe ":before" do
        let(:threshold) { 3.days.ago.to_date }
        let(:arguments) { [ 3.days.ago.send(postfix) ] }
        include_examples 'before date scope','before'
      end

      describe ":on_or_before" do
        let(:threshold) { 2.days.ago.to_date }
        let(:arguments) { [ 3.days.ago.send(postfix) ] }
        include_examples 'before date scope','on_or_before'
      end

      describe ":after" do
        let(:threshold) { 2.days.ago.to_date }
        let(:arguments) { [ 3.days.ago.send(postfix) ] }
        include_examples 'after date scope','after'
      end

      describe ":on_or_after" do
        let(:threshold) { 3.days.ago.to_date }
        let(:arguments) { [ 3.days.ago.send(postfix) ] }
        include_examples 'after date scope','on_or_after'
      end

    end

  describe "date scopes" do

    describe ":today" do
      let(:top_threshold) { Date.today }
      let(:bottom_threshold) { Date.today }
      let(:arguments) { [] }
      include_examples 'between date scope','today'
    end

    describe ":yesterday" do
      let(:top_threshold) { Date.yesterday }
      let(:bottom_threshold) { Date.yesterday }
      let(:arguments) { [] }
      include_examples 'between date scope','yesterday'
    end

    describe ":tomorrow" do
      let(:top_threshold) { Date.tomorrow }
      let(:bottom_threshold) { Date.tomorrow }
      let(:arguments) { [] }
      include_examples 'between date scope','tomorrow'
    end

    describe ":next_day" do
      let(:top_threshold) { Date.today }
      let(:bottom_threshold) { Date.tomorrow }
      let(:arguments) { [] }
      include_examples 'between date scope','next_day'
    end

    describe ":next_week" do
      let(:top_threshold) { Date.today }
      let(:bottom_threshold) { Date.today + 1.week }
      let(:arguments) { [] }
      include_examples 'between date scope','next_week'
    end

    describe ":next_month" do
      let(:top_threshold) { Date.today }
      let(:bottom_threshold) { Date.today + 1.month }
      let(:arguments) { [] }
      include_examples 'between date scope','next_month'
    end

    describe ":next_year" do
      let(:top_threshold) { Date.today }
      let(:bottom_threshold) { Date.today + 1.year }
      let(:arguments) { [] }
      include_examples 'between date scope','next_year'
    end

    describe ":last_day" do
      let(:top_threshold) { Date.yesterday }
      let(:bottom_threshold) { Date.today }
      let(:arguments) { [] }
      include_examples 'between date scope','last_day'
    end

    describe ":last_week" do
      let(:top_threshold) { Date.today - 1.week }
      let(:bottom_threshold) { Date.today }
      let(:arguments) { [] }
      include_examples 'between date scope','last_week'
    end

    describe ":last_month" do
      let(:top_threshold) { Date.today - 1.month }
      let(:bottom_threshold) { Date.today }
      let(:arguments) { [] }
      include_examples 'between date scope','last_month'
    end

    describe ":last_year" do
      let(:top_threshold) { Date.today - 1.year }
      let(:bottom_threshold) { Date.today }
      let(:arguments) { [] }
      include_examples 'between date scope','last_year'
    end

    describe ":last_n_days" do
      let(:top_threshold) { Date.today - 3.days }
      let(:bottom_threshold) { Date.today }
      let(:arguments) { [3] }
      include_examples 'between date scope','last_n_days'
    end

    describe ":last_n_weeks" do
      let(:top_threshold) { Date.today - 3.weeks }
      let(:bottom_threshold) { Date.today }
      let(:arguments) { [3] }
      include_examples 'between date scope','last_n_weeks'
    end

    describe ":last_n_months" do
      let(:top_threshold) { Date.today - 3.months }
      let(:bottom_threshold) { Date.today }
      let(:arguments) { [3] }
      include_examples 'between date scope','last_n_months'
    end

    describe ":last_n_years" do
      let(:top_threshold) { Date.today - 3.years }
      let(:bottom_threshold) { Date.today }
      let(:arguments) { [3] }
      include_examples 'between date scope','last_n_years'
    end

    describe ":next_n_days" do
      let(:top_threshold) { Date.today }
      let(:bottom_threshold) { Date.today + 3.days }
      let(:arguments) { [3] }
      include_examples 'between date scope','next_n_days'
    end

    describe ":next_n_weeks" do
      let(:top_threshold) { Date.today }
      let(:bottom_threshold) { Date.today + 3.weeks }
      let(:arguments) { [3] }
      include_examples 'between date scope','next_n_weeks'
    end

    describe ":next_n_months" do
      let(:top_threshold) { Date.today }
      let(:bottom_threshold) { Date.today + 3.months }
      let(:arguments) { [3] }
      include_examples 'between date scope','next_n_months'
    end

    describe ":next_n_years" do
      let(:top_threshold) { Date.today }
      let(:bottom_threshold) { Date.today + 3.years }
      let(:arguments) { [3] }
      include_examples 'between date scope','next_n_years'
    end

    describe ":last_30_days" do
      let(:top_threshold) { Date.today - 30.days }
      let(:bottom_threshold) { Date.today }
      let(:arguments) { [] }
      include_examples 'between date scope','last_30_days'
    end

    describe ":this_day" do
      let(:top_threshold) { Date.today }
      let(:bottom_threshold) { Date.today }
      let(:arguments) { [] }
      include_examples 'between date scope','this_day'
    end

    describe ":this_week" do
      let(:top_threshold) { Date.today.beginning_of_week }
      let(:bottom_threshold) { Date.today.end_of_week }
      let(:arguments) { [] }
      include_examples 'between date scope','this_week'
    end

    describe ":this_month" do
      let(:top_threshold) { Date.today.beginning_of_month }
      let(:bottom_threshold) { Date.today.end_of_month }
      let(:arguments) { [] }
      include_examples 'between date scope','this_month'
    end

    describe ":this_year" do
      let(:top_threshold) { Date.today.beginning_of_year }
      let(:bottom_threshold) { Date.today.end_of_year }
      let(:arguments) { [] }
      include_examples 'between date scope','this_year'
    end
  end
end

