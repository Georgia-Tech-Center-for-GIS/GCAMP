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

//var gpServiceUrl = "http://sampleserver6.arcgisonline.com/arcgis/rest/services/911CallsHotspot/GPServer/911%20Calls%20Hotspot";
//var mapserviceurl = "http://sampleserver6.arcgisonline.com/arcgis/rest/services/911CallsHotspot/MapServer/jobs";
var map, legend;

var mapBase = "http://carto.gis.gatech.edu/arcgis/rest/services/";
var mapMarine = "http://www.csc.noaa.gov/ArcGISPUB/rest/services/MultipurposeMarineCadastre/MultipurposeMarineCadastre/MapServer/";

var cartoLayers = ["NauticalChart522", "Habitat522", "Wetlands530", "CoastalResources61", "Physical522", "Counties531", "Administrative530"];
var marineLayers = ["2", "3", "4", "5"];
var selectedNewMapSvc = ko.observable();

var loaded = ko.observable();

var timeSelValue = ko.observable();
var timeSliderVisible = ko.observable(false);

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

var NOAA_NautChartURL = "http://egisws02.nos.noaa.gov/ArcGIS/rest/services/RNC/NOAA_RNC/MapServer";

var extents = [];
	
var initialExtent;

var isSidebarVisible = ko.observable(true);
var currTab = ko.observable("All Layers");
var map_width = ko.observable("100%");

var identifyTask, identifyParams, symbol;
var geometryService = null;

var navToolbar;
var drwToolbar;
var initBasemap;
var ly_Energy;
var ly_Habitat;
var ly_DEM;

var printer;
var timeSlider;

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

function doMeasure(graphics) {
	if(graphics[0].geometry.type != "POLYGON") {
		var geometryService = new esri.tasks.GeometryService("http://tasks.arcgisonline.com/ArcGIS/rest/services/Geometry/GeometryServer");
		var lp = new esri.tasks.LengthsParameters();
		lp.polylines = graphics;
		lp.lengthUnit = esri.tasks.GeometryService.UNIT_FOOT;
		
		geometryService.lengths(lp, outputDistance);
	}
	else {
		var geometryService = new esri.tasks.GeometryService("http://tasks.arcgisonline.com/ArcGIS/rest/services/Geometry/GeometryServer");
		var ap = new esri.tasks.AreasAndLengthsParameters();
		ap.polygons = graphics;
		ap.areaUnit = esri.tasks.GeometryService.UNIT_ACRE;
		ap.lengthUnit = esri.tasks.GeometryService.UNIT_FOOT;
		
		geometryService.areasAndLengths(ap, outputDistance);
	}
}

function hideDEMLayer() {
	map.getLayer( map.layerIds[1] ).visibleLayers = [];
	map.getLayer( map.layerIds[1] ).setVisibility(false);
}

function outputDistance(result) {
	console.debug(result);
}

var isMapGraphicsEmpty = ko.observable(true);
var timeLayerIds = ko.observableArray([]);

require(["esri/map", "http://esri.github.io/bootstrap-map-js/src/js/bootstrapmap.js" ,"dojo/domReady!"],
function(Map, BootstrapMap) {
	map = BootstrapMap.create("map",{
	  basemap:"oceans",
	});
});

var opacityControl = null;

