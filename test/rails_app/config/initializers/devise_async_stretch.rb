Devise::Async::Stretch.setup do |config|

  # Enable/Disable application wide
  config.enabled = true

  # Backend for background jobs
  config.backend = :sidekiq

  # Backend Queue
  config.queue = :default

  # Enable/Disable Intermediate Stretching. This will be the stretching that is done
  # before the background job runs. If disabled, the user will not be able to log in
  # until the background job has run.

  # Intermediate stretching. Set this value low, as it will be the initial stretched
  # password, replaced with the Devise.stretch value in the background job. This will
  # allow quick initial user creation
  config.intermediate_stretch = 1

end