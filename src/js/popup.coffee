dom =
  zoomInButton: $('.zoomInButton')
  zoomOutButton: $('.zoomOutButton')
  zoomResetButton: $('.zoomResetButton')
  currentZoom: $('.currentZoom')
  optionsLink: $('.optionsLink')
  zoomBox: $('.zoomBox')
  errorMsgBox: $('.errorMsgBox')

showError = (msg) ->
  dom.zoomBox.hide()
  dom.errorMsgBox.removeClass('hidden').text(msg)

parseChromeData = (cb) ->
  (data) ->
    cb(if data? then data[0] else null)

getCurrentZoomLevel = ->
  chrome.tabs.executeScript
    code: "util.getFromLocalStorage('zoomLevel');"
  , parseChromeData (data) ->
    data = data || 0
    dom.currentZoom.text("#{(Math.round(data * 10) * 10 + 100).toFixed()}%")

_.each ['in', 'out', 'reset'], (type) ->
  dom["zoom#{util.capitalize(type)}Button"].click ->
    chrome.extension.sendMessage key: util.KEYS["ZOOM_#{type.toUpperCase()}_KEY"], (res) ->
      chrome.tabs.executeScript
        code: "Mousetrap.trigger('#{res.key}');"
      , ->
        getCurrentZoomLevel()

chrome.tabs.executeScript
  code: 'window.zoomTextOnlyLoaded'
, (data) ->
  if data?
    data = data[0]

    if data
      getCurrentZoomLevel()
    else
      showError('Reload page first')
  else
    showError("Can't zoom on this page")

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
