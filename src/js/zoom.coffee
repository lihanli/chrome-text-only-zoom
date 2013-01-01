totalRatio       = 1
ZOOM_LEVEL_KEY   = 'zoomLevel'
IGNORED_ELEMENTS = [
  'script'
  'noscript'
  'link'
  'br'
  'embed'
  'iframe'
  'img'
  'video'
  'canvas'
  'style'
  '#gritter-notice-wrapper'
]
$.extend $.gritter.options,
  position: "bottom-left" # defaults to 'top-right' but can be 'bottom-left', 'bottom-right', 'top-left', 'top-right' (added in 1.7.1)
  fade_in_speed: 0 # how fast notifications fade in (string or int)
  fade_out_speed: 0 # how fast the notices fade out
  time: 3000 # hang on the screen for...

pixelValue = (value) ->
  "#{value}px"

changeFont = (ratioDiff, notification = true) ->
  #start = (new Date()).getTime() # uncomment to benchmark
  changeFontSizeCalls = []
  totalRatio          += ratioDiff
  totalRatio          = Math.round(totalRatio * 100) / 100
  relevantElements    = $('body, body *')

  if notification
    $('.gritter-close').click()
    $.gritter.add
      title: "Text Zoom"
      text: "Level #{(totalRatio * 100).toFixed()}%"

  relevantElements.css
    'font-size':   ''
    'line-height': ''

  if totalRatio == 1
    relevantElements.removeClass 'noTransition'
    return Util.putInLocalStorage(ZOOM_LEVEL_KEY, false)

  Util.putInLocalStorage ZOOM_LEVEL_KEY, (totalRatio - 1)

  # transitions screw up font size measuring
  relevantElements.addClass 'noTransition'

  _.each relevantElements, (element) ->
    # dont change font size or line-height if there's no text unless it's an input or textarea
    return if Util.isBlank(element.innerText) && !(element.tagName.match /INPUT|TEXTAREA/)

    unless (element.tagName == 'INPUT') && (element.type == 'text')
      # changing line-height for inputs will make text disappear
      lineHeight = parseInt(getComputedStyle(element).lineHeight) * totalRatio

    fontSize = parseInt(getComputedStyle(element).fontSize) * totalRatio

    changeFontSizeCalls.push ->
      jqElement = $(element)
      jqElement.css 'font-size', pixelValue(fontSize)
      jqElement.css('line-height', pixelValue(lineHeight)) if lineHeight?

  for call in changeFontSizeCalls
    call()

  #console.log (new Date()).getTime() - start # uncomment to benchmark

getKeyFromBackground = (keyName, keyFunction) ->
  chrome.extension.sendMessage key: keyName, (res) ->
    Mousetrap.bind res.key, keyFunction

getKeyFromBackground Util.KEYS.ZOOM_IN_KEY, ->
  changeFont 0.1

getKeyFromBackground Util.KEYS.ZOOM_OUT_KEY, ->
  changeFont -0.1

getKeyFromBackground Util.KEYS.ZOOM_RESET_KEY, ->
  totalRatio = 1
  changeFont 0

zoomLevel = Util.getFromLocalStorage(ZOOM_LEVEL_KEY)
changeFont(zoomLevel, false) if zoomLevel