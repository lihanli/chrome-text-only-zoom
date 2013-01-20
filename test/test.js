var listeners = [];

window.chrome = {
  extension: {
  	onMessage: {
  		addListener: function(listener) {
  			listeners.push(listener);
  		}
  	},
    sendMessage: function(data, resCallBack) {
    	listeners[0](data, null, function (res) {
    		return resCallBack(res);
    	});
    }
  }
};