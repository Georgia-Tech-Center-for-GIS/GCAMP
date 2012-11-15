dojo.require("esri.utils");
dojo.require("esri.arcgis.utils");

dojo.require("esri.geometry");
dojo.require("esri.IdentityManager");

dojo.require("dojo.store.Memory");
dojo.require("dojo.data.ObjectStore");

dojo.require("dijit.layout.AccordionContainer");
dojo.require("dijit.layout.BorderContainer");
dojo.require("dijit.layout.ContentPane");
dojo.require("esri.map");

dojo.require("esri.layers.FeatureLayer");
dojo.require("esri.layers.WebTiledLayer");
dojo.require("esri.layers.agsdynamic");

dojo.require("esri.tasks.gp");
dojo.require("esri.dijit.Legend");
dojo.require("esri.dijit.Popup");
dojo.require("dijit.form.DateTextBox");
dojo.require("dijit.Toolbar");

dojo.require("dijit.form.Select");

dojo.require("esri.tasks.identify");

dojo.require("esri.layers.wms");

dojo.require("dojox.xmpp.util");
dojo.require("esri.dijit.BasemapGallery");

//var gpServiceUrl = "http://sampleserver6.arcgisonline.com/arcgis/rest/services/911CallsHotspot/GPServer/911%20Calls%20Hotspot";
//var mapserviceurl = "http://sampleserver6.arcgisonline.com/arcgis/rest/services/911CallsHotspot/MapServer/jobs";
var map, legend;

var mapBase = "http://carto.gis.gatech.edu/arcgis/rest/services/";
var mapMarine = "http://www.csc.noaa.gov/ArcGISPUB/rest/services/MultipurposeMarineCadastre/MultipurposeMarineCadastre/MapServer/";

var cartoLayers = ["NauticalChart522", "Habitat522", "Wetlands530", "CoastalResources61", "Physical522", "Counties531", "Administrative530"];
var marineLayers = ["2", "3", "4", "5"];

var serviceCatalog = [];
/*	{id:1, label:"Coastal and Marine Spatial Planning",url:"http://gis.boemre.gov/arcgis/rest/services/BOEM_BSEE"},
	{id:2, label:"Multipurpose Marine Cadastre",url:"http://www.csc.noaa.gov/ArcGISPUB/rest/services"},
	{id:3, label:"NOAA Nautical Charts",url:"http://ocs-spatial.ncd.noaa.gov/wmsconnector/com.esri.wms.Esrimap/encdirect?"},
	{id:4, label:"Bureau of Ocean Energy Management, Regulation and Enforcement",url:"http://gis.boemre.gov/arcgis/rest/services/BOEM_BSEE"}
];*/

var extents = [];
	
var initialExtent;

var identifyTask, identifyParams, symbol;

var navToolbar;
var ly3;

var generalTabController;

function createBasemapGallery() {	
	var basemaps = [];
	
	var cmspBasemapLayers = [];
	
	var cmspLayers = [
		{label: "Collision Regulation Lanes", url: "http://ocs-gis.ncd.noaa.gov/arcgis/rest/services/CMSP/Collision_regulation_lines/MapServer"},
		{label: "Disposal Areas", url: "http://ocs-gis.ncd.noaa.gov/arcgis/rest/services/CMSP/Disposal_Areas/MapServer"},
		{label: "Precautionary Areas", url: "http://ocs-gis.ncd.noaa.gov/arcgis/rest/services/CMSP/Precautionary_Areas/MapServer"},
		{label: "Restricted Areas", url: "http://ocs-gis.ncd.noaa.gov/arcgis/rest/services/CMSP/Restricted_Areas/MapServer"},
		{label: "Shipping Lanes", url: "http://ocs-gis.ncd.noaa.gov/arcgis/rest/services/CMSP/Shipping_Lanes/MapServer"}
	];
	
	for(var i = 0; i < cmspLayers.length; i++) {
		var bm = new esri.dijit.BasemapLayer({url: cmspLayers[i].url});
		cmspBasemapLayers.push(bm);
		
		var cmspBasemap = new esri.dijit.Basemap({
			layers : [bm],
			title : cmspLayers[i].label
		});
		
		basemaps.push(cmspBasemap);
	}
		
	var basemapGallery = new esri.dijit.BasemapGallery({
		showArcGISBasemaps : true,
		/*"basemaps": basemaps, */
		map: map,
	}, "basemapGallery");
	
	basemapGallery.startup();

	dojo.connect(basemapGallery, "onError", function(err) { console.debug(error); });
	dojo.connect(basemapGallery, "onLoad", function(e) {
		//console.debug("Load");
		//dojo.byId('status').setAttribute("style", "display: block");
	});
	
	dojo.connect(basemapGallery, "onSelectionChange", function(e) {
		console.debug("OnSelectionChange");
		
		dojo.connect(basemapGallery.getSelected(), "onLoad", function(e) {
			console.debug("Load");
			dojo.byId('status').setAttribute("style", "display: none");
		});
		
//			var val = c.pop();
//			lyrs.push({lyr: layer, "label": lbl, id: url, mapLyrId: val });
			layerTitlePane.destroyDescendants();
//			c.push(val);
			init_layer_controls(map);
			//fullExtent();
		
		//dojo.byId('status').setAttribute("style", "display: block");
	});
}

