# Devise::Async::Stretch

Move password stretching into a background job for fast user creation but while maintaining difficult to crack storage.

# Don't use this. Everything will work in development, but once you deploy to production, users will get logged out once the bg job executes.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/devise-async-stretch/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
