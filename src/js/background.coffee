DEFAULTS = {}
DEFAULTS[Util.KEYS.ZOOM_IN_KEY]    = 'alt+='
DEFAULTS[Util.KEYS.ZOOM_OUT_KEY]   = 'alt+-'
DEFAULTS[Util.KEYS.ZOOM_RESET_KEY] = 'alt+0'

class Settings
  constructor: (@sendResponse) ->

  resetDefaults: ->
    for _, key of Util.KEYS
      localStorage.removeItem key
    Util.defaultResponse @sendResponse

  key: (keyName) ->
    @sendResponse key: Util.getFromLocalStorage(keyName) ? DEFAULTS[keyName]

  saveKeys: (newKeys) ->
    for k,v of newKeys
      Util.putInLocalStorage k, v
    Util.defaultResponse @sendResponse

chrome.extension.onMessage.addListener (req, sender, sendResponse) ->
  settings = new Settings(sendResponse)
  for k,v of req
    settings[k] v
