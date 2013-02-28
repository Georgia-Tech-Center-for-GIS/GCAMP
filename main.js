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

dojo.require("esri.toolbars.draw");
dojo.require("esri.toolbars.navigation");
dojo.require("dojo.number");

dojo.require("dijit.form.Select");

dojo.require("dojox.layout.ContentPane");

dojo.require("esri.tasks.identify");

dojo.require("esri.layers.wms");

dojo.require("dojox.xmpp.util");
dojo.require("esri.dijit.BasemapGallery");

dojo.require("esri.dijit.Scalebar");

//var gpServiceUrl = "http://sampleserver6.arcgisonline.com/arcgis/rest/services/911CallsHotspot/GPServer/911%20Calls%20Hotspot";
//var mapserviceurl = "http://sampleserver6.arcgisonline.com/arcgis/rest/services/911CallsHotspot/MapServer/jobs";
var map, legend;

var mapBase = "http://carto.gis.gatech.edu/arcgis/rest/services/";
var mapMarine = "http://www.csc.noaa.gov/ArcGISPUB/rest/services/MultipurposeMarineCadastre/MultipurposeMarineCadastre/MapServer/";

var cartoLayers = ["NauticalChart522", "Habitat522", "Wetlands530", "CoastalResources61", "Physical522", "Counties531", "Administrative530"];
var marineLayers = ["2", "3", "4", "5"];
var selectedNewMapSvc = ko.observable();

var loaded = ko.observable();

var mapSvrChoices = ko.observable(
[
	{id:1, mapLabel:"Raster Nautical Charts (RNC)",url:"http://egisws02.nos.noaa.gov/ArcGIS/rest/services/RNC/NOAA_RNC/MapServer"},
	{id:2, mapLabel:"BOEM",url:"http://gis.boemre.gov/arcgis/rest/services/BOEM_BSEE/MMC_Layers/MapServer"},
	{id:3, mapLabel:"Marine Cadastre",url:"http://www.csc.noaa.gov/ArcGISPUB/rest/services/MultipurposeMarineCadastre/MultipurposeMarineCadastre/MapServer"},
	{id:4, mapLabel:"National Map", url: "http://services.nationalmap.gov/ArcGIS/rest/services/"},
	//{id:5, mapLabel:"NOAA CMSP", url: ""},
	{id:6, mapLabel:"SAFMC", url: "http://ocean.floridamarine.org/ArcGIS/rest/services/NauticalCharts/MapServer"}
]);

var extents = [];
	
var initialExtent;

var identifyTask, identifyParams, symbol;

var navToolbar;
var initBasemap;
var ly_Energy;
var ly_Habitat;
var ly_DEM;

var MapSvcAllLayers = new CreateCollection("MapSvcList");

var cMapTool = ko.observable( "pan" );

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
		
		init_layer_controls(map);
	});
}

function cvtLatLongExtent_2_WebMercator( extent, fn_when_finished ) {
	var geometryService = new esri.tasks.GeometryService("http://tasks.arcgisonline.com/ArcGIS/rest/services/Geometry/GeometryServer");
	var PrjParams = new esri.tasks.ProjectParameters();
	PrjParams.geometries = [extent];
	PrjParams.outSR = new esri.SpatialReference(3857);

	geometryService.project(PrjParams, fn_when_finished );
}

