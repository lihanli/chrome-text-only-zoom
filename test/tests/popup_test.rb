require 'test_helper'

class TestPopup < CapybaraTestCase
  def setup
    super
    # create popup_test.html with injected scripts
    @popup_test_html   = 'lib/popup_test.html'
    new_file          = []
    scripts_to_inject = {
      "jquery.js" => "<script type=\"text/javascript\" src=\"../test/test.js\"></script>\n",
      "popup.js"  => "<script type=\"text/javascript\" src=\"background.js\"></script>\n",
    }

    File.readlines('lib/popup.html').each do |line|
      scripts_to_inject.each do |k, v|
        new_file << v if line.include?(k)
      end
      new_file << line
    end

    File.open(@popup_test_html, 'w') do |f|
      new_file.each do |line|
        f.write line
      end
    end

    @test_url = "file://#{Dir.pwd}/#{@popup_test_html}"
    @new_inputs = {
      '#zoomInKeyInput'    => 'ALT+shift+= ',
      '#zoomOutKeyInput'   => 'alt+shift+-',
      '#zoomResetKeyInput' => 'alt+shift+0',
    }
  end

  def test_popup
    visit @test_url
    defaults = {}
    # fill in new inputs
    @new_inputs.each do |k, v|
      defaults[k] = get_val(k)
      find(k).set v
    end
    find('#saveButton').click
    find '.notice'

    # check to see if they're saved and properly sanitized
    visit @test_url
    @new_inputs.each do |k, v|
      assert_equal v.downcase.strip, get_val(k)
    end

    # reset defaults
    find('#resetButton').click
    @new_inputs.each do |input_id, _|
      assert_equal defaults[input_id], get_val(input_id)
    end
  end

  def teardown
    File.delete(@popup_test_html)
    super
  end
end