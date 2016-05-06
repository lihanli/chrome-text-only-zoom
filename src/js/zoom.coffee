'use strict'
window.zoomTextOnlyLoaded = true
totalRatio = 1
ZOOM_LEVEL_KEY = 'zoomLevel'
IGNORED_TAGS = /SCRIPT|NOSCRIPT|LINK|BR|EMBED|IFRAME|IMG|VIDEO|CANVAS|STYLE/

multiplyByRatio = (value, multiplier) ->
  (parseFloat(value) * multiplier) + 'px'

addImportantStyle = (el, name, value) ->
  el.style.cssText += "#{name}: #{value} !important;"

changeFont = (ratioDiff, notification = true) ->
  # start = (new Date()).getTime() # uncomment to benchmark
  changeFontSizeCalls = []
  prevRatio = totalRatio
  totalRatio += ratioDiff
  totalRatio = Math.round(totalRatio * 10) / 10
  multiplier = totalRatio / prevRatio
  relevantElements = document.querySelectorAll('body, body *')

  if notification
    setTimeout ->
      alertify.log("Text Zoom #{(totalRatio * 100).toFixed()}%")

  if totalRatio == 1
    for el in relevantElements
      el.style['transition'] = null
      el.style['font-size'] = null
      el.style['line-height'] = null

    return util.putInLocalStorage(ZOOM_LEVEL_KEY, false)

  util.putInLocalStorage ZOOM_LEVEL_KEY, (totalRatio - 1)

  [].forEach.call relevantElements, (el) ->
    tagName = el.tagName
    return if tagName.match(IGNORED_TAGS)

    computedStyle = getComputedStyle(el)

    if !util.isBlank(el.innerText) || (tagName == 'TEXTAREA')
      currentLh = computedStyle.lineHeight
      lineHeight = multiplyByRatio(currentLh, multiplier) if currentLh.indexOf('px') != -1

    fontSize = multiplyByRatio(computedStyle.fontSize, multiplier)

    changeFontSizeCalls.push ->
      el.style['transition'] = 'font 0s'
      addImportantStyle(el, 'font-size', fontSize)
      addImportantStyle(el, 'line-height', lineHeight) unless lineHeight == undefined

  for call in changeFontSizeCalls
    call()

  # console.log (new Date()).getTime() - start # uncomment to benchmark

getKeyFromBackground = (keyName, keyFunction) ->
  chrome.extension.sendMessage key: keyName, (res) ->
    Mousetrap.bind res.key, keyFunction

getKeyFromBackground util.KEYS.ZOOM_IN_KEY, ->
  changeFont 0.1

getKeyFromBackground util.KEYS.ZOOM_OUT_KEY, ->
  changeFont -0.1

getKeyFromBackground util.KEYS.ZOOM_RESET_KEY, ->
  totalRatio = 1
  changeFont 0

zoomLevel = util.getFromLocalStorage(ZOOM_LEVEL_KEY)
changeFont(zoomLevel, false) if zoomLevel
