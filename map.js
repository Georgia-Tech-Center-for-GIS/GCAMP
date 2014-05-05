/**
	@file Controls Map functionality: adding/deleting layers
*/

dojo.require("esri.layers.FeatureLayer");
dojo.require("esri.layers.WebTiledLayer");
dojo.require("esri.layers.agsdynamic");
dojo.require("esri.layers.wms");

var mapLyrs = ko.observableArray();
var mapLyrToRemove = ko.observable();
var map;

/**
	Adds a map service as either a WMSLayer or ArcGISDynamicMapServiceLayer
	@param url url to map service
	@param label label for map service in the list of added map layers
*/
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

/**
	Removes an (additional) map service from the map, specified by mapLayerToRemove (observable connected to the
	list of map layers)
	@param val
*/
function removeLayerFromMap(val) {
	console.debug(val);
	
	map.removeLayer(mapLyrToRemove.peek().lyr);
	
	mapLyrs.remove(mapLyrToRemove);
	
	init_layer_controls(map);
}

/**
	Actually add the map service to the map
	@param
	@param
*/
function do_add_mapsvc(ev) {
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

/**
	@param
*/
function do_remove_mapsvc(ev) {
	if( mapLyrToRemove != null) {
		removeLayerFromMap(mapLyrToRemove.mapLabel);
	}
}