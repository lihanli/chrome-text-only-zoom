dom =
  zoomInButton: $('.zoomInButton')
  zoomOutButton: $('.zoomOutButton')
  zoomResetButton: $('.zoomResetButton')
  currentZoom: $('.currentZoom')
  optionsLink: $('.optionsLink')
  zoomBox: $('.zoomBox')
  errorMsgBox: $('.errorMsgBox')

getCurrentZoomLevel = ->
  chrome.tabs.executeScript
    code: "util.getFromLocalStorage('zoomLevel');"
  , (data) ->
    if data?
      data = data[0] || 0
      dom.currentZoom.text("#{(Math.round(data * 10) * 10 + 100).toFixed()}%")
    else
      dom.zoomBox.hide()
      dom.errorMsgBox.removeClass('hidden')

_.each ['in', 'out', 'reset'], (type) ->
  dom["zoom#{util.capitalize(type)}Button"].click ->
    chrome.extension.sendMessage key: util.KEYS["ZOOM_#{type.toUpperCase()}_KEY"], (res) ->
      chrome.tabs.executeScript
        code: "Mousetrap.trigger('#{res.key}');"
      , ->
        getCurrentZoomLevel()

getCurrentZoomLevel()

dom.optionsLink.click ->
  optionsUrl = chrome.extension.getURL('lib/options.html')
  chrome.tabs.query {}, (extensionTabs) ->
    found = false
    i = 0

    while i < extensionTabs.length
      if optionsUrl is extensionTabs[i].url
        found = true
        chrome.tabs.update extensionTabs[i].id,
          selected: true

      i++
    chrome.tabs.create url: optionsUrl unless found
