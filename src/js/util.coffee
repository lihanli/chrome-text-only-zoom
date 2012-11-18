Util =
  ZOOM_IN_KEY:    'zoomInKey'
  ZOOM_OUT_KEY:   'zoomOutKey'
  ZOOM_RESET_KEY: 'zoomResetKey'
  getFromLocalStorage: (key) ->
    value = localStorage[key]
    return JSON.parse(value) if value
    null
  putInLocalStorage: (key, value) ->
    localStorage[key] = JSON.stringify(value)

root = exports ? window
root.Util = Util
