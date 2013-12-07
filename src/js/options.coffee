setKeysFromBg = ->
  _.each Util.KEYS, (key) ->
    chrome.extension.sendMessage key: key, (res) ->
      $("##{key}Input").val res.key

addNotice = (message) ->
  $('.notice').remove()

  el = $('<div>').addClass('notice').html """
    <span class="glyphicon glyphicon-floppy-saved"></span> #{_.escape(message)}
    <br />
    Reload page to use new shortcuts
  """
  el.appendTo($('#noticeBox'))

  el.delay(5000).fadeOut 'slow', ->
    el.remove()

$ ->
  $('#resetButton').click ->
    chrome.extension.sendMessage resetDefaults: true, (res) ->
      setKeysFromBg()
      addNotice('Shortcuts reset to defaults')

  $('#saveButton').click ->
    newKeys = {}
    for __, key of Util.KEYS
      newKey = $.trim($("##{key}Input").val()).toLowerCase()
      newKeys[key] = newKey unless newKey == ''

    chrome.extension.sendMessage saveKeys: newKeys, (res) ->
      addNotice('Settings have been saved')

  setKeysFromBg()

  setTimeout ->
    $('#zoomInKeyInput').focus()
  , 25
