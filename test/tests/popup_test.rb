require 'test_helper'

# create popup_test.html with injected scripts
POPUP_TEST_HTML   = 'lib/popup_test.html'
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

File.open(POPUP_TEST_HTML, 'w') do |f|
  new_file.each do |line|
    f.write line
  end
end

class TestPopup < CapybaraTestCase
  def setup
    super
    @test_url = "file://#{Dir.pwd}/#{POPUP_TEST_HTML}"
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
      defaults[k] = get_value(k)
      find(k).set v
    end
    find('#saveButton').click
    find '.notice'

    # check to see if they're saved and properly sanitized
    visit @test_url
    @new_inputs.each do |k, v|
      assert_equal v.downcase.strip, get_value(k)
    end

    # reset defaults
    find('#resetButton').click
    @new_inputs.each do |input_id, _|
      assert_equal defaults[input_id], get_value(input_id)
    end
  end

  def teardown
    File.delete(POPUP_TEST_HTML)
    super
  end
end