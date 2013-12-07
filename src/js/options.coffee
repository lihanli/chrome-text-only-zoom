dom =
  zoomInKeyInput: $('#zoomInKeyInput')
  zoomOutKeyInput: $('#zoomOutKeyInput')
  zoomResetKeyInput: $('#zoomResetKeyInput')
  noticeBox: $('#noticeBox')
  resetButton: $('#resetButton')
  saveButton: $('#saveButton')

setKeysFromBg = ->
  _.each util.KEYS, (key) ->
    chrome.extension.sendMessage key: key, (res) ->
      dom["#{key}Input"].val(res.key)

addNotice = (message) ->
  $('.notice').remove()

  el = $('<div>').addClass('notice').html """
    <span class="glyphicon glyphicon-floppy-saved"></span> #{_.escape(message)}
    <br />
    Reload page to use new shortcuts
  """
  el.appendTo(dom.noticeBox)

  el.delay(5000).fadeOut 'slow', ->
    el.remove()

$ ->
  dom.resetButton.click ->
    chrome.extension.sendMessage resetDefaults: true, (res) ->
      setKeysFromBg()
      addNotice('Shortcuts reset to defaults')

  dom.saveButton.click ->
    newKeys = {}
    for __, key of util.KEYS
      newKey = $.trim(dom["#{key}Input"].val()).toLowerCase()
      newKeys[key] = newKey unless newKey == ''

    chrome.extension.sendMessage saveKeys: newKeys, (res) ->
      addNotice('Settings have been saved')

  setKeysFromBg()
