'use strict'
window.zoomTextOnlyLoaded = true
totalRatio = 1
ZOOM_LEVEL_KEY = 'zoomLevel'
TRANSITION_ALLOWED_SITES = ['google.com']
IGNORED_TAGS = /SCRIPT|NOSCRIPT|LINK|BR|EMBED|IFRAME|IMG|VIDEO|CANVAS|STYLE/
TRANSITION_ALLOWED = do ->
  hostname = window.location.hostname

  for site in TRANSITION_ALLOWED_SITES
    return true if hostname.endsWith(site)

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
      notie.alert(4, "Text Zoom #{(totalRatio * 100).toFixed()}%", 2)

  if totalRatio == 1
    for el in relevantElements
      el.classList.remove('noTransition') unless TRANSITION_ALLOWED
      el.style['font-size'] = null
      el.style['line-height'] = null

    return util.putInLocalStorage(ZOOM_LEVEL_KEY, false)

  util.putInLocalStorage ZOOM_LEVEL_KEY, (totalRatio - 1)

  # transitions screw up font size measuring
  if prevRatio == 1 && !TRANSITION_ALLOWED
    for el in relevantElements
      el.classList.add('noTransition')

  [].forEach.call relevantElements, (el) ->
    tagName = el.tagName
    return if tagName.match(IGNORED_TAGS)

    computedStyle = getComputedStyle(el)

    if !util.isBlank(el.innerText) || (tagName == 'TEXTAREA')
      currentLh = computedStyle.lineHeight
      lineHeight = multiplyByRatio(currentLh, multiplier) if currentLh.indexOf('px') != -1

    fontSize = multiplyByRatio(computedStyle.fontSize, multiplier)

    changeFontSizeCalls.push ->
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
