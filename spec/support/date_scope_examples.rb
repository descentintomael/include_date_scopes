
shared_examples "with basic date scopes" do |date_column = :created_at |
  let!(:test_class) { Post }
  describe "date scopes" do
    before(:each) { Timecop.freeze Time.local(2013,02,01,06,30) }

    let!(:last_week_obj) { test_class.create! date_column.to_sym => 1.week.ago }
    let!(:yesterday_obj) { test_class.create! date_column.to_sym => 24.hours.ago }
    let!(:hour_ago_obj) { test_class.create! date_column.to_sym => 1.hour.ago }
    let!(:five_minute_ago_obj) { test_class.create! date_column.to_sym => 5.minutes.ago }
    let!(:after_midnight_ago_obj) { test_class.create! date_column.to_sym => Date.today.midnight + 5.minutes }
    let!(:before_midnight_ago_obj) { test_class.create! date_column.to_sym => Date.today.midnight - 5.minutes }

    describe ":between" do
      context "with DateTime" do
        subject { test_class.between(2.hours.ago, 1.minute.ago) }

        it { should_not include last_week_obj }
        it { should_not include yesterday_obj }
        it { should include hour_ago_obj }
        it { should include five_minute_ago_obj }
      end
      context "with Date" do
        subject { test_class.between(2.days.ago.to_date, Date.today) }

        it { should_not include last_week_obj }
        it { should include yesterday_obj }
        it { should include hour_ago_obj }
        it { should include five_minute_ago_obj }
      end
    end

    describe ":after" do
      context "with DateTime" do
        subject { test_class.after(2.hours.ago) }

        it { should_not include last_week_obj }
        it { should_not include yesterday_obj }
        it { should include hour_ago_obj }
        it { should include five_minute_ago_obj }
      end
      context "with Date" do
        subject { test_class.after(2.days.ago.to_date) }

        it { should_not include last_week_obj }
        it { should include yesterday_obj }
        it { should include hour_ago_obj }
        it { should include five_minute_ago_obj }
      end
    end

    describe ":on_or_after_date" do
      context "with DateTime" do
        subject { test_class.on_or_after_date(2.hours.ago) }

        it { should_not include last_week_obj }
        it { should_not include yesterday_obj }
        it { should include hour_ago_obj }
        it { should include five_minute_ago_obj }
      end
      context "with Date" do
        subject { test_class.on_or_after_date(2.days.ago.to_date) }

        it { should_not include last_week_obj }
        it { should include yesterday_obj }
        it { should include hour_ago_obj }
        it { should include five_minute_ago_obj }
      end
    end

    describe ":before" do
      context "with DateTime" do
        subject { test_class.before(2.hours.ago) }

        it { should include last_week_obj }
        it { should include yesterday_obj }
        it { should_not include hour_ago_obj }
        it { should_not include five_minute_ago_obj }
      end
      context "with Date" do
        subject { test_class.before(Date.today) }

        it { should include last_week_obj }
        it { should include yesterday_obj }
        it { should_not include hour_ago_obj }
        it { should_not include five_minute_ago_obj }
      end
    end

    describe ":on_or_before_date" do
      context "with DateTime" do
        subject { test_class.on_or_before_date(25.hours.ago) }

        it { should include last_week_obj }
        it { should include yesterday_obj }
        it { should_not include hour_ago_obj }
        it { should_not include five_minute_ago_obj }
      end
      context "with Date" do
        subject { test_class.on_or_before_date(Date.yesterday) }

        it { should include last_week_obj }
        it { should include yesterday_obj }
        it { should_not include hour_ago_obj }
        it { should_not include five_minute_ago_obj }
      end
    end

    describe ":today" do
      subject { test_class.today }

      it { should_not include last_week_obj }
      it { should_not include yesterday_obj }
      it { should include hour_ago_obj }
      it { should include five_minute_ago_obj }
    end

    describe ":yesterday" do
      subject { test_class.yesterday }

      it { should_not include last_week_obj }
      it { should include yesterday_obj }
      it { should_not include hour_ago_obj }
      it { should_not include five_minute_ago_obj }
    end
  end
end

