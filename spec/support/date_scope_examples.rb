
shared_examples "date scopes" do |date_column = :created_at, prefix = '' |
  let(:test_class) { Post }
  describe "date scopes" do
    before(:all) { Timecop.freeze Time.local(2013,02,15,06,30) }

    let(:last_year_obj) { test_class.create! date_column => 1.year.ago }
    let(:last_month_obj) { test_class.create! date_column => 1.month.ago.to_date }
    let(:beginning_of_month_obj) { test_class.create! date_column => Date.today.beginning_of_month }
    let(:last_week_obj) { test_class.create! date_column => 7.days.ago.to_date }
    let(:beginning_of_week_obj) { test_class.create! date_column => Date.today.beginning_of_week }
    let(:yesterday_obj) { test_class.create! date_column => Date.yesterday }
    let(:today_obj) { test_class.create! date_column => Date.today }

    describe ":between" do
      subject { test_class.send("#{prefix}between", 2.days.ago.to_date, Date.yesterday) }

      it { should_not include last_week_obj }
      it { should include yesterday_obj }
      it { should_not include today_obj }
    end

    describe ":after" do
      subject { test_class.send("#{prefix}after", 2.days.ago.to_date) }

      it { should_not include last_week_obj }
      it { should include yesterday_obj }
      it { should include today_obj }
    end

    describe ":before" do
      subject { test_class.send("#{prefix}before", Date.today) }

      it { should include last_week_obj }
      it { should include yesterday_obj }
      it { should_not include today_obj }
    end

    describe ":today" do
      subject { test_class.send("#{prefix}today") }

      it { should_not include last_week_obj }
      it { should_not include yesterday_obj }
      it { should include today_obj }
    end

    describe ":yesterday" do
      subject { test_class.send("#{prefix}yesterday") }

      it { should_not include last_week_obj }
      it { should include yesterday_obj }
      it { should_not include today_obj }
    end

    describe ":last_week" do
      subject { test_class.send("#{prefix}last_week") }

      it { should_not include last_week_obj }
      it { should include yesterday_obj }
      it { should include today_obj }
    end

    describe ":last_month" do
      subject { test_class.send("#{prefix}last_month") }

      it { should_not include last_year_obj }
      it { should_not include last_month_obj }
      it { should include last_week_obj }
      it { should include yesterday_obj }
    end

    describe ":last_year" do
      subject { test_class.send("#{prefix}last_year") }

      it { should_not include last_year_obj }
      it { should include last_month_obj }
      it { should include last_week_obj }
      it { should include yesterday_obj }
    end

    describe 'last_n_days' do
      subject { test_class.send("#{prefix}last_n_days", 3) }

      let(:after_threshold_obj) { test_class.create! date_column => 4.days.ago }
      let(:on_threshold_obj) { test_class.create! date_column => 3.days.ago }
      let(:before_threshold_obj) { test_class.create! date_column => 2.days.ago }

      it { should_not include after_threshold_obj }
      it { should include on_threshold_obj }
      it { should include before_threshold_obj }
    end

    describe 'last_n_months' do
      subject { test_class.send("#{prefix}last_n_months", 3) }

      let(:after_threshold_obj) { test_class.create! date_column => 4.months.ago }
      let(:on_threshold_obj) { test_class.create! date_column => 3.months.ago }
      let(:before_threshold_obj) { test_class.create! date_column => 2.months.ago }

      it { should_not include after_threshold_obj }
      it { should include on_threshold_obj }
      it { should include before_threshold_obj }
    end

    describe 'last_n_years' do
      subject { test_class.send("#{prefix}last_n_years", 3) }

      let(:after_threshold_obj) { test_class.create! date_column => 4.years.ago }
      let(:on_threshold_obj) { test_class.create! date_column => 3.years.ago }
      let(:before_threshold_obj) { test_class.create! date_column => 2.years.ago }

      it { should_not include after_threshold_obj }
      it { should include on_threshold_obj }
      it { should include before_threshold_obj }
    end

    describe 'next_n_days' do
      subject { test_class.send("#{prefix}next_n_days", 3) }

      let(:after_threshold_obj) { test_class.create! date_column => 2.days.from_now }
      let(:on_threshold_obj) { test_class.create! date_column => 3.days.from_now }
      let(:before_threshold_obj) { test_class.create! date_column => 4.days.from_now }

      it { should include after_threshold_obj }
      it { should include on_threshold_obj }
      it { should_not include before_threshold_obj }
    end

    describe 'next_n_months' do
      subject { test_class.send("#{prefix}next_n_months", 3) }

      let(:after_threshold_obj) { test_class.create! date_column => 2.months.from_now }
      let(:on_threshold_obj) { test_class.create! date_column => 3.months.from_now }
      let(:before_threshold_obj) { test_class.create! date_column => 4.months.from_now }

      it { should include after_threshold_obj }
      it { should include on_threshold_obj }
      it { should_not include before_threshold_obj }
    end

    describe 'next_n_years' do
      subject { test_class.send("#{prefix}next_n_years", 3) }

      let(:after_threshold_obj) { test_class.create! date_column => 2.years.from_now }
      let(:on_threshold_obj) { test_class.create! date_column => 3.years.from_now }
      let(:before_threshold_obj) { test_class.create! date_column => 4.years.from_now }

      it { should include after_threshold_obj }
      it { should include on_threshold_obj }
      it { should_not include before_threshold_obj }
    end

    describe ":last_30_days" do
      subject { test_class.send("#{prefix}last_30days") }

      it { should_not include last_month_obj }
      it { should include last_week_obj }
      it { should include yesterday_obj }
    end

    describe ":this_week" do
      subject { test_class.send("#{prefix}this_week") }

      let(:before_week) { test_class.create! date_column => Date.today.beginning_of_week - 1.minute }
      let(:at_beginning_of_week) { test_class.create! date_column => Date.today.beginning_of_week }
      let(:after_week) { test_class.create! date_column => Date.today.beginning_of_week + 1.minute }

      it { should_not include before_week }
      it { should include at_beginning_of_week }
      it { should include after_week }
    end

    describe ":this_month" do
      subject { test_class.send("#{prefix}this_month") }

      let(:before_month) { test_class.create! date_column => Date.today.beginning_of_month - 1.minute }
      let(:at_beginning_of_month) { test_class.create! date_column => Date.today.beginning_of_month }
      let(:after_month) { test_class.create! date_column => Date.today.beginning_of_month + 1.minute }

      it { should_not include before_month }
      it { should include at_beginning_of_month }
      it { should include after_month }
    end

    describe ":this_year" do
      subject { test_class.send("#{prefix}this_year") }

      let(:before_year) { test_class.create! date_column => Date.today.beginning_of_year - 1.minute }
      let(:at_beginning_of_year) { test_class.create! date_column => Date.today.beginning_of_year }
      let(:after_year) { test_class.create! date_column => Date.today.beginning_of_year + 1.minute }

      it { should_not include before_year }
      it { should include at_beginning_of_year }
      it { should include after_year }
    end
  end
end

