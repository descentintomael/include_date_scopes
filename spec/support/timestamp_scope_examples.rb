
shared_examples "timestamp scopes" do |date_column = :created_at, prefix = '' |
  let(:test_class) { Post }
  describe "timestamp scopes" do
    before(:all) { Timecop.freeze Time.local(2013,02,15,06,30) }

    let(:last_year_obj) { test_class.create! date_column => 1.year.ago }
    let(:last_month_obj) { test_class.create! date_column => 1.month.ago }
    let(:last_week_obj) { test_class.create! date_column => 1.week.ago }
    let(:next_year_obj) { test_class.create! date_column => 1.year.from_now }
    let(:next_month_obj) { test_class.create! date_column => 1.month.from_now }
    let(:next_week_obj) { test_class.create! date_column => 1.week.from_now }
    let(:yesterday_obj) { test_class.create! date_column => 24.hours.ago }
    let(:hour_ago_obj) { test_class.create! date_column => 1.hour.ago }
    let(:five_minute_ago_obj) { test_class.create! date_column => 5.minutes.ago }
    let(:after_midnight_ago_obj) { test_class.create! date_column => Date.today.beginning_of_day + 5.minutes }
    let(:before_midnight_ago_obj) { test_class.create! date_column => Date.today.beginning_of_day - 5.minutes }
    let(:tomorrow_obj) { test_class.create! date_column => Date.today.end_of_day + 5.minutes }

    describe ":between" do
      context "with DateTime" do
        subject { test_class.send("#{prefix}between", 2.hours.ago, 1.minute.ago) }

        it { should_not include last_week_obj }
        it { should_not include yesterday_obj }
        it { should include hour_ago_obj }
        it { should include five_minute_ago_obj }
      end
      context "with Date" do
        subject { test_class.send("#{prefix}between", 2.days.ago.to_date, Date.today) }

        it { should_not include last_week_obj }
        it { should include yesterday_obj }
        it { should include hour_ago_obj }
        it { should include five_minute_ago_obj }
      end
    end

    describe ":after" do
      context "with DateTime" do
        subject { test_class.send("#{prefix}after", 2.hours.ago) }

        it { should_not include last_week_obj }
        it { should_not include yesterday_obj }
        it { should include hour_ago_obj }
        it { should include five_minute_ago_obj }
      end
      context "with Date" do
        subject { test_class.send("#{prefix}after", 2.days.ago.to_date) }

        it { should_not include last_week_obj }
        it { should include yesterday_obj }
        it { should include hour_ago_obj }
        it { should include five_minute_ago_obj }
      end
    end

    describe ':on_or_after' do
      subject { test_class.send("#{prefix}on_or_after", 1.hour.ago) }

      it { should_not include yesterday_obj }
      it { should include hour_ago_obj }
      it { should include five_minute_ago_obj }
    end

    describe ":on_or_after_date" do
      context "with DateTime" do
        subject { test_class.send("#{prefix}on_or_after_date", 1.hour.ago) }

        it { should_not include last_week_obj }
        it { should_not include yesterday_obj }
        it { should include hour_ago_obj }
        it { should include five_minute_ago_obj }
      end
      context "with Date" do
        subject { test_class.send("#{prefix}on_or_after_date", 2.days.ago.to_date) }

        it { should_not include last_week_obj }
        it { should include yesterday_obj }
        it { should include hour_ago_obj }
        it { should include five_minute_ago_obj }
      end
    end

    describe ":before" do
      context "with DateTime" do
        subject { test_class.send("#{prefix}before", 1.hour.ago) }

        it { should include last_week_obj }
        it { should include yesterday_obj }
        it { should_not include hour_ago_obj }
        it { should_not include five_minute_ago_obj }
      end
      context "with Date" do
        subject { test_class.send("#{prefix}before", Date.today) }

        it { should include last_week_obj }
        it { should include yesterday_obj }
        it { should_not include hour_ago_obj }
        it { should_not include five_minute_ago_obj }
      end
    end

    describe ':on_or_before' do
      subject { test_class.send("#{prefix}on_or_before", 1.hour.ago) }

      it { should include yesterday_obj }
      it { should include hour_ago_obj }
      it { should_not include five_minute_ago_obj }
    end

    describe ":on_or_before_date" do
      context "with DateTime" do
        subject { test_class.send("#{prefix}on_or_before_date", 25.hours.ago) }

        it { should include last_week_obj }
        it { should include yesterday_obj }
        it { should_not include hour_ago_obj }
        it { should_not include five_minute_ago_obj }
      end
      context "with Date" do
        subject { test_class.send("#{prefix}on_or_before_date", Date.yesterday) }

        it { should include last_week_obj }
        it { should include yesterday_obj }
        it { should_not include hour_ago_obj }
        it { should_not include five_minute_ago_obj }
      end
    end

    describe ':on' do
      subject { test_class.send("#{prefix}on", Date.today) }

      it { should_not include before_midnight_ago_obj }
      it { should include after_midnight_ago_obj }
      it { should include five_minute_ago_obj }
      it { should_not include tomorrow_obj }
    end

    describe ":today" do
      subject { test_class.send("#{prefix}today") }

      it { should_not include last_week_obj }
      it { should_not include yesterday_obj }
      it { should include hour_ago_obj }
      it { should include five_minute_ago_obj }
    end

    describe ":yesterday" do
      subject { test_class.send("#{prefix}yesterday") }

      it { should_not include last_week_obj }
      it { should include yesterday_obj }
      it { should_not include hour_ago_obj }
      it { should_not include five_minute_ago_obj }
    end

    describe ":last_24_hours" do
      subject { test_class.send("#{prefix}last_24_hours") }

      it { should_not include last_week_obj }
      it { should_not include yesterday_obj }
      it { should include hour_ago_obj }
      it { should include five_minute_ago_obj }
    end

    describe ":last_hour" do
      subject { test_class.send("#{prefix}last_hour") }

      it { should_not include last_week_obj }
      it { should_not include yesterday_obj }
      it { should_not include hour_ago_obj } # should not because this is exclusive
      it { should include five_minute_ago_obj }
    end

    describe ":last_week" do
      subject { test_class.send("#{prefix}last_week") }

      it { should_not include last_week_obj }
      it { should include yesterday_obj }
      it { should include hour_ago_obj }
      it { should include five_minute_ago_obj }
    end

    describe ":last_month" do
      subject { test_class.send("#{prefix}last_month") }

      it { should_not include last_year_obj }
      it { should_not include last_month_obj }
      it { should include last_week_obj }
      it { should include yesterday_obj }
      it { should include hour_ago_obj }
      it { should include five_minute_ago_obj }
    end

    describe ":last_year" do
      subject { test_class.send("#{prefix}last_year") }

      it { should_not include last_year_obj }
      it { should include last_month_obj }
      it { should include last_week_obj }
      it { should include yesterday_obj }
      it { should include hour_ago_obj }
      it { should include five_minute_ago_obj }
    end


    describe ":last_30_days" do
      subject { test_class.send("#{prefix}last_30days") }

      it { should_not include last_month_obj }
      it { should include last_week_obj }
      it { should include yesterday_obj }
      it { should include hour_ago_obj }
      it { should include five_minute_ago_obj }
    end

    describe ":this_week" do
      subject { test_class.send("#{prefix}this_week") }
      let(:beginning_of_week_obj) { test_class.create! date_column => Time.now.beginning_of_week }
      let(:end_of_week_obj) { test_class.create! date_column => Time.now.end_of_week }

      it { should_not include last_week_obj }
      it { should include beginning_of_week_obj }
      it { should include end_of_week_obj }
      it { should_not include next_week_obj }
    end

    describe ":this_month" do
      subject { test_class.send("#{prefix}this_month") }
      let(:beginning_of_month_obj) { test_class.create! date_column => Time.now.beginning_of_month }
      let(:end_of_month_obj) { test_class.create! date_column => Time.now.end_of_month }

      it { should_not include last_month_obj }
      it { should include beginning_of_month_obj }
      it { should include end_of_month_obj }
      it { should_not include next_month_obj }
    end

    describe ":this_year" do
      subject { test_class.send("#{prefix}this_year") }
      let(:beginning_of_year_obj) { test_class.create! date_column => Time.now.beginning_of_year }
      let(:end_of_year_obj) { test_class.create! date_column => Time.now.end_of_year }

      it { should_not include last_year_obj }
      it { should include beginning_of_year_obj }
      it { should include end_of_year_obj }
      it { should_not include next_year_obj }
    end
  end
end

