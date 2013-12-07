DEFAULTS = {}
DEFAULTS[util.KEYS.ZOOM_IN_KEY]    = 'alt+='
DEFAULTS[util.KEYS.ZOOM_OUT_KEY]   = 'alt+-'
DEFAULTS[util.KEYS.ZOOM_RESET_KEY] = 'alt+0'

class Settings
  constructor: (@sendResponse) ->

  resetDefaults: ->
    for _, key of util.KEYS
      localStorage.removeItem key
    util.defaultResponse @sendResponse

  key: (keyName) ->
    @sendResponse key: util.getFromLocalStorage(keyName) ? DEFAULTS[keyName]

  saveKeys: (newKeys) ->
    for k,v of newKeys
      util.putInLocalStorage k, v
    util.defaultResponse @sendResponse

chrome.extension.onMessage.addListener (req, sender, sendResponse) ->
  settings = new Settings(sendResponse)
  for k,v of req
    settings[k] v
