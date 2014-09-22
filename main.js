/**
@file Initializes map elements
*/

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
dojo.require("esri.dijit.Measurement");
dojo.require("esri.dijit.Print");

dojo.require("esri.dijit.TimeSlider");

dojo.require("dijit.form.DateTextBox");
dojo.require("dijit.Toolbar");

dojo.require("esri.toolbars.draw");
dojo.require("esri.toolbars.navigation");
dojo.require("dojo.number");

dojo.require("dijit.form.Select");
dojo.require("dijit.form.HorizontalSlider");

dojo.require("dojox.layout.ContentPane");

dojo.require("esri.tasks.identify");

dojo.require("esri.layers.wms");

dojo.require("dojox.xmpp.util");
dojo.require("esri.dijit.BasemapGallery");

dojo.require("esri.dijit.Scalebar");

var map, legend;

var mapBase = "http://carto.gis.gatech.edu/arcgis/rest/services/";
var mapMarine = "http://www.csc.noaa.gov/ArcGISPUB/rest/services/MultipurposeMarineCadastre/MultipurposeMarineCadastre/MapServer/";

var defaultBasemapURL = "http://services.arcgisonline.com/ArcGIS/rest/services/Ocean_Basemap/MapServer";

/** URL to DEM (map) service */
var DEM_URL = "http://tulip.gis.gatech.edu:6080/arcgis/rest/services/GACoast/LidarCZM/MapServer";
/** NOAA Raster Nautical Charts service URL */
var NOAA_NautChartURL = "http://egisws02.nos.noaa.gov/ArcGIS/rest/services/RNC/NOAA_RNC/ImageServer";
/** Main tulip map service URL */
var TulipMapServiceURL = "http://tulip.gis.gatech.edu:6080/arcgis/rest/services/GACoast/GCAMP514/MapServer";

/** URL for Energy tab */
var EnergyMapServiceURL = "http://tulip.gis.gatech.edu:6080/arcgis/rest/services/GACoast/Energy/MapServer";
/** URL for Habitat tab */
var HabitatMapServiceURL = "http://tulip.gis.gatech.edu:6080/arcgis/rest/services/GACoast/habitat/MapServer";
/** URL for Fisheries tab */
var FisheriesMapServiceURL = "http://tulip.gis.gatech.edu:6080/arcgis/rest/services/GACoast/Fisheries/MapServer";

/** Current main map service; */
var CurrentMainMapServiceURL = TulipMapServiceURL;

var cartoLayers = ["NauticalChart522", "Habitat522", "Wetlands530", "CoastalResources61", "Physical522", "Counties531", "Administrative530"];
var marineLayers = ["2", "3", "4", "5"];
var selectedNewMapSvc = ko.observable();

var loaded = ko.observable();

var timeSelValue = ko.observable();
var timeSliderVisible = ko.observable(false);

var opacityLayers = ko.observableArray();

var mapSvrChoices = ko.observable(
[
	{id:1, mapLabel:"Raster Nautical Charts (RNC)",url:"http://egisws02.nos.noaa.gov/ArcGIS/rest/services/RNC/NOAA_RNC/MapServer"},
	{id:2, mapLabel:"BOEM",url:"http://gis.boemre.gov/arcgis/rest/services/BOEM_BSEE/MMC_Layers/MapServer"},
	{id:3, mapLabel:"Marine Cadastre",url:"http://www.csc.noaa.gov/ArcGISPUB/rest/services/MultipurposeMarineCadastre/MultipurposeMarineCadastre/MapServer"},
	//{id:4, mapLabel:"National Map", url: "http://services.nationalmap.gov/ArcGIS/rest/services/"},
	//{id:5, mapLabel:"NOAA CMSP", url: ""},
	{id:5, mapLabel:"SAFMC", url: "http://ocean.floridamarine.org/ArcGIS/rest/services/NauticalCharts/MapServer"},
	{id:6, mapLabel:"Carto/Coast", url: "http://carto.gis.gatech.edu/ArcGIS/rest/services/coastal113/MapServer"}
]);

