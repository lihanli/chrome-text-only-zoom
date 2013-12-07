setKeysFromBg = ->
  $.each Util.KEYS, (_, key) ->
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
    for _, key of Util.KEYS
      newKey = $.trim($("##{key}Input").val()).toLowerCase()
      newKeys[key] = newKey unless newKey == ''

    chrome.extension.sendMessage saveKeys: newKeys, (res) ->
      addNotice('Settings have been saved')

  ['in', 'out', 'reset'].forEach (type) ->
    $("#zoom#{Util.capitalize(type)}Button").click ->
      chrome.extension.sendMessage key: Util.KEYS["ZOOM_#{type.toUpperCase()}_KEY"], (res) ->
        chrome.tabs.executeScript
          code: "Mousetrap.trigger('#{res.key}');"

  setKeysFromBg()

  setTimeout ->
    $('#zoomInKeyInput').focus()
  , 25
