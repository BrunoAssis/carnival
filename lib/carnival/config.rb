module Carnival

  class Config
    mattr_accessor :menu, :devise_config, :omniauth, :omniauth_providers, :custom_css_files, :custom_javascript_files, :ar_admin_user_class
    @@menu
    @@devise_config
    @@omniauth
    @@omniauth_providers
    @@custom_css_files = []
    @@custom_javascript_files = []
    @@ar_admin_user_class = ActiveRecord::Base
  end
end
