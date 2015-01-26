module Devise
  module Models
    module Stretchable
      extend ActiveSupport::Concern

      included do
        # Enhance the stretches!
        after_commit :enqueue_stretch_worker, on: [:create, :update] if Devise::Async::Stretch.enabled
        before_save :update_stretch_mark, on: [:create, :update] if Devise::Async::Stretch.enabled
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

      # This is used in the session, used to verify if the password has changed
      def authenticatable_salt
        stretch_mark if stretch_mark
      end

      protected

      def enqueue_stretch_worker
        Devise::Async::Stretch::Worker.enqueue(self.class.name, id, @password) unless @password.nil?
        @password = nil
      end

      def update_stretch_mark
        self[:stretch_mark] = SecureRandom.hex(15)[0,29] unless @password.blank?
      end

      # Digests the password using bcrypt. Custom encryption should override
      # this method to apply their own algorithm.
      #
      # See https://github.com/plataformatec/devise-encryptable for examples
      # of other encryption engines.
      def password_digest(password)
        if Devise::Async::Stretch.enabled
          stretch = Devise::Async::Stretch.intermediate_stretch

          bcrypt(password, stretch)
        else
          super
        end
      end

    end
  end
end