function prepare_map_when_extents_finished(a) {
		initialExtent = a[0];
		
		map = new esri.Map("map", {
				extent : initialExtent
		});
		
		dojo.connect(dijit.byId('map'), "onLoad", function() { });
		
		dojo.connect(map, "onMouseMove", showMouseCoordinates);
		dojo.connect(map, "onMouseDrag", showMouseCoordinates);
			
		initBasemap = new esri.layers.ArcGISDynamicMapServiceLayer("http://services.arcgisonline.com/ArcGIS/rest/services/Ocean_Basemap/MapServer");

		MapSvcAllLayers.add(new MapSvcDef("BaseMap", "http://services.arcgisonline.com/ArcGIS/rest/services/Ocean_Basemap/MapServer", ServiceType_Tiled, map, null));
		MapSvcAllLayers.add(new MapSvcDef("DEM", "http://tulip.gis.gatech.edu:6080/arcgis/rest/services/CDEM/MapServer", ServiceType_Dynamic, map, null));
		MapSvcAllLayers.add(new MapSvcDef("Carto", "http://tulip.gis.gatech.edu:6080/arcgis/rest/services/coastal213/MapServer", ServiceType_Dynamic, map, null));

		MapSvcAllLayers.initializeAllMapSerivceLayers(map, "Something Else happened", function () {
			loaded(true);
			$('#SplashCloseBtn').button('reset');
			
			map.getLayer( map.layerIds[1] ).visibleLayers = [];
			map.getLayer( map.layerIds[1] ).setVisibility(false);

			ko.applyBindings();
			
			navToolbar = new esri.toolbars.Navigation(map);
			
			dojo.connect('onExtentHistoryChange', extentHistoryChangeHandler);
			
			$('#zoomInBtn').on('click', function(e) {
				navToolbar.activate(esri.toolbars.Navigation.ZOOM_IN);
			});

			$('#zoomPrevBtn').on('click', function(e) {
				navToolbar.zoomToPrevExtent();
			});
			
			$('#zoomFullExtBtn').on('click', function(e) {
				fullExtent();
			});
			
			$('#allLayersLink').on('click', function(e) {
				map.removeAllLayers();
				MapSvcAllLayers = new CreateCollection("MapSvcList");
				
				MapSvcAllLayers.add(new MapSvcDef("BaseMap", "http://services.arcgisonline.com/ArcGIS/rest/services/Ocean_Basemap/MapServer", ServiceType_Tiled, map, null));
				MapSvcAllLayers.add(new MapSvcDef("DEM", "http://tulip.gis.gatech.edu:6080/arcgis/rest/services/CDEM/MapServer", ServiceType_Dynamic, map, null));
				MapSvcAllLayers.add(new MapSvcDef("Carto", "http://tulip.gis.gatech.edu:6080/arcgis/rest/services/coastal213/MapServer", ServiceType_Dynamic, map, null));				
				MapSvcAllLayers.initializeAllMapSerivceLayers(map, "Something Else happened", function() {
					map.getLayer( map.layerIds[1] ).visibleLayers = [];
					map.getLayer( map.layerIds[1] ).setVisibility(false);

					init_layer_controls(map);
					init_id_funct(map);
				});
			});
			
			$('#energyLink').on('click', function(e) {
				map.removeAllLayers();
				MapSvcAllLayers = new CreateCollection("MapSvcList");
				
				MapSvcAllLayers.add(new MapSvcDef("BaseMap", "http://services.arcgisonline.com/ArcGIS/rest/services/Ocean_Basemap/MapServer", ServiceType_Tiled, map, null));
				MapSvcAllLayers.add(new MapSvcDef("DEM", "http://tulip.gis.gatech.edu:6080/arcgis/rest/services/CDEM/MapServer", ServiceType_Dynamic, map, null));
				MapSvcAllLayers.add(new MapSvcDef("Energy", "http://tulip.gis.gatech.edu:6080/arcgis/rest/services/GACoast/Energy/MapServer", ServiceType_Dynamic, map, null));				
				MapSvcAllLayers.initializeAllMapSerivceLayers(map, "Something Else happened", function() {
					map.getLayer( map.layerIds[1] ).visibleLayers = [];
					map.getLayer( map.layerIds[1] ).setVisibility(false);

					init_layer_controls(map);
					init_id_funct(map);
				});			
			});
			
			$('#habitatLink').on('click', function(e) {
				map.removeAllLayers();
				MapSvcAllLayers = new CreateCollection("MapSvcList");
				
				MapSvcAllLayers.add(new MapSvcDef("BaseMap", "http://services.arcgisonline.com/ArcGIS/rest/services/Ocean_Basemap/MapServer", ServiceType_Tiled, map, null));
				MapSvcAllLayers.add(new MapSvcDef("DEM", "http://tulip.gis.gatech.edu:6080/arcgis/rest/services/CDEM/MapServer", ServiceType_Dynamic, map, null));
				MapSvcAllLayers.add(new MapSvcDef("Habitat", "http://tulip.gis.gatech.edu:6080/arcgis/rest/services/GACoast/habitat/MapServer", ServiceType_Dynamic, map, null));				
				MapSvcAllLayers.initializeAllMapSerivceLayers(map, "Something Else happened", function() {
					map.getLayer( map.layerIds[1] ).visibleLayers = [];
					map.getLayer( map.layerIds[1] ).setVisibility(false);

					init_layer_controls(map);
					init_id_funct(map);
				});			
			});
			
			$('#fisheriesLink').on('click', function(e) {
				map.removeAllLayers();
				MapSvcAllLayers = new CreateCollection("MapSvcList");
				
				MapSvcAllLayers.add(new MapSvcDef("BaseMap", "http://services.arcgisonline.com/ArcGIS/rest/services/Ocean_Basemap/MapServer", ServiceType_Tiled, map, null));
				MapSvcAllLayers.add(new MapSvcDef("DEM", "http://tulip.gis.gatech.edu:6080/arcgis/rest/services/CDEM/MapServer", ServiceType_Dynamic, map, null));
				MapSvcAllLayers.add(new MapSvcDef("Fisheries", "http://tulip.gis.gatech.edu:6080/arcgis/rest/services/GACoast/Fisheries/MapServer", ServiceType_Dynamic, map, null));				
				MapSvcAllLayers.initializeAllMapSerivceLayers(map, "Something Else happened", function() {
					map.getLayer( map.layerIds[1] ).visibleLayers = [];
					map.getLayer( map.layerIds[1] ).setVisibility(false);

					init_layer_controls(map);
					init_id_funct(map);
				});			
			});

			$('#panBtn').on('click', function(e) {
				navToolbar.activate(esri.toolbars.Navigation.PAN);
			});
			
			scalebar = new esri.dijit.Scalebar({
				map: map,
				/*attachTo:"top-left"*/
			});
					
			legend = new esri.dijit.Legend({
				map:map
			},"legendSection");
			
			createBasemapGallery();
				
			legend.startup();
			init_layer_controls(map);
			init_id_funct(map);
		});
			
		var args = {
			url: "http://carto.gis.gatech.edu/proxypage_net/sites.ashx",
			handleAs: "json",
			load: function(data) {
				serviceCatalog = [];
				
				for(var i = 0; i < data.length; i++) {
					if(data[i].label != "") {
						serviceCatalog.push(
							{ url: data[i].url, label: data[i].label, id: i+1}
						);
					}
				}
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
		/*
		new esri.geometry.Extent( {"ymin": 31, "ymax": 33, "xmin" : -87, "xmax": -78, "spatialReference": { "wkid" : 4269 } } ) , //all
		new esri.geometry.Extent( {"ymin": 31, "ymax": 33, "xmin" : -87, "xmax": -78, "spatialReference": { "wkid" : 4269 } } ) , //on-shore
		new esri.geometry.Extent( {"ymin": 28, "ymax": 35, "xmin" : -81, "xmax": -73, "spatialReference": { "wkid" : 4269 } } ) , //coast
		new esri.geometry.Extent( {"ymin": 31, "ymax": 33, "xmin" : -87, "xmax": -78, "spatialReference": { "wkid" : 4269 } } )   //ocean
		*/
		new esri.geometry.Extent( {"ymin": 30.561, "ymax": 32.422, "xmin": -82.319, "xmax": -79.973, "spatialReference": { "wkid" : 4269 }} )
	];
	
	initialExtent = extents[0];
		
	cvtLatLongExtent_2_WebMercator( initialExtent, prepare_map_when_extents_finished);
}

var map_x_coord = ko.observable("-00.00");
var map_y_coord = ko.observable("00.00");

var lastMapEv = null;

function showMouseCoordinates(e) {
	lastMapEv = e;
	
	var mp = esri.geometry.webMercatorToGeographic(e.mapPoint);
	
	// DMS
	if(false) {
		var degX = Math.floor(mp.x);
		var degY = Math.floor(mp.y);
		
		var minX = (Math.abs(mp.x - degX) * 60);
		var minY = (Math.abs(mp.y - degY) * 60);
		
		var secX = (Math.abs(minX - Math.floor(minX)) * 60);
		var secY = (Math.abs(minY - Math.floor(minY)) * 60);
		
		map_x_coord(degX + "* " + Math.floor(minX) + "\' " + Math.floor(secX) + "\"" );
		map_y_coord(degY + "* " + Math.floor(minY) + "\' " + Math.floor(secY) + "\"" );
	}
	// DD
	else {
		map_x_coord(mp.x.toFixed(4));
		map_y_coord(mp.y.toFixed(4))
	}
}

function init_id_funct(map) {
	identifyTask = new esri.tasks.IdentifyTask(
		map.getLayer(map.layerIds[2]).url
	/* "http://carto.gis.gatech.edu/ArcGIS/rest/services/TidalEnergyTest/MapServer"*/ );
	
	identifyParams = new esri.tasks.IdentifyParameters();
	identifyParams.tolerance = 1;
	identifyParams.returnGeometry = true;
	identifyParams.layerIds = []; //[12,13,17];//[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17];
	identifyParams.layerOption = esri.tasks.IdentifyParameters.LAYER_OPTION_VISIBLE;
	identifyParams.width = map.width;
	identifyParams.height = map.height;
	
	map.infoWindow.resize(415, 200);
	map.infoWindow.setContent("_");
	map.infoWindow.setTitle("Identify Results");
	
	//getAttributesLayer("http://carto.gis.gatech.edu/ArcGIS/rest/services/coastal1112/MapServer/14");
}

function return_to_LayerList() {
	$('#layerTabLink').tab('show');
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

var handleIdentify = null;
var tabs;

function jQueryReady() {
	$(function() {
		$('.scroll-pane').jScrollPane();
		
		tabs = $('a[data-toggle="tab"]').on('shown', function (e) {
			if( $(e.target).attr('href') == "#identifyPane") {
				handleIdentify = dojo.connect(map, "onClick", doIdentify);
			}
			else {

				if(handleIdentify != null) {
					dojo.disconnect(handleIdentify);
					handleIdentify = null;
				}
			}
			
			//alert($(e.target).attr('href')) //e.target // activated tab
			//e.relatedTarget // previous tab
			$('.scroll-pane').jScrollPane();
		})
	
		$('#intro').modal();
		
		$('#SplashCloseBtn').button('loading');
	});
}

$(document).ready(jQueryReady);
dojo.addOnLoad(init);