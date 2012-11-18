DEFAULTS = {}
DEFAULTS[Util.ZOOM_IN_KEY]    = 'alt+='
DEFAULTS[Util.ZOOM_OUT_KEY]   = 'alt+-'
DEFAULTS[Util.ZOOM_RESET_KEY] = 'alt+0'

chrome.extension.onMessage.addListener (req, sender, sendResponse) ->
  sendResponse key: Util.getFromLocalStorage(req.key) ? DEFAULTS[req.key]
