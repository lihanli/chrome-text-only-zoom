require 'capybara'
require 'pry'
begin; require 'turn/autorun'; rescue LoadError; end
Turn.config.format = :dot

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

  def get_value(selector)
    get_js "$('#{selector}').val()"
  end

  def has_class(selector, class_name)
    get_js "$('#{selector}').hasClass('#{class_name}')"
  end

  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end