dojo.require("esri.layers.FeatureLayer");
dojo.require("esri.layers.WebTiledLayer");
dojo.require("esri.layers.agsdynamic");
dojo.require("esri.layers.wms");

var mapLyrs = ko.observableArray();
var map;

function addLayerToMap(url,label) {
	var lbl = dojox.xmpp.util.stripHtml(label);
	var layer = null;
	
	try {
		if(url.lastIndexOf("WMS") >= 0 || url.lastIndexOf("wms") >= 0) {
			layer = new esri.layers.WMSLayer(url);
		}
		else {
			layer = new esri.layers.ArcGISDynamicMapServiceLayer ( url );	
		}
		
		var a = map.addLayer(layer);
	
		if(layer == null) {
			console.debug("NULL");
		}
		else {
			dojo.connect( layer, "onLoad", function(ev) {

				mapLyrs.push({lyr: layer, mapLabel: lbl, id: url, mapLyrId: a.id, "value": layer });
				
				return_map_layers();
				
				legend.useAllMapLayers = true;
				legend.refresh();
				
				dijit.byId('SelectMapLayer').startup();
			});
		}
	}
	catch(e) {
		console.debug(e.stack);
	}
}

function removeLayerFromMap(val) {
	console.debug(val);
	
	map.removeLayer(storedObj.lyr);
	mapLyrs = lyrs.filter( function(v,i,a) {
		if ( v.id == val ) return false;
		return true;
	});
	
	init_layer_controls(map);
}