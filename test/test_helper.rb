require 'capybara'
require 'wist'
require 'pry'
begin; require 'turn/autorun'; rescue LoadError; end
Turn.config.format = :dot

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

class CapybaraTestCase < MiniTest::Unit::TestCase
  include Capybara::DSL
  include Wist

  def setup
    Capybara.current_driver = :chrome
  end

  def teardown
    Capybara.reset_sessions!
  end
end