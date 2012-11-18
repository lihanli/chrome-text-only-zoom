var DEFAULTS;

DEFAULTS = {};

DEFAULTS[Util.ZOOM_IN_KEY] = 'alt+=';

DEFAULTS[Util.ZOOM_OUT_KEY] = 'alt+-';

DEFAULTS[Util.ZOOM_RESET_KEY] = 'alt+0';


window.chrome = {
  extension: {
    sendMessage: function(data, resCallBack) {
      return resCallBack({
        key: DEFAULTS[data.key]
      });
    }
  }
};