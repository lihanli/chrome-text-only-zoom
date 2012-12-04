require './test/test_helper'

class TestZoom < CapybaraTestCase
  def setup
    super
    @all_elements = %w(#div1 #div2 #div3 input body)
    @test_url     = "file://#{Dir.pwd}/test/test.html"
  end

  def change_font(up = true)
    key = up ? '=' : '-'
    page.execute_script("Mousetrap.trigger('alt+#{key}')")
  end

  def verify_font_size(size, notification = true)
    @all_elements.each do |element|
      assert_equal "#{size}px", get_js("$('#{element}').css('font-size')"), element
      if element == 'input'
        assert_equal "12px", get_js("$('#{element}').css('line-height')")
      else
        assert_equal "#{size}px", get_js("$('#{element}').css('line-height')")
      end
      assert has_class(element, 'noTransition')
    end
    %w(font-size line-height).each do |style|
      assert_equal "10px", get_js("$('#no_text').css('#{style}')")
    end

    verify_gritter_text(notification ? "#{size * 10}%" : notification)
  end

  def verify_no_style(selector)
    style = get_js("$('#{selector}').attr('style')")
    assert (style == '') || (style == nil)
    assert_equal has_class(selector, 'noTransition'), false
  end

  def verify_gritter_text(text)
    if text
      assert all('.gritter-without-image p').last.text.include?(text)
    else
      assert_equal false, page.has_css?('.gritter-item')
    end
  end

  def verify_all_no_style(notification = true)
    @all_elements.each do |element|
      verify_no_style element
    end
    verify_gritter_text(notification ? '100%' : notification)
  end

  def test_zoom
    visit @test_url

    change_font
    verify_font_size 11
    change_font
    verify_font_size 12

    visit @test_url
    # make sure font increase is saved
    verify_font_size 12, false

    change_font false
    verify_font_size 11
    change_font false
    verify_all_no_style

    visit @test_url
    verify_all_no_style false

    change_font false
    verify_font_size 9

  end
end