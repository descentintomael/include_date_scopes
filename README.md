include_date_scopes
===================
[![Build Status](https://travis-ci.org/descentintomael/include_date_scopes.svg?branch=master)](https://travis-ci.org/descentintomael/include_date_scopes)

An ActiveRecord module for automatically including a large list of commonly used date related scopes.

Usage
-----

To use in a model on the standard `created_at` column, put the `include_date_scopes` call in your class:
```ruby
class Post < ActiveRecord::Base
  include_date_scopes
end
```
Now you can call scopes like `Post.after(1.week.ago)` or `Post.yesterday`.

If you wish to use this on another column, use `include_dates_scopes_for`:
```ruby
class Post < ActiveRecord::Base
  include_date_scopes_for :show_at
end
```
Now all of the provided scopes will work with the `show_at` column.

If you want to include multiple sets of date scopes, you can use named date scopes:
```ruby
class Post < ActiveRecord::Base
  include_named_date_scopes_for :updated_at
end
```
Now the scopes will all be prepended with `updated_at_`.  So `Post.yesterday` would become `Post.updated_at_yesterday`.
