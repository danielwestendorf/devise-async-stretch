require 'test_helper'
require 'sidekiq/testing'

class UserTest < ActiveSupport::TestCase

  setup do
    Devise::Async::Stretch.enabled = true
    Devise::Async::Stretch.backend = :sidekiq
    Sidekiq::Testing.fake!
  end

  test "creating a user queues a sidekiq bg job" do
    assert_difference 'Devise::Async::Stretch::Backend::Sidekiq.jobs.size' do
      User.create(email: 'Ed@example.com', password: 'passwordcomplex')
    end
  end

  test "updating a user queues a sidekiq bg job" do
    user = User.new(email: 'Ed1@example.com', password: 'password1')
    assert_difference 'Devise::Async::Stretch::Backend::Sidekiq.jobs.size' do
      user.update(password: 'changedpassword')
    end
  end

  test "saving a user queues a sidekiq bg job" do
    user = User.new(email: 'Ed2@example.com', password: 'password2')
    assert_difference 'Devise::Async::Stretch::Backend::Sidekiq.jobs.size' do
      user.save
    end
  end

  test "the #stretch_mark gets updated when the password is changed" do
    user = User.create(email: 'Ed2@example.com', password: 'password2')

    refute_nil user.stretch_mark

    stretch_mark = user.stretch_mark
    user.password = "password3"
    user.save

    refute_equal stretch_mark, user.reload.stretch_mark
  end

  test "the #stretch_mark doesn't change when the worker runs" do
    user = User.create(email: 'Ed2@example.com', password: 'password2')
    stretch_mark = user.stretch_mark

    Sidekiq::Testing.inline!

    Devise::Async::Stretch::Backend::Base.new.perform("User", user.id, 'newpassword')

    assert_equal stretch_mark, user.reload.stretch_mark
  end

end
