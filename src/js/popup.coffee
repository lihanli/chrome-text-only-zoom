setKeysFromBg = ->
  $.each Util.KEYS, (_, key) ->
    chrome.extension.sendMessage key: key, (res) ->
      $("##{key}Input").val res.key

addNotice = ->
  $('.notice').remove()

  message = $('<span>')
  el = $('<div>').addClass('notice').html """
    <br />
    Reload page to use new shortcuts
  """
  el.prepend(message).appendTo($('#noticeBox'))

  el.delay(5000).fadeOut 'slow', ->
    el.remove()

  message

$ ->
  $('#resetButton').click ->
    chrome.extension.sendMessage resetDefaults: true, (res) ->
      setKeysFromBg()
      addNotice().text('Shortcuts reset to defaults')

  $('#saveButton').click ->
    newKeys = {}
    for _, key of Util.KEYS
      newKey = $.trim($("##{key}Input").val()).toLowerCase()
      newKeys[key] = newKey unless newKey == ''

    chrome.extension.sendMessage saveKeys: newKeys, (res) ->
      addNotice().html """
        <span class="glyphicon glyphicon-floppy-saved"></span> Settings have been saved
      """

  setKeysFromBg()