var extents = [];
	
var initialExtent = null;

var isSidebarVisible = ko.observable(true);
var currTab = ko.observable("All Layers");
var map_width = ko.observable("100%");

var identifyTask, identifyParams, symbol;
var geometryService = null;

var navToolbar = null;
var drwToolbar = null;
var initBasemap = null;
var ly_Energy = null;
var ly_Habitat = null;
var ly_DEM = null;

var printer = null;
var timeSlider = null;
var timeSliderEnabled = ko.observable(false);

var MapSvcAllLayers = new CreateCollection("MapSvcList");

var cMapTool = ko.observable( "pan" );

var generalTabController = null;

var isMapGraphicsEmpty = ko.observable(true);
var timeLayerIds = ko.observableArray([]);

var handleIdentify = null;
var handleIdentifySummary = null;

var tabs = null;
var jpanes = null;

var lastGraphic = null;
var multipleSelectSummary = null;

var map_x_coord = ko.observable("-00.00");
var map_y_coord = ko.observable("00.00");

var abs_map_scale = ko.observable("0");

var lastMapEv = null;

var rr = null;

var opacityControl = null;

/**
Creates the basemap gallery widget
*/
function createBasemapGallery() {	
	var basemaps = [];
	
	var cmspBasemapLayers = [];
	
	/*var cmspLayers = [
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
	}*/
	
	require(["esri/dijit/Basemap","esri/dijit/BasemapLayer", "esri/layers/WebTiledLayer"], function(Basemap,BasemapLayer,WebTiledLayer) {
		var wcLyr = new WebTiledLayer("http://${subDomain}.tile.stamen.com/watercolor/${level}/${col}/${row}.jpg", {
		  "copyright": "Stamen Designs",
		  "id": "StamenWaterColors",
		  "subDomains": ["a", "b", "c","d"]
		});
		
		//map.addLayer(wcLyr);
		
		var wcbm = new BasemapLayer({
		  url: "http://${subDomain}.tile.stamen.com/watercolor/${level}/${col}/${row}.jpg",
		  type: "WebTiledLayer",
		  copyright: "Stamen Designs",
		  "id": "StamenWaterColors",
		  subDomains: ["a", "b", "c","d"],
		});
		
		var wcmap = new Basemap ({
			layers: [wcbm],
			title: "Watercolor",
			id: "SWC"
		});
		
		basemaps.push(wcmap);
			
		var basemapGallery = new esri.dijit.BasemapGallery({
			//showArcGISBasemaps : true,
			"basemaps": basemaps,
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
	});
}

/**
	Function called to convert an extent in decimal degrees/ lat/long to Web Mercator
*/
/*function cvtLatLongExtent_2_WebMercator( extent, fn_when_finished ) {
	/*var geometryService = new esri.tasks.GeometryService("http://tulip.gis.gatech.edu:6080/arcgis/rest/services/Utilities/Geometry/GeometryServer");
	var PrjParams = new esri.tasks.ProjectParameters();
	PrjParams.geometries = [extent];
	PrjParams.outSR = new esri.SpatialReference(3857);

	geometryService.project(PrjParams, fn_when_finished );

	fn_when_finished( null );
}*/

/**
	Handles map measurement through the ESRI Geometry service
*/
function doMeasure(graphics) {
	if(graphics[0].geometry.type != "POLYGON") {
		var geometryService = new esri.tasks.GeometryService("http://tulip.gis.gatech.edu:6080/arcgis/rest/services/Utilities/Geometry/GeometryServer");
		var lp = new esri.tasks.LengthsParameters();
		lp.polylines = graphics;
		lp.lengthUnit = esri.tasks.GeometryService.UNIT_FOOT;
		
		geometryService.lengths(lp, outputDistance);
	}
	else {
		var geometryService = new esri.tasks.GeometryService("http://tulip.gis.gatech.edu:6080/arcgis/rest/services/Utilities/Geometry/GeometryServer");
		var ap = new esri.tasks.AreasAndLengthsParameters();
		ap.polygons = graphics;
		ap.areaUnit = esri.tasks.GeometryService.UNIT_ACRE;
		ap.lengthUnit = esri.tasks.GeometryService.UNIT_FOOT;
		
		geometryService.areasAndLengths(ap, outputDistance);
	}
}

/**
	
*/
function hideDEMLayer() {
	try {
		mLayer = map.getLayer("DEM");
		mLayer.visibleLayers = [];
		mLayer.setVisibility(false);
	}
	catch(e) {
		console.debug(e);
	}
}

/**

*/
function outputDistance(result) {
	console.debug(result);
}

/**
*/
function addOpacityControl() {
	try {
		var targetElem = dojo.byId("RNC_opacity_control");
		//var sliderElem = dojo.create("div", {id: "RNC_opacity_control_slider"}, targetElem, "first");
		
		var dynamicLayer = map.getLayer("NauticalCharts");
		dynamicLayer.setOpacity( 0 );
		
		$("#RNC_opacity_control").slider({
			value: 0,
			min: 0,
			max: 1,
			step: 0.05,
			slide: function(ev, ui) {
				dynamicLayer.setOpacity( ui.value );
			}
		});
	}
	catch (exc) {
	}
}

function getMapLayerTimeInfo (urlQ, index, fnIfNotNull, fnIfNull) {
	try {
		require(["esri/request"], function(esriRequest) {
			var timeLayers = esriRequest({
				url: urlQ + "/" + index + "?f=json",
				handleAs: "json",
			});
			
			timeLayers.then(function(result){			
				if( result.hasOwnProperty("timeInfo")) {					
					if(fnIfNotNull != null)
						fnIfNotNull(result.name, result.timeInfo);
					else
						return result.timeInfo;
				}
				else {
					if(fnIfNull != null)
						fnIfNull();
					else
						return null;
				}
			});
		});
	}
	catch(eee) {
		return null;
	}
}

/**
If there are time-enabled layers enumerated, turn on the time slider, etc.
*/
function checkTimeLayers() {
	//timeSliderVisible(timeLayerIds().length > 0);
	timeSliderVisible(false);
	timeSliderEnabled(timeLayerIds().length > 0);
	
	if(timeLayerIds().length == 0) {
		timeSliderEnabled(false);
		return;
	}
	else
	{
		var timeExtent = new esri.TimeExtent();
		timeExtent.startTime = new Date("1/1/2011 EST");
		map.setTimeExtent(timeExtent);

		if(timeSlider == null) {
			timeSlider = new esri.dijit.TimeSlider({
			  style: "width: 800px;"
			}, dojo.byId("timeSliderDiv"));

			map.setTimeSlider(timeSlider);
			timeSlider.setThumbCount(2);
			
			var layerTimeExtent = map.getLayer( map.layerIds[3] ).timeInfo.timeExtent;
			layerTimeExtent.startTime = timeExtent.startTime;
			timeSlider.createTimeStopsByTimeInterval(layerTimeExtent, 1, 'esriTimeUnitsMonths');
			timeSlider.setThumbMovingRate(1500);			
			timeSlider.setLoop(true);
			timeSlider.setLabels(["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]);
			timeSlider.startup();
			
			//timeSlider.setThumbIndexes([0,1]);
			
			$('#timeSliderChoicesSelect').change( function(ev) {
				if(loaded()) {
					var l = map.getLayer( map.layerIds[3] );

					if( l != null ) {
						var valToShow = timeSelValue();
						var tLayerIds = timeLayerIds();
						
						console.debug(valToShow);
						
						for(var lll = 0; lll < tLayerIds.length; lll++) {
							if( viewModel.isVisibleLayer( map.layerIds[3], parseInt(tLayerIds[lll].id) ) ) {
									viewModel.toggleVisibleLayer( { "mapLayerId" : map.layerIds[3], "esriLayer" : { id: parseInt(tLayerIds[lll].id) } } )
								}
						}
						
						viewModel.toggleVisibleLayer( { "mapLayerId" : map.layerIds[3], "esriLayer" : { id: parseInt(valToShow) } } )
						l.refresh();
					}
				}
			});
		}
	}
}

/**
*/
function prepareMap() {
	require(["esri/geometry/Extent", "esri/map", "http://esri.github.io/bootstrap-map-js/src/js/bootstrapmap.js" ,"dojo/domReady!"],
	function(Extent, Map, BootstrapMap) {
		initialExtent = (new Extent(
			{"ymin": 30.561, "ymax": 32.422, "xmin": -82.319, "xmax": -79.973,
			"spatialReference": { "wkid" : 4326 }} )).expand(2);
			
		map = BootstrapMap.create("map",{
		  basemap:"oceans",
		  "extent": initialExtent
		});

		loaded(false);
		
		map.setMapCursor("pointer");
		
		dojo.connect(map, "onMouseMove", showMouseCoordinates);
		dojo.connect(map, "onMouseDrag", showMouseCoordinates);
		
		initBasemap = new esri.layers.ArcGISDynamicMapServiceLayer("http://services.arcgisonline.com/ArcGIS/rest/services/Ocean_Basemap/MapServer");
		
		geometryService = new esri.tasks.GeometryService("http://tulip.gis.gatech.edu:6080/arcgis/rest/services/Utilities/Geometry/GeometryServer");
		
        dojo.connect(geometryService, "onLengthsComplete", outputDistance);
		
		//MapSvcAllLayers.add(new MapSvcDef("BaseMap", "http://services.arcgisonline.com/ArcGIS/rest/services/Ocean_Basemap/MapServer", ServiceType_Tiled, map, null));
		MapSvcAllLayers.add(new MapSvcDef("DEM", DEM_URL, ServiceType_Dynamic, map, null));
		MapSvcAllLayers.add(new MapSvcDef("NauticalCharts", NOAA_NautChartURL, ServiceType_Image, map, null));
		MapSvcAllLayers.add(new MapSvcDef("Carto", TulipMapServiceURL, ServiceType_Dynamic, map, null));

		MapSvcAllLayers.initializeAllMapSerivceLayers(map, "Something Else happened", function () {	
			timeLayerIds.removeAll();
			hideDEMLayer();
			
			$("#button-close-intro").button("enabled");
			
			//map.graphics.on("graphics-add", function (){ isMapGraphicsEmpty(map.graphics.graphics.length); } );
			//map.graphics.on("graphics-clear", function (){ isMapGraphicsEmpty(map.graphics.graphics.length); } );
			
			$('#SplashCloseBtn').button('reset');
			
			navToolbar = new esri.toolbars.Navigation(map);
			drwToolbar = new esri.toolbars.Draw(map);
			
			dojo.connect(map, 'onExtentHistoryChange', extentHistoryChangeHandler);
			dojo.connect(map, 'onExtentChange', onMapExtentChange);
			getMapScaleToVariable();
			
			$('#zoomInBtn').on('click', function(e) {
				map.setMapCursor("url(images/zoom_in.cur),auto");
				navToolbar.activate(esri.toolbars.Navigation.ZOOM_IN);
			});

			$('#zoomPrevBtn').on('click', function(e) {
				navToolbar.zoomToPrevExtent();
			});
			
			$('#zoomFullExtBtn').on('click', function(e) {
				fullExtent();
			});
			
			addOpacityControl();
			
			$('#allLayersLink').on('click', function(e) {
				loaded(false);
				$('#timeSliderChoicesSelect').off('change');
				
				map.removeAllLayers();
				viewModel.currentVisibleLayers.removeAll();
				timeLayerIds.removeAll();
				
				MapSvcAllLayers = new CreateCollection("MapSvcList");
				
				MapSvcAllLayers.add(new MapSvcDef("BaseMap", defaultBasemapURL, ServiceType_Tiled, map, null));
				MapSvcAllLayers.add(new MapSvcDef("DEM", DEM_URL, ServiceType_Dynamic, map, null));
				MapSvcAllLayers.add(new MapSvcDef("NauticalCharts", NOAA_NautChartURL, ServiceType_Image, map, null));
				MapSvcAllLayers.add(new MapSvcDef("Carto", TulipMapServiceURL, ServiceType_Dynamic, map, null));
				MapSvcAllLayers.initializeAllMapSerivceLayers(map, "Something Else happened", function() {
					hideDEMLayer();
					currTab("All Layers");
					
					init_layer_controls(map);
					init_id_funct(map);
					
					addOpacityControl();
					loaded(true);
				});
			});
			
			$('#energyLink').on('click', function(e) {
				loaded(false);
				$('#timeSliderChoicesSelect').off('change');

				map.removeAllLayers();
				viewModel.currentVisibleLayers.removeAll();
				timeLayerIds.removeAll();				
				
				MapSvcAllLayers = new CreateCollection("MapSvcList");
				
				MapSvcAllLayers.add(new MapSvcDef("BaseMap", defaultBasemapURL, ServiceType_Tiled, map, null));
				MapSvcAllLayers.add(new MapSvcDef("DEM", DEM_URL, ServiceType_Dynamic, map, null));
				MapSvcAllLayers.add(new MapSvcDef("NauticalCharts", NOAA_NautChartURL, ServiceType_Image, map, null));
				MapSvcAllLayers.add(new MapSvcDef("Energy", EnergyMapServiceURL, ServiceType_Dynamic, map, null));	
				MapSvcAllLayers.initializeAllMapSerivceLayers(map, "Something Else happened", function() {
					hideDEMLayer();
					
					init_layer_controls(map);
					init_id_funct(map);
					currTab("Energy");
					
					addOpacityControl();
					loaded(true);
				});
			});
			
			$('#habitatLink').on('click', function(e) {
				loaded(false);
				$('#timeSliderChoicesSelect').off('change');

				map.removeAllLayers();
				timeLayerIds.removeAll();
				viewModel.currentVisibleLayers.removeAll();
				
				MapSvcAllLayers = new CreateCollection("MapSvcList");
						
				MapSvcAllLayers.add(new MapSvcDef("BaseMap", defaultBasemapURL, ServiceType_Tiled, map, null));
				MapSvcAllLayers.add(new MapSvcDef("DEM", DEM_URL, ServiceType_Dynamic, map, null));
				MapSvcAllLayers.add(new MapSvcDef("NauticalCharts", NOAA_NautChartURL, ServiceType_Image, map, null));
				MapSvcAllLayers.add(new MapSvcDef("Habitat", HabitatMapServiceURL, ServiceType_Dynamic, map, null));
				MapSvcAllLayers.initializeAllMapSerivceLayers(map, "Something Else happened", function() {
					hideDEMLayer();
					
					init_layer_controls(map);
					init_id_funct(map);
					currTab("Habitat");
					
					addOpacityControl();
					loaded(true);
				});
			});
			
			$('#fisheriesLink').on('click', function(e) {
				loaded(false);
				$('#timeSliderChoicesSelect').off('change');

				map.removeAllLayers();
				timeLayerIds.removeAll();
				viewModel.currentVisibleLayers.removeAll();
				
				MapSvcAllLayers = new CreateCollection("MapSvcList");
								
				MapSvcAllLayers.add(new MapSvcDef("BaseMap", "http://services.arcgisonline.com/ArcGIS/rest/services/Ocean_Basemap/MapServer", ServiceType_Tiled, map, null));
				MapSvcAllLayers.add(new MapSvcDef("DEM", DEM_URL, ServiceType_Dynamic, map, null));
				MapSvcAllLayers.add(new MapSvcDef("NauticalCharts", NOAA_NautChartURL, ServiceType_Image, map, null));
				MapSvcAllLayers.add(new MapSvcDef("Fisheries", FisheriesMapServiceURL, ServiceType_Dynamic, map, null));
				MapSvcAllLayers.initializeAllMapSerivceLayers(map, "Something Else happened", function() {
					hideDEMLayer();
				
					init_layer_controls(map);
					init_id_funct(map);
					
					timeLayerIds.removeAll();
					
					currTab("Fisheries");

					addOpacityControl();
					loaded(true);
				});
			});
			
			$("#hazardLink").on('click', function(e) {
				loaded(false);
				$('#timeSliderChoicesSelect').off('change');

				map.removeAllLayers();
				timeLayerIds.removeAll();
				viewModel.currentVisibleLayers.removeAll();
				
				MapSvcAllLayers = new CreateCollection("MapSvcList");
								
				MapSvcAllLayers.add(new MapSvcDef("BaseMap", "http://services.arcgisonline.com/ArcGIS/rest/services/Ocean_Basemap/MapServer", ServiceType_Tiled, map, null));
				MapSvcAllLayers.add(new MapSvcDef("DEM", DEM_URL, ServiceType_Dynamic, map, null));
//				MapSvcAllLayers.add(new MapSvcDef("NauticalCharts", NOAA_NautChartURL, ServiceType_Image, map, null));
				MapSvcAllLayers.add(new MapSvcDef("Hazards1", "http://gchp.skio.usg.edu/rest/services/Server/AIWW/MapServer", ServiceType_Dynamic, map, null));
				MapSvcAllLayers.add(new MapSvcDef("Hazards2", "http://gchp.skio.usg.edu/rest/services/Server/Hurricane_Tracks/MapServer", ServiceType_Dynamic, map, null));
				MapSvcAllLayers.initializeAllMapSerivceLayers(map, "Something Else happened", function() {
					hideDEMLayer();
				
					init_layer_controls(map);
					init_id_funct(map);
					
					timeLayerIds.removeAll();
					
					currTab("Hazards");

					addOpacityControl();
					loaded(true);
				});

			});

			$('#panBtn').on('click', function(e) {
				map.setMapCursor("pointer");
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

			var measurement = new esri.dijit.Measurement({
				map: map
			}, dojo.byId('measurementDiv'));

			measurement.startup();			
			measurement.hideTool('location');
			
			legend.startup();
			init_layer_controls(map);
			init_id_funct(map);
			
			loaded(true);
			
			$("#button-close-intro").button().removeAttr('disabled');
		});			
	});
}

/**
*/
function getMapScaleToVariable() {
	abs_map_scale( "1: " + (Math.round(map.getScale()/100)*100));
}

/**
*/
function onMapExtentChange(extent,delta,levelChange,lod) {
	getMapScaleToVariable();
}

/**
*/
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

/**
Initilizes the identify function with the map service URL and other parameters
*/
function init_id_funct(map) {
	identifyTask = new esri.tasks.IdentifyTask(
		CurrentMainMapServiceURL
		/*map.getLayer(map.layerIds[2]).url */
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
}

/**
*/
function return_to_LayerList() {
	$('#layerTabLink').tab('show');
}

/**
*/
function fullExtent() {
	map.setExtent(initialExtent);
}

/**
*/
function extentHistoryChangeHandler() {
	//dijit.byId("zoomprev").disabled = navToolbar.isFirstExtent();
	//dijit.byId("zoomnext").disabled = navToolbar.isLastExtent();
}

/**
*/
function sliderChanged(value) {
	var num = Math.floor(value/100 * extents.length);
	
	if(value == 100) num = extents.length - 1;
	
	//console.debug(num);
	
	cvtLatLongExtent_2_WebMercator( extents[num], function(res) {
		initialExtent = res[0];
		fullExtent();
	});
}

/**
*/
$(document).ready(function() {
	esriConfig.defaults.io.proxyUrl = "http://carto.gis.gatech.edu/proxypage_net/proxy.ashx";
	esriConfig.defaults.io.alwaysUseProxy = 
	(window.location.toString().lastIndexOf("carto") > -1) ? true: true;
	
	esri.config.defaults.io.corsEnabledServers.push("http://carto.gis.gatech.edu");
	esri.config.defaults.io.corsEnabledServers.push("http://www.csc.noaa.gov");
	esri.config.defaults.io.corsEnabledServers.push("http://ocs-gis.ncd.noaa.gov");
	esri.config.defaults.io.corsEnabledServers.push("http://services.arcgisonline.com");
	esri.config.defaults.io.corsEnabledServers.push("http://tasks.arcgisonline.com");
	esri.config.defaults.io.corsEnabledServers.push("http://egisws02.nos.noaa.gov");
	esri.config.defaults.io.corsEnabledServers.push("http://gchp.skio.usg.edu");

	prepareMap();
	
	/*jpanes = $('.scroll-pane').jScrollPane({
		showArrows : true,
		verticalArrowPositions: 'split',
		horizontalArrowPositions: 'split',
		maintainPosition : false,
		verticalDragMinHeight: 20,
		verticalDragMaxHeight: 20,
		horizontalDragMinWidth: 20,
		horizontalDragMaxWidth: 20,
		scrollbarWidth: 250,
		scrollbarHeight: 250,
		autoReinitialise : true
	});*/
		
	$('a[data-toggle="tab"]').on('click', function (e) {
		console.debug( $(e.target).attr('href') );
		
		if( $(e.target).attr('href') == "#identifyPane") {
			
			map.setMapCursor("url(images/id_cursor.cur),auto");
			handleIdentify = map.on("click", doIdentify);
			//handleIdentify = dojo.connect(map, "onClick", doIdentify);
		}
		else {
			map.setMapCursor("default");
			
			if(handleIdentify != null) {
				//dojo.disconnect(handleIdentify);
				//jquery.off("click", handleIdentify);
				handleIdentify.remove();
				handleIdentify = null;
			}
		}
	});
	/*
			if( $(e.target).attr('href') == "#identifyPaneSumm" ) {
				resetSummaryPane();
				drwToolbar.activate(esri.toolbars.Draw.POLYGON);

				dojo.connect(drwToolbar, "onDrawEnd", function(geometry) {
						map.graphics.clear();
					  
						var graphic = map.graphics.add(new esri.Graphic(geometry, new esri.symbol.SimpleLineSymbol()));
						lastGraphic = graphic;
						//doMeasure([graphic]);

						var geometryService = new esri.tasks.GeometryService("http://tulip.gis.gatech.edu:6080/arcgis/rest/services/Utilities/Geometry/GeometryServer");
						var PrjParams = new esri.tasks.ProjectParameters();
						PrjParams.geometries = [geometry];
						PrjParams.outSR = new esri.SpatialReference(32618);
						
						//console.debug(geometry);
					
						geometryService.project(PrjParams, doSummaryQuery );
						//doSummaryQuery( [geometry] );
						//console.debug(geometry);
						
						//doSummaryQuery([geometry]);
				});
			}
			else {
				drwToolbar.deactivate();
			}
			
			//alert($(e.target).attr('href')) //e.target // activated tab
			//e.relatedTarget // previous tab
			//$('.scroll-pane').jScrollPane();
		});
		*/
		
		$('#intro').dialog({
			modal: true,
			buttons: [{
				text: "I Understand",
				id: "button-close-intro",
				disabled: true,
				click:
					function () { 
						$(this).dialog("close");
				}
				}],
			close: function() {
				map.resize();
			},
			title: "Georgia Coastal and Marine Planner",
			resizable: false,
			draggable: false,
			closeOnEscape: false
		});
		
		$('#SplashCloseBtn').button('loading');
			
		$('#meas').on('click', function(e) {
			$('#measurePopoutPanel').dialog({width:250, title:"Measurement"});
		});
		
	ko.applyBindings();
});

/**
*/
function resetSummaryPane() {
	if( multipleSelectSummary == null) {
		multipleSelectSummary = $('#summarySelectList').multipleSelect().data();
	}
	
	multipleSelectSummary.multipleSelect.refresh();
}

/**
*/
function doClearMapGraphics() {
	map.graphics.clear();
}

/**
*/
function doLoadLegendElements(mapSvc) {
}

/**
*/
function doToggleSidebar() {
	isSidebarVisible(!isSidebarVisible());
	map.resize();
}

/**
*/
function doShowPrintDlg() {
	$("#printing-popover").show();
}