function cvtLatLongExtent_2_WebMercator( extent, fn_when_finished ) {
	var geometryService = new esri.tasks.GeometryService("http://tasks.arcgisonline.com/ArcGIS/rest/services/Geometry/GeometryServer");
	var PrjParams = new esri.tasks.ProjectParameters();
	PrjParams.geometries = [extent];
	PrjParams.outSR = new esri.SpatialReference(3857);

	geometryService.project(PrjParams, fn_when_finished );
}

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
		//layer = new esri.layers.ArcGISTiledMapServiceLayer (url);
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
			layerTitlePane.destroyDescendants();
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
	
	layerTitlePane.destroyDescendants();
	init_layer_controls(map);
}

function prepare_map_when_extents_finished(a) {
		initialExtent = a[0];
		
		esriConfig.defaults.map.sliderLabel = null;
		map = new esri.Map("map", {
				extent : initialExtent
		});
		
		dojo.connect(dijit.byId('map'), 'resize', map,map.resize);
		
		navToolbar = new esri.toolbars.Navigation(map);
		dojo.connect(navToolbar, "onExtentHistoryChange", extentHistoryChangeHandler);
		
		var initBasemap = new esri.layers.ArcGISDynamicMapServiceLayer("http://services.arcgisonline.com/ArcGIS/rest/services/Ocean_Basemap/MapServer");
		map.addLayer(initBasemap);
				
		ly1 = new esri.layers.ArcGISDynamicMapServiceLayer
			//("http://carto.gis.gatech.edu/ArcGIS/rest/services/ViewerJSResources/MapServer");
			("http://carto.gis.gatech.edu/ArcGIS/rest/services/coastal912/MapServer");
		//ly1.setVisibleLayers([12, 13, 17]);
			dojo.connect(ly1, "onLoad", function () {
			init_layer_controls(map);
		});
		
		map.addLayer(ly1);
		
		/* ly2 = new esri.layers.ArcGISDynamicMapServiceLayer
			//("http://www.csc.noaa.gov/ArcGISPUB/rest/services/MultipurposeMarineCadastre/MultipurposeMarineCadastre/MapServer");
			("http://ocs-gis.ncd.noaa.gov/ArcGIS/rest/services/CMSP/US_Maritime_Limits_Boundaries/MapServer");
		//ly2.setVisibleLayers([10, 11, 6]);
			dojo.connect(ly2, "onLoad", function () {
			init_layer_controls(map);
		}); 
		
		map.addLayer(ly2); */
		
		//dojo.connect(map, "onLoad", init_layer_controls);
		dojo.connect(map, "onLoad", init_id_funct);
		//dojo.connect(map, "onLoad", function () { dojo.byId('indic').innerHTML = "Ready..."; } );
		legendInfos = ly1.layerInfos;
		//legendInfos.concat(ly2.layerInfos);
		
		layerStoreMemory = new dojo.store.Memory({data: lyrs});
		layerStore = new dojo.data.ObjectStore({objectStore: layerStoreMemory});
			
		var lyrSelect = new dijit.form.Select({
			name: "",
			style: "width: 15em; height: 2em;",
			store: layerStore,
			maxHeight: "20em;"},
			"SelectMapLayer");

		lyrSelect.startup();
		
		var args = {
				url: "http://carto.gis.gatech.edu/proxypage_net/sites.ashx",
				handleAs: "json",
				load: function(data) {
					console.debug(data);
					serviceCatalog = [];
					
					for(var i = 0; i < data.length; i++) {
						if(data[i].label != "") {
							serviceCatalog.push(
								{ url: data[i].url, label: data[i].label, id: i+1}
							);
						}
					}
					
							layerStoreChoicesMemory = new dojo.store.Memory({data: serviceCatalog});
		layerStoreChoices = new dojo.data.ObjectStore({objectStore: layerStoreChoicesMemory});

		var lyrSelect2 = new dijit.form.Select({
			name: "",
			style: "width: 15em; height: 2em; font-size: 8pt;",
			store: layerStoreChoices,
			maxHeight: "20em;"},
			"SelectMapLayerCatalog");
					
		lyrSelect2.startup();
		
		dojo.connect(lyrSelect2, "onChange", function (nv) {
			if(layerStoreChoicesMemory.get(nv) == null) return;
			
			dijit.byId('AddMapSvcURL').set("value" , layerStoreChoicesMemory.get(nv).url);
		});

				}
				};
		esri.request(args);
}

