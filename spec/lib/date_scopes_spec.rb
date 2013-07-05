require 'spec_helper'

describe DateScopes do
  it "raises an error for non-date columns" do
    expect do
      Post.send :include_date_scopes_for, :body
    end.to raise_error(/for date or datetime columns/)
  end
end