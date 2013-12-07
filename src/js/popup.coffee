dom =
  zoomInButton: $('.zoomInButton')
  zoomOutButton: $('.zoomOutButton')
  zoomResetButton: $('.zoomResetButton')
  currentZoom: $('.currentZoom')

getCurrentZoomLevel = ->
  chrome.tabs.executeScript
    code: "Util.getFromLocalStorage('zoomLevel');"
  , (data) ->
    data = data[0] || 0
    dom.currentZoom.text("#{(Math.round(data * 10) * 10 + 100).toFixed()}%")

_.each ['in', 'out', 'reset'], (type) ->
  dom["zoom#{Util.capitalize(type)}Button"].click ->
    chrome.extension.sendMessage key: Util.KEYS["ZOOM_#{type.toUpperCase()}_KEY"], (res) ->
      chrome.tabs.executeScript
        code: "Mousetrap.trigger('#{res.key}');"
      , ->
        getCurrentZoomLevel()

getCurrentZoomLevel()