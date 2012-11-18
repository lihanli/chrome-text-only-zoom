require 'capybara'
require 'minitest/autorun'
require 'pry'
require 'turn'

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

class CapybaraTestCase < MiniTest::Unit::TestCase
  include Capybara::DSL
  def setup
    Capybara.current_driver = :chrome
  end

  def get_js(code)
    page.execute_script("return #{code}")
  end

  def get_value(jquery_selector)
    get_js "$('#{jquery_selector}').val()"
  end

  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end