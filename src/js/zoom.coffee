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

pixelValue = (value) ->
  "#{value}px"

changeFont = (ratioDiff) ->
  changeFontSizeCalls = []
  totalRatio          += ratioDiff
  totalRatio          = Math.round(totalRatio * 100) / 100
  relevantElements    = $('*').not(ignoredTags.join())
  # TODO pop up box
  console.log totalRatio

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
  changeFont(zoomLevel) if zoomLevel