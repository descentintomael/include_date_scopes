require 'include_date_scopes'

class ActiveRecord::Base
  include IncludeDateScopes::DateScopes
end
