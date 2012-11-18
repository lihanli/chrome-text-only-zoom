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
    relevantElements.css
      '-webkit-transition': ''
      'transition':         ''
    return Util.putInLocalStorage(ZOOM_LEVEL_KEY, false)

  Util.putInLocalStorage ZOOM_LEVEL_KEY, (totalRatio - 1)

  # transitions screw up font size measuring
  relevantElements.css
    '-webkit-transition': 'all 0 ease 0'
    'transition':         'all 0 ease 0'

  relevantElements.each ->
    element = $(@)
    return if element.text() == '' && !element.is('input, textarea')

    unless element.is('input[type="text"]')
      # changing line-height for inputs will make text disappear
      lineHeight = parseInt(element.css('line-height')) * totalRatio

    fontSize = parseInt(element.css('font-size')) * totalRatio

    changeFontSizeCalls.push =>
      $(@).css 'font-size', pixelValue(fontSize)
      $(@).css('line-height', pixelValue(lineHeight)) if lineHeight?

  for call in changeFontSizeCalls
    call()

getKeyFromBackground = (keyName, keyFunction) ->
  chrome.extension.sendMessage key: keyName, (res) ->
    Mousetrap.bind res.key, keyFunction

getKeyFromBackground Util.ZOOM_IN_KEY, ->
  changeFont 0.1

getKeyFromBackground Util.ZOOM_OUT_KEY, ->
  changeFont -0.1

getKeyFromBackground Util.ZOOM_RESET_KEY, ->
  totalRatio = 1
  changeFont 0

zoomLevel = Util.getFromLocalStorage(ZOOM_LEVEL_KEY)
changeFont(zoomLevel, false) if zoomLevel