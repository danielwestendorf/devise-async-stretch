require 'rails/generators/named_base'
require 'rails/generators/active_record'

module Devise
  module Async
    module Stretch
      class PopulateStretchMarksGenerator < Rails::Generators::NamedBase

        desc "Sets the stretch_mark for existing records"
        class_option :orm

        def populate_stretch_marks
          name.constantize.to_adapter.find_all.each do |record|
            if record.stretch_mark.blank?
              record.update(stretch_mark: SecureRandom.hex(15)[0,29])
            end
          end
        end

      end
    end
  end
end