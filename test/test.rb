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

  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end

class TestZoom < CapybaraTestCase
  def setup
    super
    @all_elements = %w(#div1 #div2 #div3 span input)
    @test_url     = "file://#{Dir.pwd}/test/test.html"
  end

  def change_font(up = true)
    key = up ? '=' : '-'
    page.execute_script("Mousetrap.trigger('alt+shift+#{key}')")
  end

  def verify_font_size(size)
    @all_elements.each do |element|
      assert_equal "#{size}px", get_js("$('#{element}').css('font-size')")
      if element =~ /span|input/
        assert_equal "12px", get_js("$('#{element}').css('line-height')")
      else
        assert_equal "#{size}px", get_js("$('#{element}').css('line-height')")
      end
    end
    verify_no_style '#no_text'
  end

  def verify_no_style(selector)
    style = get_js("$('#{selector}').attr('style')")
    assert (style == '') || (style == nil)
  end

  def verify_all_no_style
    @all_elements.each do |element|
      verify_no_style element
    end
  end

  def test_zoom
    visit @test_url

    change_font
    verify_font_size 11
    change_font
    verify_font_size 12

    visit @test_url
    # make sure font increase is saved
    verify_font_size 12

    change_font false
    verify_font_size 11
    change_font false
    verify_all_no_style

    visit @test_url
    verify_all_no_style

    change_font false
    verify_font_size 9

  end
end