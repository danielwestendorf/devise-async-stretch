require 'test_helper'

class StretchTest < ActiveSupport::TestCase
  settings = [:backend=, :queue=, :enabled=]

  test "configureable settings via setter" do
    assert_nothing_raised NoMethodError do
      settings.each do |setting|
        Devise::Async::Stretch.send(setting, 1)
      end
    end
  end

  test "configureable settings via setup block" do
    assert_nothing_raised NoMethodError do
      Devise::Async::Stretch.setup do |config|
        settings.each do |setting|
          config.send(setting, 1)
        end
      end
    end
  end

end