function init() {
	esriConfig.defaults.io.proxyUrl = "http://carto.gis.gatech.edu/proxypage_net/proxy.ashx";
	esriConfig.defaults.io.alwaysUseProxy = true;
	
	esri.config.defaults.io.corsEnabledServers.push("http://carto.gis.gatech.edu");
	esri.config.defaults.io.corsEnabledServers.push("http://www.csc.noaa.gov");
	esri.config.defaults.io.corsEnabledServers.push("http://ocs-gis.ncd.noaa.gov");
	esri.config.defaults.io.corsEnabledServers.push("http://services.arcgisonline.com");
	esri.config.defaults.io.corsEnabledServers.push("http://tasks.arcgisonline.com");
	 
	extents = [
		new esri.geometry.Extent( {"ymin": 31, "ymax": 33, "xmin" : -87, "xmax": -78, "spatialReference": { "wkid" : 4269 } } ) , //all
		new esri.geometry.Extent( {"ymin": 31, "ymax": 33, "xmin" : -87, "xmax": -78, "spatialReference": { "wkid" : 4269 } } ) , //on-shore
		new esri.geometry.Extent( {"ymin": 28, "ymax": 35, "xmin" : -81, "xmax": -73, "spatialReference": { "wkid" : 4269 } } ) , //coast
		new esri.geometry.Extent( {"ymin": 31, "ymax": 33, "xmin" : -87, "xmax": -78, "spatialReference": { "wkid" : 4269 } } )   //ocean
	];
	
	initialExtent = extents[2];
	
	dojo.connect(dijit.byId("RightExPanel"), "_showEnd", function () {
		dojo.byId("paneTitleRight").style.setProperty("visibility", "hidden");
	});
	
	dojo.connect(dijit.byId("RightExPanel"), "_hideEnd", function () {
		dojo.byId("paneTitleRight").style.setProperty("visibility", "");
	});

	dojo.connect(dijit.byId("LeftExPanel"), "_showEnd", function () {
		dojo.byId("paneTitleLeft").style.setProperty("visibility", "hidden");
	});
	
	dojo.connect(dijit.byId("LeftExPanel"), "_hideEnd", function () {
		dojo.byId("paneTitleLeft").style.setProperty("visibility", "");
	});
	
	dojo.connect(dijit.byId(""), "onClick", function(evt) {
								var l = dijit.byId('AddMapSvcLabel').value;
								var u = dijit.byId('AddMapSvcURL').value;
								
								if( l == "" || u == "") {
								}
								else {
									addLayerToMap(map,u,l);
									
									//dijit.byId('AddMapSvcLabel').value = "";
									//dijit.byId('AddMapSvcURL').value = "";
								}
	});
	
	dojo.connect(dijit.byId('MapType'), "onChange", sliderChanged);
	
	cvtLatLongExtent_2_WebMercator( initialExtent, prepare_map_when_extents_finished);
}

function init_id_funct(map) {
	dojo.connect(map, "onClick", doIdentify);
	createBasemapGallery();
	//identifyTask = new esri.tasks.IdentifyTask("http://www.csc.noaa.gov/ArcGISPUB/rest/services/MultipurposeMarineCadastre/MultipurposeMarineCadastre/MapServer");
	identifyTask = new esri.tasks.IdentifyTask(ly1.url);
	//"http://carto.gis.gatech.edu/ArcGIS/rest/services/ViewerJSResources/MapServer");
	
	identifyParams = new esri.tasks.IdentifyParameters();
	identifyParams.tolerance = 4;
	identifyParams.returnGeometry = true;
	identifyParams.layerIds = null; //[12,13,17];//[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17];
	identifyParams.layerOption = esri.tasks.IdentifyParameters.LAYER_OPTION_VISIBLE;
	identifyParams.width = map.width;
	identifyParams.height = map.height;
	
	map.infoWindow.resize(415, 200);
	map.infoWindow.setContent("_");
	map.infoWindow.setTitle("Identify Results");
	
	symbol = new esri.symbol.SimpleFillSymbol(
			esri.symbol.SimpleFillSymbol.STYLE_SOLID,
			new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255, 0, 0]), 2),
			new dojo.Color([255, 255, 0, 0.25]));
}

function toggleIdentifyOn(pne) {
	if(!pne._showing) {
		pne.toggle();
	}
}

function toggleIdentifyOff(pne) {
	if(pne._showing) {
		pne.toggle();
	}
}


function fullExtent() {
	map.setExtent(initialExtent);
}

function extentHistoryChangeHandler() {
	//dijit.byId("zoomprev").disabled = navToolbar.isFirstExtent();
	//dijit.byId("zoomnext").disabled = navToolbar.isLastExtent();
}

function sliderChanged(value) {
	var num = Math.floor(value/100 * extents.length);
	
	if(value == 100) num = extents.length - 1;
	
	//console.debug(num);
	
	cvtLatLongExtent_2_WebMercator( extents[num], function(res) {
		initialExtent = res[0];
		fullExtent();
	});
}

dojo.addOnLoad(init);