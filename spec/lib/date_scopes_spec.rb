require 'spec_helper'

describe "Post" do
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
        include_date_scopes_for :show_until
      end
    end

    it_behaves_like 'date scopes', :show_until
  end

  describe 'providing column type' do
    before(:all) do
      define_model_class do
        include_date_scopes_for :show_at, nil, :date
      end
    end

    it 'does not respond to time scopes' do
      expect(Post).not_to respond_to(:last_n_minutes)
    end

    it_behaves_like 'date scopes', :show_at
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
