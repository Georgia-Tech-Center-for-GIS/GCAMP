dojo.require("esri.layers.FeatureLayer");
dojo.require("esri.layers.WebTiledLayer");
dojo.require("esri.layers.agsdynamic");
dojo.require("esri.layers.wms");

var mapLyrs = ko.observableArray();
var mapLyrToRemove = ko.observable();
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
				dijit.byId('AddMapSvcList').startup();
			});
		}
	}
	catch(e) {
		console.debug(e.stack);
	}
}

function removeLayerFromMap(val) {
	console.debug(val);
	
	map.removeLayer(mapLyrToRemove.peek().lyr);
	
	mapLyrs.remove(mapLyrToRemove);
	
	init_layer_controls(map);
}

function do_add_mapsvc(e) {
	var l = selectedNewMapSvc.peek().mapLabel ; //dijit.byId('AddMapSvcLabel').value;
	var u = selectedNewMapSvc.peek().url ; //dijit.byId('AddMapSvcURL').value; if( l == "" || u == "") { }
	{
		try {
			addLayerToMap(u,l);
		}
		catch(e) {
			console.debug(e);
		}
	}
}

function do_remove_mapsvc(e) {
	if( mapLyrToRemove != null) {
		removeLayerFromMap(mapLyrToRemove.mapLabel);
	}
}