require 'spec_helper'

describe "Post" do
  describe 'default date scopes' do
    before(:all) do
      define_model_class do
        include_date_scopes
      end
    end

    it_behaves_like "with basic date scopes"
  end

  describe 'date scopes on another column' do
    before(:all) do
      define_model_class do
        include_date_scopes_for :updated_at
      end
    end

    it_behaves_like "with basic date scopes", :updated_at
  end

  describe 'date scopes with name prepended' do
    before(:all) do
      define_model_class do
        include_named_date_scopes_for :show_at
      end
    end

    before(:all) { Timecop.freeze Time.local(2013,02,15,06,30) }

    let!(:last_month_obj) { Post.create! :show_at => 1.month.ago }
    let!(:last_week_obj) { Post.create! :show_at => 1.week.ago }
    let!(:yesterday_obj) { Post.create! :show_at => 24.hours.ago }
    let!(:hour_ago_obj) { Post.create! :show_at => 1.hour.ago }
    let!(:five_minute_ago_obj) { Post.create! :show_at => 5.minutes.ago }
    let!(:after_midnight_ago_obj) { Post.create! :show_at => Date.today.midnight + 5.minutes }
    let!(:before_midnight_ago_obj) { Post.create! :show_at => Date.today.midnight - 5.minutes }

    describe ":between" do
      context "with DateTime" do
        subject { Post.show_at_between(2.hours.ago, 1.minute.ago) }

        it { should_not include last_week_obj }
        it { should_not include yesterday_obj }
        it { should include hour_ago_obj }
        it { should include five_minute_ago_obj }
      end
      context "with Date" do
        subject { Post.show_at_between(2.days.ago.to_date, Date.today) }

        it { should_not include last_week_obj }
        it { should include yesterday_obj }
        it { should include hour_ago_obj }
        it { should include five_minute_ago_obj }
      end
    end

    describe ":after" do
      context "with DateTime" do
        subject { Post.show_at_after(2.hours.ago) }

        it { should_not include last_week_obj }
        it { should_not include yesterday_obj }
        it { should include hour_ago_obj }
        it { should include five_minute_ago_obj }
      end
      context "with Date" do
        subject { Post.show_at_after(2.days.ago.to_date) }

        it { should_not include last_week_obj }
        it { should include yesterday_obj }
        it { should include hour_ago_obj }
        it { should include five_minute_ago_obj }
      end
    end

    describe ":on_or_after_date" do
      context "with DateTime" do
        subject { Post.show_at_on_or_after_date(2.hours.ago) }

        it { should_not include last_week_obj }
        it { should_not include yesterday_obj }
        it { should include hour_ago_obj }
        it { should include five_minute_ago_obj }
      end
      context "with Date" do
        subject { Post.show_at_on_or_after_date(2.days.ago.to_date) }

        it { should_not include last_week_obj }
        it { should include yesterday_obj }
        it { should include hour_ago_obj }
        it { should include five_minute_ago_obj }
      end
    end

    describe ":before" do
      context "with DateTime" do
        subject { Post.show_at_before(2.hours.ago) }

        it { should include last_week_obj }
        it { should include yesterday_obj }
        it { should_not include hour_ago_obj }
        it { should_not include five_minute_ago_obj }
      end
      context "with Date" do
        subject { Post.show_at_before(Date.today) }

        it { should include last_week_obj }
        it { should include yesterday_obj }
        it { should_not include hour_ago_obj }
        it { should_not include five_minute_ago_obj }
      end
    end

    describe ":on_or_before_date" do
      context "with DateTime" do
        subject { Post.show_at_on_or_before_date(25.hours.ago) }

        it { should include last_week_obj }
        it { should include yesterday_obj }
        it { should_not include hour_ago_obj }
        it { should_not include five_minute_ago_obj }
      end
      context "with Date" do
        subject { Post.show_at_on_or_before_date(Date.yesterday) }

        it { should include last_week_obj }
        it { should include yesterday_obj }
        it { should_not include hour_ago_obj }
        it { should_not include five_minute_ago_obj }
      end
    end

    describe ":today" do
      subject { Post.show_at_today }

      it { should_not include last_week_obj }
      it { should_not include yesterday_obj }
      it { should include hour_ago_obj }
      it { should include five_minute_ago_obj }
    end

    describe ":yesterday" do
      subject { Post.show_at_yesterday }

      it { should_not include last_week_obj }
      it { should include yesterday_obj }
      it { should_not include hour_ago_obj }
      it { should_not include five_minute_ago_obj }
    end

    describe ":last_24_hours" do
      subject { Post.show_at_last_24_hours }

      it { should_not include last_week_obj }
      it { should_not include yesterday_obj }
      it { should include hour_ago_obj }
      it { should include five_minute_ago_obj }
    end

    describe ":last_hour" do
      subject { Post.show_at_last_hour }

      it { should_not include last_week_obj }
      it { should_not include yesterday_obj }
      it { should_not include hour_ago_obj } # should not because this is exclusive
      it { should include five_minute_ago_obj }
    end

    describe ":last_week" do
      subject { Post.show_at_last_week }

      it { should_not include last_week_obj }
      it { should include yesterday_obj }
      it { should include hour_ago_obj }
      it { should include five_minute_ago_obj }
    end

    describe ":last_30_days" do
      subject { Post.show_at_last_30days }

      it { should_not include last_month_obj }
      it { should include last_week_obj }
      it { should include yesterday_obj }
      it { should include hour_ago_obj }
      it { should include five_minute_ago_obj }
    end

    describe ":this_week" do
      subject { Post.show_at_this_week }

      it { should_not include last_week_obj }
      it { should include yesterday_obj }
      it { should include hour_ago_obj }
      it { should include five_minute_ago_obj }
      it { should include before_midnight_ago_obj }
    end

    describe ":this_month" do
      subject { Post.show_at_this_month }

      it { should_not include last_month_obj }
      it { should include last_week_obj }
      it { should include yesterday_obj }
      it { should include hour_ago_obj }
      it { should include five_minute_ago_obj }
    end
  end
end
