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
end
