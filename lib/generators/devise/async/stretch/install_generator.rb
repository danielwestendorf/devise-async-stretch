require 'rails/generators/named_base'
require 'rails/generators/active_record'

module Devise
  module Async
    module Stretch
      class InstallGenerator < Rails::Generators::NamedBase
        source_root File.expand_path("../../../../templates", __FILE__)

        desc "Creates a Devise::Async:Stretch initializer to your application and generates need migrations."
        class_option :orm

        def copy_initializer
          template "devise_async_stretch.rb", "config/initializers/devise_async_stretch.rb"
        end

        def inject_devise_invitable_content
          path = File.join("app", "models", "#{file_path}.rb")
          inject_into_file(path, ", :stretchable", :after => ":database_authenticatable") if File.exists?(path)
        end

        def add_stretch_mark
          generate "migration", "AddStretchMarkTo#{name} stretch_mark:string"
          rake "db:migrate"
        end

      end
    end
  end
end