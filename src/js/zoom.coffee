totalRatio     = 1
ZOOM_LEVEL_KEY = 'zoomLevel'
ignoredTags    = [
  'html'
  'head'
  'title'
  'meta'
  'script'
  'noscript'
  'link'
  'br'
  'embed'
  'iframe'
  'img'
  'video'
  'canvas'
]
$.extend $.gritter.options,
  position: "bottom-left" # defaults to 'top-right' but can be 'bottom-left', 'bottom-right', 'top-left', 'top-right' (added in 1.7.1)
  fade_in_speed: 0 # how fast notifications fade in (string or int)
  fade_out_speed: 'fast' # how fast the notices fade out
  time: 3000 # hang on the screen for...

pixelValue = (value) ->
  "#{value}px"

changeFont = (ratioDiff, notification = true) ->
  changeFontSizeCalls = []
  totalRatio          += ratioDiff
  totalRatio          = Math.round(totalRatio * 100) / 100
  relevantElements    = $('*').not(ignoredTags.join())

  if notification
    $('.gritter-close').click()
    $.gritter.add
      title: "Text Zoom"
      text: "Level #{(totalRatio * 100).toFixed()}%"

  relevantElements.css
    'font-size':   ''
    'line-height': ''

  if totalRatio == 1
    return putInLocalStorage(ZOOM_LEVEL_KEY, false)

  putInLocalStorage ZOOM_LEVEL_KEY, (totalRatio - 1)

  relevantElements.each ->
    element = $(@)
    return if element.text() == '' && !element.is('input, textarea')

    if element.is('span,input')
      # font-size not measured properly for some spans and inputs (bug in jquery?)
      # don't change line-height for spans or inputs
      element = element.parent()
    else
      lineHeight = parseInt(element.css('line-height')) * totalRatio

    fontSize = parseInt(element.css('font-size')) * totalRatio

    changeFontSizeCalls.push =>
      $(@).css 'font-size', pixelValue(fontSize)
      $(@).css('line-height', pixelValue(lineHeight)) if lineHeight?

  for call in changeFontSizeCalls
    call()

getFromLocalStorage = (key) ->
  value = localStorage[key]
  return JSON.parse(value) if value
  null

putInLocalStorage = (key, value) ->
  localStorage[key] = JSON.stringify(value)

$ ->
  Mousetrap.bind 'alt+shift+=', ->
    changeFont 0.1
  Mousetrap.bind 'alt+shift+-', ->
    changeFont -0.1

  zoomLevel = getFromLocalStorage(ZOOM_LEVEL_KEY)
  changeFont(zoomLevel, false) if zoomLevel