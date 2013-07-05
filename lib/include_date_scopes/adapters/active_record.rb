# Shamelessly stolen from the squeel gem.
require 'active_record'

case ActiveRecord::VERSION::MAJOR
when 3
  ActiveRecord::Base.send :extend, IncludeDateScopes
else
  raise NotImplementedError, "include_date_scopes does not support Active Record version #{ActiveRecord::VERSION::STRING}"
end