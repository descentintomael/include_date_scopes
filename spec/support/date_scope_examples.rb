
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


    describe ":last_30_days" do
      subject { test_class.send("#{prefix}last_30days") }

      it { should_not include last_month_obj }
      it { should include last_week_obj }
      it { should include yesterday_obj }
    end

    describe ":this_week" do
      subject { test_class.send("#{prefix}this_week") }

      it { should_not include last_week_obj }
      it { should include beginning_of_week_obj }
      it { should include yesterday_obj }
      it { should include today_obj }
    end

    describe ":this_month" do
      subject { test_class.send("#{prefix}this_month") }

      it { should_not include last_month_obj }
      it { should include beginning_of_month_obj }
      it { should include beginning_of_week_obj }
      it { should include last_week_obj }
      it { should include yesterday_obj }
    end
  end
end

