var lyrs = [];
var layerStore = null;
var e = null;

function addLayerToMap(url,label) {
	var lbl = dojox.xmpp.util.stripHtml(label);
	var layer = null;
	
	if(url.lastIndexOf("WMS") >= 0 || url.lastIndexOf("wms") >= 0) {
		layer = new esri.layers.WMSLayer(url);
	}
	else {
		layer = new esri.layers.ArcGISDynamicMapServiceLayer ( url );	
		map.addLayer(layer);
	}
	
	if(layer == null) {
	}
	else {
		dojo.connect( layer, "onLoad", function(ev) {
			c = map.layerIds;
			var val = c.pop();
				lyrs.push({lyr: layer, "label": lbl, id: url, mapLyrId: val });
			c.push(val);
			
			init_layer_controls(map);
			
			legend.useAllMapLayers = true;
			legend.refresh();
			
			dijit.byId('SelectMapLayer').startup();		
		});
	}
}

function removeLayerFromMap(s,val) {
	var storedObj = s.store.objectStore.query({"id": val})[0];
	
	console.debug(val);
	console.debug(storedObj);
	
	map.removeLayer(storedObj.lyr);
	lyrs = lyrs.filter( function(v,i,a) {
		if ( v.id == val ) return false;
		return true;
	});
	
	s.store.objectStore.data = lyrs;
	s.startup();
	
	init_layer_controls(map);
}