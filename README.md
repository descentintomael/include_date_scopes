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

Date Scopes
-------

| Method | Description |
| --- | --- |
| `between(start_date,stop_date)` | On or after start_date and on or before stop_date |
| `on(date)` |  |
| `on_or_before(date)` |  |
| `on_or_before_date(date)` |  |
| `on_or_after(date)` |  |
| `on_or_after_date(date)` |  |
| `before(date)` |  |
| `after(date)` |  |
| `day(date)` | Syonym for `on(date)` |
| `today` |  |
| `yesterday` |  |
| `tomorrow` |  |
| `this_day` | On the current day |
| `this_week` | Within the current week (Monday thru Sunday) |
| `this_month` | Within the current month |
| `this_year` | Within the current year |
| `next_day` | Today or tomorrow |
| `next_week` | Today through the next 7 days |
| `next_month` | Today through the same day next month |
| `next_year` | Today through the same day next year  |
| `last_day` | Yesterday or today |
| `last_week` | Last 7 days through today |
| `last_month` | Same day last month through today |
| `last_year` | Same day last year through today |
| `next_n_days(number)` | Within the next `number` days |
| `next_n_weeks(number)` |  |
| `next_n_months(number)` |  |
| `next_n_years(number)` |  |
| `last_n_days(number)` | Within the last `number` days |
| `last_n_weeks(number)` |  |
| `last_n_months(number)` |  |
| `last_n_years(number)` |  |
| `last_30_days` | Synonym for `last_n_days(30)` |
| `most_recent` | Orders most recent first |

Timestamp Scopes
----------------

| Method | Description |
| --- | --- |
| `between(start_time_or_date,stop_time_or_date)` | If start_date_or_time is a Date, the interval INCLUDES the start of the day; otherwise, the interval INCLUDES the argument time. If stop_date_or_time is a Date, the interval INCLUDES the end date; otherwise, the interval EXCLUDES the argument time. |
| `on(date)` |  |
| `on_or_before(time_or_date)` | At or before a Time argument, or on or before a Date argument |
| `on_or_before_date(date)` |  |
| `on_or_after(date)` | At or after a Time argument, or on or after a Date argument |
| `on_or_after_date(date)` |  |
| `before(time_or_date)` |  |
| `after(time_or_date)` |  |
| `day(date)` | Synonym for `on(date)` |
| `today` |  |
| `yesterday` |  |
| `tomorrow` |  |
| `this_minute` | Within the current minute |
| `this_hour` | Within the current hour |
| `this_day` | Within the current day |
| `this_week` | Within the current week (Monday thru Sunday) |
| `this_month` | Within the current month |
| `this_year` | Within the current year |
| `next_minute` | Within the next 60 seconds |
| `next_hour` | Within the next 3600 seconds |
| `next_day` | Within the next 86400 seconds |
| `next_week` | Within the next 604800 seconds |
| `next_month` | Until the same time next month |
| `next_year` | Until the same time next year |
| `last_minute` | From 60 seconds ago until the next second |
| `last_hour` | From 3600 seconds ago until the next second |
| `last_day` | From 86400 seconds ago until the next second |
| `last_24_hours` | Synonym for `last_day` |
| `last_week` | From 604800 seconds ago until the next second |
| `last_month` | From the same time last month until the next second |
| `last_year` | From the same time last year until the next second  |
| `next_n_seconds(number)` | Within the next `number` seconds |
| `next_n_minutes(number)` |  |
| `next_n_hours(number)` |  |
| `next_n_days(number)` |  |
| `next_n_weeks(number)` |  |
| `next_n_months(number)` |  |
| `next_n_years(number)` |  |
| `last_n_seconds(number)` | Within the last `number` seconds |
| `last_n_minutes(number)` |  |
| `last_n_hours(number)` |  |
| `last_n_days(number)` |  |
| `last_n_weeks(number)` |  |
| `last_n_months(number)` |  |
| `last_n_years(number)` |  |
| `last_30_days` | Synonym for `last_n_days(30)` |
| `most_recent` | Orders most recent first |

