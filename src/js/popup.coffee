dom =
  zoomInButton: $('.zoomInButton')
  zoomOutButton: $('.zoomOutButton')
  zoomResetButton: $('.zoomResetButton')

['in', 'out', 'reset'].forEach (type) ->
  dom["zoom#{Util.capitalize(type)}Button"].click ->
    chrome.extension.sendMessage key: Util.KEYS["ZOOM_#{type.toUpperCase()}_KEY"], (res) ->
      chrome.tabs.executeScript
        code: "Mousetrap.trigger('#{res.key}');"