require 'spec_helper'

describe "Model" do

  before(:all) do
    # puts "Local time: #{Time.now}"
    # puts "UTC time:   #{Time.now.gmtime}"
  end

  describe 'default timestamp scopes' do
    before(:all) do
      define_model_class do
        include_date_scopes
      end
    end

    it_behaves_like "timestamp scopes"
  end

  describe 'timestamp scopes on another column' do
    before(:all) do
      define_model_class do
        include_date_scopes_for :updated_at
      end
    end

    it_behaves_like "timestamp scopes", :updated_at
  end

  describe 'timestamp scopes with name prepended' do
    before(:all) do
      define_model_class do
        include_named_date_scopes_for :show_at
      end
    end

    it_behaves_like "timestamp scopes", :show_at, 'show_at_'
  end

  describe 'date scopes' do
    before(:all) do
      define_model_class do
        include_named_date_scopes_for :show_until
      end
    end

    it_behaves_like 'date scopes', :show_until, 'show_until_'
  end

  describe 'providing column type' do
    before(:all) do
      define_model_class do
        # Note that using date scopes to query a datetime column will yield incorrect results unless
        # the database timezone is the same as the local timezone.
        include_date_scopes_for :show_at, true, :date
      end
    end

    it 'does not respond to time scopes' do
      expect(Post).not_to respond_to(:last_n_minutes)
    end

    # Note that these specs succeed because the test threshold has only date granularity.
    # For a true datetime column the thresholds should have second granularity.
    it_behaves_like('date scopes', :show_at, 'show_at_')
  end

  describe 'using a non-date argument' do
    # This is due to a horrible design flaw in DelayedJobs.  That framework
    # assumes that if a delayed object has the method 'before' defined that
    # that method was defined as a callback for DJ.  Too bad its a common
    # word that's also used by my framework.
    it 'does not raise an error' do
      define_model_class do
        include_named_date_scopes_for :show_at
        include_named_date_scopes_for :show_until
      end
      expect { Post.show_at_before('abc') }.to_not raise_error
      expect { Post.show_until_before('abc') }.to_not raise_error
    end
  end

  describe 'using column which does not exist yet' do
    it 'does not raise an error' do
      previous_stderr, $stderr = $stderr, StringIO.new
      expect {
        define_model_class do
          include_date_scopes_for :does_not_exist
        end
      }.to_not raise_error
      $stderr = previous_stderr
    end
  end
end