function addOpacityControl() {
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

function prepare_map_when_extents_finished(a) {
		initialExtent = a[0];
		
		map.setExtent(initialExtent);
		
		/*map = new esri.Map("map", {
				extent : initialExtent
		});
		
		dojo.connect(dijit.byId('map'), "onLoad", function() {
		});*/
		
		map.setMapCursor("pointer");

		/*
		printer = new esri.dijit.Print({
			map: map,
			url: //"http://servicesbeta4.esri.com/arcgis/rest/services/Utilities/ExportWebMap/GPServer/Export Web Map Task"
			"http://tulip.gis.gatech.edu:6080/arcgis/rest/services/Utilities/PrintingTools/GPServer/Export%20Web%20Map%20Task",
			templates: [{
					label: "Map",
					format: "PDF",
					layout: "MAP_ONLY",
					exportOptions: {
						width: 500,
						height: 400,
						dpi: 96
					}
				}, {
					label: "Letter Portrait",
					format: "PDF",
					layout: "Letter ANSI A Portrait",
					layoutOptions: {
						titleText: "Georgia Coastal Atlas",
						authorText: "Coastal Resources Divsion",
						copyrightText: "Georgia Department of Natural Resources",
						scalebarUnit: "Miles",
					}
				}, {
					label: "11x17 Portrait",
					format: "PDF",
					layout: "Tabloid ANSI B Portrait",
					layoutOptions: {
						titleText: "Georgia Coastal Atlas",
						authorText: "Coastal Resources Divsion",
						copyrightText: "Georgia Department of Natural Resources",
						scalebarUnit: "Miles",
					}
				}]
		}, dojo.byId("printButton"));
		
		printer.startup();
		*/
		
		dojo.connect(map, "onMouseMove", showMouseCoordinates);
		dojo.connect(map, "onMouseDrag", showMouseCoordinates);
		
		initBasemap = new esri.layers.ArcGISDynamicMapServiceLayer("http://services.arcgisonline.com/ArcGIS/rest/services/Ocean_Basemap/MapServer");
		
		geometryService = new esri.tasks.GeometryService("http://tasks.arcgisonline.com/ArcGIS/rest/services/Geometry/GeometryServer");
		
        dojo.connect(geometryService, "onLengthsComplete", outputDistance);
        //dojo.connect(geometryService, "onProjectComplete", function(graphics) {
          //call GeometryService.lengths() with projected geometry
//		  geometryService.lengths(graphics);
        //});
		
		//MapSvcAllLayers.add(new MapSvcDef("BaseMap", "http://services.arcgisonline.com/ArcGIS/rest/services/Ocean_Basemap/MapServer", ServiceType_Tiled, map, null));
		MapSvcAllLayers.add(new MapSvcDef("DEM", "http://tulip.gis.gatech.edu:6080/arcgis/rest/services/GACoast/LidarCZM/MapServer", ServiceType_Dynamic, map, null));
		MapSvcAllLayers.add(new MapSvcDef("NauticalCharts", NOAA_NautChartURL, ServiceType_Dynamic, map, null));
		MapSvcAllLayers.add(new MapSvcDef("Carto", "http://tulip.gis.gatech.edu:6080/arcgis/rest/services/GACoast/GCAMP314/MapServer", ServiceType_Dynamic, map, null));

		//MapSvcAllLayers.add(new MapSvcDef("Test", "http://tulip.gis.gatech.edu:6080/arcgis/rest/services/GACoast/MyMapService/MapServer", ServiceType_Dynamic, map, null));

		MapSvcAllLayers.initializeAllMapSerivceLayers(map, "Something Else happened", function () {
			loaded(true);
			
			$("#button-close-intro").button("enabled");
			
			map.graphics.onGraphicAdd = map.graphics.onGraphicsClear = function () {
				isMapGraphicsEmpty(map.graphics.graphics.length);
			};
			
			$('#SplashCloseBtn').button('reset');
			
			hideDEMLayer();

			ko.applyBindings();
			
			navToolbar = new esri.toolbars.Navigation(map);
			drwToolbar = new esri.toolbars.Draw(map);
			
			dojo.connect(map, 'onExtentHistoryChange', extentHistoryChangeHandler);
			dojo.connect(map, 'onExtentChange', onMapExtentChange);
			getMapScaleToVariable();
			//dojo.connect('onDrawEnd', measureEnd);
			
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
				map.removeAllLayers();
				viewModel.currentVisibleLayers.removeAll();
				
				MapSvcAllLayers = new CreateCollection("MapSvcList");
				
				MapSvcAllLayers.add(new MapSvcDef("BaseMap", "http://services.arcgisonline.com/ArcGIS/rest/services/Ocean_Basemap/MapServer", ServiceType_Tiled, map, null));
				MapSvcAllLayers.add(new MapSvcDef("DEM", "http://tulip.gis.gatech.edu:6080/arcgis/rest/services/GACoast/LidarCZM/MapServer", ServiceType_Dynamic, map, null));
				//MapSvcAllLayers.add(new MapSvcDef("NauticalCharts", NOAA_NautChartURL, ServiceType_Tiled, map, null));
				MapSvcAllLayers.add(new MapSvcDef("Carto", "http://tulip.gis.gatech.edu:6080/arcgis/rest/services/GACoast/GCAMP1213/MapServer", ServiceType_Dynamic, map, null));				
				MapSvcAllLayers.initializeAllMapSerivceLayers(map, "Something Else happened", function() {
					map.getLayer( map.layerIds[1] ).visibleLayers = [];
					map.getLayer( map.layerIds[1] ).setVisibility(false);

					init_layer_controls(map);
					init_id_funct(map);
					currTab("All Layers");
				});
				
				//$('#timeSliderContainer').hide();
				timeSliderVisible ( false );
			});
			
			$('#energyLink').on('click', function(e) {
				map.removeAllLayers();
				viewModel.currentVisibleLayers.removeAll();
				
				MapSvcAllLayers = new CreateCollection("MapSvcList");
				
				MapSvcAllLayers.add(new MapSvcDef("BaseMap", "http://services.arcgisonline.com/ArcGIS/rest/services/Ocean_Basemap/MapServer", ServiceType_Tiled, map, null));
				MapSvcAllLayers.add(new MapSvcDef("DEM", "http://tulip.gis.gatech.edu:6080/arcgis/rest/services/GACoast/LidarCZM/MapServer", ServiceType_Dynamic, map, null));
				//MapSvcAllLayers.add(new MapSvcDef("NauticalCharts", NOAA_NautChartURL, ServiceType_Tiled, map, null));
				MapSvcAllLayers.add(new MapSvcDef("Energy", "http://tulip.gis.gatech.edu:6080/arcgis/rest/services/GACoast/Energy/MapServer", ServiceType_Dynamic, map, null));				
				MapSvcAllLayers.initializeAllMapSerivceLayers(map, "Something Else happened", function() {
					map.getLayer( map.layerIds[1] ).visibleLayers = [];
					map.getLayer( map.layerIds[1] ).setVisibility(false);

					init_layer_controls(map);
					init_id_funct(map);
					currTab("Energy");
				});
				
				//$('#timeSliderContainer').hide();
				timeSliderVisible ( false );
			});
			
			$('#habitatLink').on('click', function(e) {
				map.removeAllLayers();
				viewModel.currentVisibleLayers.removeAll();
				
				MapSvcAllLayers = new CreateCollection("MapSvcList");
						
				MapSvcAllLayers.add(new MapSvcDef("BaseMap", "http://services.arcgisonline.com/ArcGIS/rest/services/Ocean_Basemap/MapServer", ServiceType_Tiled, map, null));
				MapSvcAllLayers.add(new MapSvcDef("DEM", "http://tulip.gis.gatech.edu:6080/arcgis/rest/services/GACoast/LidarCZM/MapServer", ServiceType_Dynamic, map, null));
				//MapSvcAllLayers.add(new MapSvcDef("NauticalCharts", NOAA_NautChartURL, ServiceType_Tiled, map, null));
				MapSvcAllLayers.add(new MapSvcDef("Habitat", "http://tulip.gis.gatech.edu:6080/arcgis/rest/services/GACoast/habitat/MapServer", ServiceType_Dynamic, map, null));				
				MapSvcAllLayers.initializeAllMapSerivceLayers(map, "Something Else happened", function() {
					map.getLayer( map.layerIds[1] ).visibleLayers = [];
					map.getLayer( map.layerIds[1] ).setVisibility(false);

					init_layer_controls(map);
					init_id_funct(map);
					currTab("Habitat");
				});	
				
				//$('#timeSliderContainer').hide();
				timeSliderVisible ( false )
			});
			
			$('#fisheriesLink').on('click', function(e) {
				map.removeAllLayers();
				viewModel.currentVisibleLayers.removeAll();
				
				MapSvcAllLayers = new CreateCollection("MapSvcList");
								
				MapSvcAllLayers.add(new MapSvcDef("BaseMap", "http://services.arcgisonline.com/ArcGIS/rest/services/Ocean_Basemap/MapServer", ServiceType_Tiled, map, null));
				MapSvcAllLayers.add(new MapSvcDef("DEM", "http://tulip.gis.gatech.edu:6080/arcgis/rest/services/GACoast/LidarCZM/MapServer", ServiceType_Dynamic, map, null));
				//MapSvcAllLayers.add(new MapSvcDef("NauticalCharts", NOAA_NautChartURL, ServiceType_Tiled, map, null));
				MapSvcAllLayers.add(new MapSvcDef("Fisheries", "http://tulip.gis.gatech.edu:6080/arcgis/rest/services/GACoast/Fisheries/MapServer", ServiceType_Dynamic, map, null));				
				MapSvcAllLayers.initializeAllMapSerivceLayers(map, "Something Else happened", function() {
					map.getLayer( map.layerIds[1] ).visibleLayers = [];
					map.getLayer( map.layerIds[1] ).setVisibility(false);

					init_layer_controls(map);
					init_id_funct(map);
					
					timeLayerIds.removeAll();
					
					currTab("Fisheries");
					
					require(["dojo/_base/xhr"],
						function(xhr) {
							xhr.get({
								url: "TimeLayers.xml",
								handleAs : "json",
								load: function(result) {							
									var l = map.getLayer( map.layerIds[2] );
									console.debug(l);
									
									rr = result;
									
									for(var jjj = 0; jjj < result.length; jjj++ ){
										timeLayerIds.push ( { "id" : result[jjj].id, "label" : l.layerInfos[ result[jjj].id ].name } );
									}
									
									$('#timeSliderChoicesSelect').change( function() {
										//$('#timeSliderChoicesSelect option:selected').each( function() {
											var valToShow = timeSelValue();
											var tLayerIds = timeLayerIds();
											
											console.debug(valToShow);
											
											for(var lll = 0; lll < tLayerIds.length; lll++) {
												if( viewModel.isVisibleLayer( map.layerIds[2], parseInt(tLayerIds[lll].id) ) ) {
														viewModel.toggleVisibleLayer( { "mapLayerId" : map.layerIds[2], "esriLayer" : { id: parseInt(tLayerIds[lll].id) } } )
													}
											}
											
											viewModel.toggleVisibleLayer( { "mapLayerId" : map.layerIds[2], "esriLayer" : { id: parseInt(valToShow) } } )
											l.refresh();
											
										//});
									});
								}
							}
						)}
					);
					
					if(false) {
					var l = map.getLayer( map.layerIds[2] );
					for(var jjj = 0; jjj < l.layerInfos.length; jjj++) {
						
						if(l.layerInfos[jjj].subLayerIds != null) continue;

						var fl = new esri.layers.ArcGISDynamicMapServiceLayer(l.url + "/" + jjj );//"http://tulip.gis.gatech.edu:6080/arcgis/rest/services/GACoast/Fisheries/MapServer/11" );
						//console.debug(fl);
						
						//if(fl.timeInfo != null) {
							timeLayerIds.push({"id": jjj, "label": fl["name"]});
						//}
					}
					}
					
					var timeExtent = new esri.TimeExtent();
					timeExtent.startTime = new Date("1/1/2011 EST");
					map.setTimeExtent(timeExtent);

					if(timeSlider == null) {
						timeSlider = new esri.dijit.TimeSlider({
						  style: "width: 800px;"
						}, dojo.byId("timeSliderDiv"));
					}
					
					map.setTimeSlider(timeSlider);
					timeSlider.setThumbCount(2);
					
					var layerTimeExtent = map.getLayer( map.layerIds[2] ).timeInfo.timeExtent;
					layerTimeExtent.startTime = timeExtent.startTime;
					timeSlider.createTimeStopsByTimeInterval(layerTimeExtent, 1, 'esriTimeUnitsMonths');
					timeSlider.setThumbMovingRate(1500);			
					timeSlider.setLoop(true);
					timeSlider.setLabels(["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]);
					timeSlider.startup();

					// $('#timeSliderContainer').css('display', 'inline');
					// $('#timeSliderChoices').css('display', 'inline');
					timeSliderVisible( true );
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
			
//			addLayerToMap(NOAA_NautChartURL, "NOAA Nautical Charts");
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

var rr = null;

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

var abs_map_scale = ko.observable("0");

var lastMapEv = null;

function getMapScaleToVariable() {
	abs_map_scale( "1: " + (Math.round(map.getScale()/100)*100));
}

function onMapExtentChange(extent,delta,levelChange,lod) {
	getMapScaleToVariable();
}

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
var handleIdentifySummary = null;

var tabs;
var jpanes = null;

var lastGraphic = null;
var multipleSelectSummary = null;

function jQueryReady() {
	$(function() {
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
		
		tabs = $('a[data-toggle="tab"]').on('shown', function (e) {
			if( $(e.target).attr('href') == "#identifyPane") {
				map.setMapCursor("url(images/id_cursor.cur),auto");
				handleIdentify = dojo.connect(map, "onClick", doIdentify);
				
			}
			else {
				map.setMapCursor("default");
				if(handleIdentify != null) {
					dojo.disconnect(handleIdentify);
					handleIdentify = null;
				}
			}
			
			if( $(e.target).attr('href') == "#identifyPaneSumm" ) {
				resetSummaryPane();
				drwToolbar.activate(esri.toolbars.Draw.POLYGON);

				dojo.connect(drwToolbar, "onDrawEnd", function(geometry) {
						map.graphics.clear();
					  
						var graphic = map.graphics.add(new esri.Graphic(geometry, new esri.symbol.SimpleLineSymbol()));
						lastGraphic = graphic;
						//doMeasure([graphic]);

						var geometryService = new esri.tasks.GeometryService("http://tasks.arcgisonline.com/ArcGIS/rest/services/Geometry/GeometryServer");
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
		})
	
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
	});
}

function resetSummaryPane() {
	if( multipleSelectSummary == null) {
		multipleSelectSummary = $('#summarySelectList').multipleSelect().data();
	}
	
	multipleSelectSummary.multipleSelect.refresh();
}

function doClearMapGraphics() {
	map.graphics.clear();
}

function doLoadLegendElements(mapSvc) {
}

function doToggleSidebar() {
	isSidebarVisible(!isSidebarVisible());
	map.resize();
}

function doShowPrintDlg() {
	$("#printing-popover").show();
}

$(document).ready(jQueryReady);
dojo.addOnLoad(init);