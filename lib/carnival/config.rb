module Carnival

  class Config
    mattr_accessor :menu, :devise_config, :devise_class_name, :omniauth, :omniauth_providers, :custom_css_files, :custom_javascript_files, :root_action, :use_full_model_name, :app_name, :mount_at, :items_per_page
    @@app_name
    @@mount_at
    @@menu
    @@custom_css_files = []
    @@custom_javascript_files = []
    @@root_action = "carnival/base_admin#home"
    @@use_full_model_name = true
    @@items_per_page = 50

    def self.app_name
      return "#{Rails.application.class.to_s.split('::').first} Admin" if @@app_name.nil? 
      return @@app_name
    end

  end
end
