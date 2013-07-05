require 'include_date_scopes'
require 'support/post'

RSpec.configure do |config|

  config.mock_with :rspec

  config.before :each do
    Post.stub(:table_exists?) { true }
    Post.stub(:columns_hash) {
      { 
        'id' => ActiveRecord::ConnectionAdapters::Column.new('id', nil, :integer, nil),
        'body' => ActiveRecord::ConnectionAdapters::Column.new('body', nil, :string, nil),
        'visible_after' => ActiveRecord::ConnectionAdapters::Column.new('visible_after', nil, :date, nil),
        'updated_at' => ActiveRecord::ConnectionAdapters::Column.new('updated_at', nil, :datetime, nil),
        'created_at' => ActiveRecord::ConnectionAdapters::Column.new('created_at', nil, :datetime, nil),
      }
    }
  end
end