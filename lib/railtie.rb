module IncludeDateScopes
  class Railtie < ::Rails::Railtie
    initializer 'include_date_scopes' do |app|
      ActiveSupport.on_load :active_record do
        require 'include_date_scopes/active_record'
      end
    end
  end
end
