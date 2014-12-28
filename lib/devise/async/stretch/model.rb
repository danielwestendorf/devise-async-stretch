module Devise
  module Models
    module Stretch
      extend ActiveSupport::Concern

      included do

      end

      def self.required_fields(klass)
        if Devise::Async::Stretch.enabled
          klass.authentication_keys
        else
          [:encrypted_password] + klass.authentication_keys
        end
      end

      def bcrypt(password, stretches=nil)
        stretches ||= self.class.stretches
        ::BCrypt::Password.create("#{password}#{self.class.pepper}", cost: stretches).to_s
      end

      protected

      # Digests the password using bcrypt. Custom encryption should override
      # this method to apply their own algorithm.
      #
      # See https://github.com/plataformatec/devise-encryptable for examples
      # of other encryption engines.
      def password_digest(password)
        if Devise::Async::Stretch.enabled
          Devise.bcrypt(self.class, password, 1)

          Devise::Async::Stretch::Worker.enqueue(self.klass, this.id, password)
        else
          Devise.bcrypt(self.class, password)
        end
      end

    end
  end
end