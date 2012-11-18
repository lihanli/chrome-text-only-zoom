setKeysFromBg = ->
  $.each Util.KEYS, (keyName, key) ->
    chrome.extension.sendMessage key: key, (res) ->
      $("##{key}Input").val res.key

$ ->
  $('#resetButton').click ->
    chrome.extension.sendMessage resetDefaults: true, (res) ->
      setKeysFromBg()

  $('#saveButton').click ->
    newKeys = {}
    for keyName, key of Util.KEYS
      newKey = $.trim($("##{key}Input").val()).toLowerCase()
      newKeys[key] = newKey unless newKey == ''

    $('.notice').remove()
    chrome.extension.sendMessage saveKeys: newKeys, (res) ->
      $('#noticeBox').append """
        <div class='notice'>
          <i class="icon-ok"></i> Settings have been saved.
          <br />
          Reload page to use new shortcuts.
        </div>
      """
      $('.notice').delay(5000).fadeOut 'slow', ->
        $(@).remove()

  setKeysFromBg()
