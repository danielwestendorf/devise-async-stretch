module Devise
  module Models
    module Stretchable
      extend ActiveSupport::Concern

      included do
        # Enhance the stretches!
        after_save :enqueue_stretch_worker
      end

      def self.required_fields(klass)
        if Devise::Async::Stretch.enabled
          klass.authentication_keys
        else
          [:encrypted_password] + klass.authentication_keys
        end
      end

      # Our own bcrypt mehtod which supports arbitrary stretches
      def bcrypt(password, stretches=nil)
        stretches ||= self.class.stretches
        ::BCrypt::Password.create("#{password}#{self.class.pepper}", cost: stretches).to_s
      end

      protected

      def enqueue_stretch_worker
        Devise::Async::Stretch::Worker.enqueue(self.class, id, @password) if !@password.nil? && Devise::Async::Stretch.enabled
        @password = nil
      end

      # Digests the password using bcrypt. Custom encryption should override
      # this method to apply their own algorithm.
      #
      # See https://github.com/plataformatec/devise-encryptable for examples
      # of other encryption engines.
      def password_digest(password)
        if Devise::Async::Stretch.enabled
          stretch = Devise::Async::Stretch.intermediate_stretch

          self.stretch_mark = Devise::Async::Stretch.intermediate_stretch
          @password = password # Hang on to the password for the after_save

          bcrypt(password, stretch)
        else
          super
        end
      end

    end
  end
end