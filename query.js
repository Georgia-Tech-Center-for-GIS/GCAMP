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
dojo.require("esri.tasks.imageserviceidentify");
dojo.require("esri.tasks.query");

dojo.require("esri.layers.wms");

dojo.require("dojox.xmpp.util");
dojo.require("esri.dijit.BasemapGallery");

dojo.require("dojo/promise/all");

var ptIDTolerance = ko.observable(15);
var lastIdResults = ko.observableArray();

var decPrecision = 2;

function doTrimNumber(num) {
	try {
		return num.toFixed(decPrecision);
	}
	catch(e) {
		return num;
	}
}

var gp = null;
var params = null;

var idInProgress = ko.observable(false);
var noIdResults = ko.observable(true);

function doIdentify(evt) {
	//map.graphics.clear();
	lastIdResults.removeAll();
	idViewModel.idOpenLayers = ko.observableArray();
	
	var centerPoint = new esri.geometry.Point(evt.mapPoint.x,evt.mapPoint.y,evt.mapPoint.spatialReference);
    var mapWidth = map.extent.getWidth();
	var pixelWidth = mapWidth / map.width;
	var tolerance = ptIDTolerance() * pixelWidth;
	var queryExtent = new esri.geometry.Extent (1,1,tolerance,tolerance,evt.mapPoint.spatialReference);
	
    identifyParams.geometry = queryExtent.centerAt(centerPoint);
	identifyParams.mapExtent = map.extent;
	identifyParams.layerIds = /*[0]; / */ viewModel.currentVisibleLayers.peek()[3].vlayers;
	
	identifyParams.layerIds = identifyParams.layerIds.sort();
	
	idInProgress(true);
	
	identifyTask.execute(identifyParams,
		function (idResults) {
			idInProgress(false);
			
			if (idResults != null && idResults.length > 0) {
				noIdResults(false);

				addToMap(idResults, evt);
			}
			else {
				noIdResults(true);
			}
		},
		function (err) {
			idInProgress(false);
			console.debug(err);
		});
}

//lastIdResults.subscribe( function() { console.debug("CHANGED"); } );

var idViewModel = {
	idOpenLayers : ko.observableArray(),
	
	isOpenTheme : function(themeName) {	
		if( idViewModel.idOpenLayers.indexOf(themeName) !== -1) {
			return true;
		}
		return false;
	},
	
	setOpenTheme : function (a) {
		var themeName = a[0].layerName;
		
		if( idViewModel.isOpenTheme(themeName) ) {
			idViewModel.idOpenLayers.remove(themeName);
		}
		else {
			idViewModel.idOpenLayers.push(themeName);
		}
		
		//$('.scroll-pane').jScrollPane({verticalGutter: 0});
	},
	
	zoomToFeature : function (a) {
		map.graphics.clear();
		
		var fgeom = null;
		
		if(a.feature.geometry.getExtent() == null) {
			symbol = new esri.symbol.PictureMarkerSymbol('images/Identify-Results.png',  48, 48);
			
			var centerPoint = new esri.geometry.Point(a.feature.geometry.x,a.feature.geometry.y,a.feature.geometry.spatialReference);
			var mapWidth = map.extent.getWidth();
			var pixelWidth = mapWidth/map.width;
			var tolerance = 15000;
			var queryExtent = new esri.geometry.Extent (1,1,tolerance,tolerance,a.feature.geometry.spatialReference);
	
			fgeom = queryExtent.centerAt(centerPoint);
		}
		else {
			symbol = new esri.symbol.SimpleFillSymbol(
				esri.symbol.SimpleFillSymbol.STYLE_SOLID,
				new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255, 255, 0]), 3),
				new dojo.Color([255, 255, 0, 0.25]));

			fgeom = a.feature.geometry.getExtent().expand(1.5);
		}

		a.feature.setSymbol(symbol);		
		map.setExtent(fgeom);
		map.graphics.add(a.feature);
	}
}

function getResultsFields(ftre) {
	var arrayResult = ko.observableArray();
	
	console.debug(ftre);
	
	var attribs = ftre.feature.attributes;
	
	console.debug(ftre.feature);
	
	if(attribs != null) {
		var i = 0;
		
		console.debug(attribs);
		
		for (var k in attribs) {
			if(k == "FID" || k == "Shape" || k == "SHAPE") continue;
			
			arrayResult.push( {"Name" : k , "Value" : attribs[k] } );
		}
	}
	
	return arrayResult;
}

//var newResults =  null; //ko.observableArray();

function addToMap3(idResults, evt) {
	var geometryService = new esri.tasks.GeometryService("http://tasks.arcgisonline.com/ArcGIS/rest/services/Geometry/GeometryServer");
	for (var i = 0; i < idResults.length; i++) {
		console.debug(idResults[i]);
	}
}

function addToMap(idResults, evt) {
	//var tempIdResults = idResults;
	var factoredResults = [];
	var newResults = ko.observableArray();
	idViewModel.idOpenLayers.removeAll();
		
	if(idResults.length == 0) {
		return;
	}
	
	for (var i = 0; i < idResults.length; i++) {
		var layerName = idResults[i].layerName;
		
		try {
		if( layerName == "") {
			var ly1 = map.getLayer( map.layerIds[3] );
			layerName = ly1.layerInfos[ idResults[i].layerId ].name + " (Raster)";
			idResults[i].layerName = layerName;
		}
		
		if( idResults[i].displayFieldName == "" ) {
			idResults[i].displayFieldName = "Pixel Value";		
			idResults[i]["value"] = idResults[i].feature.attributes["Pixel Value"];
		}
		
		console.debug(idResults[i].feature);
		
		if(factoredResults[ layerName ] == null) {
			factoredResults[ layerName ] = [];
			idViewModel.idOpenLayers.push( layerName );
		}
		
		factoredResults[ layerName ] = factoredResults[ layerName ].filter( function (f) {		
				if( f.feature.attributes.FID ==
						idResults[i].feature.attributes.FID) return false;
				return true;
			});
		
		factoredResults[ layerName ].push(idResults[i]);
		}
		catch(e) {
			console.debug(e.stack);
		}
		
		console.debug(factoredResults);
	}
	
	counter = 0;
	
	for (var j in factoredResults) {
		console.debug(j);
		lastIdResults.push( factoredResults[j] );
	}
	
	//$('#resultsContainer').jScrollPane({verticalGutter: 0});
}

function aaah(e){
	console.debug(e);
}

var rasterLayerLocations = [
	{ layerName : "DEM",								rasterLoc : "\"D:\\GISData\\CoastalGa\\Coastal_DEM_Mosaic\\coastdemwebm\"" },
	{ layerName : "NWI Plus Wetlands 2011" ,			rasterLoc : "\"D:\\GISData\\CoastalGa\\WM84\\DNR\\wetcoast\"" },
	{ layerName : "Habitat AVG G Rank (Coastal Extent)",rasterLoc : "\"D:\\GISData\\CoastalGa\\WM84\\DNR\\HabGRAvg\"" },
	{ layerName : "Bathymetry Estuarine",				rasterLoc : "\"D:\\GISData\\CoastalGa\\WM84\\DNR\\\\bathdetes\"" },
	{ layerName : "Bathymetry Marine",					rasterLoc : "\"D:\\GISData\\CoastalGa\\WM84\\DNR\\\\bathdetmar\"" },
	{ layerName : "Ocean Current - Mean Speed",			rasterLoc : "\"D:\\GISData\\CoastalGa\\WM84\\Energy\\OffSyrmeanWM\"" },
	{ layerName : "Ocean Current - Mean Power",			rasterLoc : "\"D:\\GISData\\CoastalGa\\WM84\\Energy\\OffPowerWM\"" },
	{ layerName : "Tidal Stream - Mean Power",			rasterLoc : "\"D:\\GISData\\CoastalGa\\WM84\\Energy\\meanpowerWM\"" },
	{ layerName : "Tidal Stream - Mean Speed",			rasterLoc : "\"D:\\GISData\\CoastalGa\\WM84\\Energy\\meancurrentWM\"" },
	{ layerName : "Tidal Stream - Max Power",			rasterLoc : "\"D:\\GISData\\CoastalGa\\WM84\\Energy\\maxpowerWM\"" },
	{ layerName : "Tidal Stream - Max Speed",			rasterLoc : "\"D:\\GISData\\CoastalGa\\WM84\\Energy\\maxcurrentWM\"" },
	{ layerName : "Offshore Wind Speed 90m",			rasterLoc : "\"D:\\GISData\\CoastalGa\\WM84\\Energy\\gaoffspd90WM\"" },
	{ layerName : "Offshore Wind Power 90m",			rasterLoc : "\"D:\\GISData\\CoastalGa\\WM84\\Energy\\gaoffpwr90WM\"" }
];
	
var selectedLayersSummary = ko.observableArray();
var availableLayersSummary= ko.observableArray();

var lastStatsFieldsSummaryAll = ko.observableArray();
var lastStatsFieldsSummaryAllRaster = ko.observableArray();

var summQry = null;
var labelsUrls = [];

var lastGeom = null;
var qobjs = [];

var lnames = [];
var lnames_checklist = [];

var promises;

var useDEMSummary = true;

function doActivateVisibleLayers() {
	//selectedLayersSummary.removeAll();
	
	var mapLayer = map.getLayer( map.layerIds[3] );
	var vLayers = mapLayer.visibleLayers;
	
	var newSelectedLayers = [];
	
	for(i = 0; i < vLayers.length; i++) {
		var index = vLayers[i];
		
		if(mapLayer.layerInfos[index].subLayerIds == null) {
			var layerUrl = mapLayer.url + "/" + index.toString();
			
			newSelectedLayers.push( mapLayer.layerInfos[index].name + "|" +layerUrl );
			//selectedLayersSummary.push( {label: mapLayer.layerInfos[index].name, url: layerUrl} );
		}
	}

	multipleSelectSummary.multipleSelect.setSelects(newSelectedLayers);
	console.debug(newSelectedLayers);
}

var rastersToQuery = ko.observable(0);
var vectorsToQuery = ko.observable(0);

function doSummaryQuery(geom) {
	var layersToQuery = []; //selectedLayersSummary();
	
	var selectsFromList = multipleSelectSummary.multipleSelect.getSelects();
	
	if(selectsFromList.length == 0) return;
	
	for( jkl = 0; jkl < selectsFromList.length; jkl ++) {
		var splits = selectsFromList[jkl].split("|");
		layersToQuery.push( { label: splits[0], url: splits[1] } );
	}

	lastStatsFieldsSummaryAllRaster([]);
	lastStatsFieldsSummaryAll([]);
	
	qobjs = [];	
	
	//if(geom[0].type != "POLYGON") return;
	
	lastGeom = geom;
	results_done_processed = false;
	
	//map.graphics.clear();
	
	var symbol = new esri.symbol.SimpleFillSymbol(
		esri.symbol.SimpleFillSymbol.STYLE_SOLID,
		new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255, 255, 0]), 3),
		new dojo.Color([255, 255, 0, 0.25]));

	//map.setExtent(geom);
	map.graphics.add(new esri.Graphic(geom, symbol));

	try {
		labelsUrls = [];

		if(summQry == null) {
			summQry = new esri.tasks.Query();
		}
		
		summQry.where = "1=1";
		summQry.returnGeometry = true;
		summQry.spatialRelationship = esri.tasks.Query.SPATIAL_REL_INTERSECTS;
		summQry.geometry = geom[0];
		summQry.outSpatialReference = map.spatialReference;
		summQry.outFields= ["*"];
		
		if(useDEMSummary) {
			rastersToQuery( rastersToQuery() + 1);
			queryRaster(geom, rasterLayerLocations[0].layerName, rasterLayerLocations[0].rasterLoc);
		}
		
		for(var layerIndex = 0; layerIndex < layersToQuery.length; layerIndex++) {
			
			var isRaster = false;
			
			/* DEM location is in index 0 */
			for(var ii = 1; ii < rasterLayerLocations.length; ii++) {			
				if(layersToQuery[layerIndex].label.trim() == rasterLayerLocations[ii].layerName.trim()) {
					isRaster = true;
					
					rastersToQuery( rastersToQuery() + 1);
					queryRaster(geom,layersToQuery[layerIndex].label, rasterLayerLocations[ii].rasterLoc);
				}
			}
			
			if(isRaster) continue;
			
			var currUrl = layersToQuery[layerIndex].url;
			labelsUrls[currUrl] = layersToQuery[layerIndex].label;
			lnames.push (layersToQuery[layerIndex].label);
			console.debug(currUrl);
			
			vectorsToQuery( vectorsToQuery() + 1);
			
			var qt = new esri.tasks.QueryTask( currUrl );
			qobjs.push(qt.execute(summQry, function(a) {
				vectorsToQuery( vectorsToQuery() - 1);
			}, function(e) {
				alert("An error occurred querying "  + layersToQuery[layerIndex].label );
				vectorsToQuery( vectorsToQuery() - 1);
			})); /* , processSummaryResults)); */
		}

		require(["dojo/promise/all"], function(all){
			lnames_checklist = lnames.slice(0);
			all(qobjs).then(processSummaryResults);
		  });		  
	}
	catch(e) {
		console.debug(e);
	}
	
	inProcess = false;
}


function queryRaster(geom,label,location) {
	var tempArray = new Array();
	
	//submit to bathymetry testing
	/** */
	try {
		var gp_bathy = new esri.tasks.Geoprocessor("http://tulip.gis.gatech.edu:6080/arcgis/rest/services/GACoast/SummImagery/GPServer/SummImagery");

//        map.graphics.clear();
        
        var symbol = new esri.symbol.SimpleFillSymbol("none", new esri.symbol.SimpleLineSymbol("dashdot", new dojo.Color([255,0,0]), 2), new dojo.Color([255,255,0,0.25]));
        var graphic = new esri.Graphic(geom[0],symbol);

        map.graphics.add(graphic);
//		console.debug(graphic);
		
		var features= [];
        features.push(graphic);

        var featureSet = new esri.tasks.FeatureSet();
        featureSet.features = features;
		
        var params = {}; //{ "Input value raster" : "\"D:\\GISData\\CoastalGa\\WM84\\Energy\\ga_off_pwr90\"", "Offshore Wind Speed 90m" : "D:\\GISData\\CoastalGa\\WM84\\Energy\\ga_off_pwr90" }; // "InputFeatures" : featureSet };
		params.InputFeatures = featureSet;
		params.InputRasterPath = location;
		
		//console.debug(params);
		
        gp_bathy.execute(params, function(r, m) {
			tempArray = lastStatsFieldsSummaryAllRaster();
			tempArray.push({"label": label, stats: new ko.observableArray( [
			{
				"fld_obj": {name: "Stats", type: "esriFieldTypeSingle", alias: "Raster Stats"},
					min: ko.observable  (doTrimNumber( r[0].value.features[0].attributes.MIN)),
					max: ko.observable  (doTrimNumber( r[0].value.features[0].attributes.MAX)),
					avg: ko.observable  (doTrimNumber( r[0].value.features[0].attributes.MEAN)),
					total: ko.observable(doTrimNumber( r[0].value.features[0].attributes.SUM) ),
					count: ko.observable(doTrimNumber( r[0].value.features[0].attributes.AREA ) ) }])
			});
			
			rastersToQuery( rastersToQuery() - 1);
			
			lastStatsFieldsSummaryAllRaster(tempArray);
			
			//$('#resultsContainer').jScrollPane({verticalGutter: 0});
		}, function(e) {
			alert("An error occurred querying " + label);
			console.log(e.stack);
			rastersToQuery( rastersToQuery() - 1);
		});
	}
	catch( e) {
		console.debug(e);
	}
	/** */
}

function processFields(curr_count, feature, sfields, pcntAdj) {
	console.debug( curr_count );
	console.debug( pcntAdj );
	
	for(var i = 0; i < sfields.length; i++) {
		console.debug(sfields[i]);
		
		var value = parseFloat( feature.attributes[ sfields[i]["fld_obj"].name ] );
		
		value *= pcntAdj;
		
		if( isNaN( sfields[i].max() ) || value > sfields[i].max())
			sfields[i].max(doTrimNumber(value));
		
		if( isNaN( sfields[i].min() ) || value < sfields[i].min())
			sfields[i].min(doTrimNumber(value));
		
		if( isNaN( sfields[i].total() ) )
			sfields[i].total(doTrimNumber(value));
		else
			sfields[i].total(doTrimNumber(parseFloat(value) + parseFloat(sfields[i].total())));
		
		sfields[i].count( curr_count );
			
		if( isNaN( sfields[i].avg() ) )
			sfields[i].avg(doTrimNumber(value));
		else {
			//sfields[i].avg(doTrimNumber((value + (parseFloat(sfields[i].avg()) * (curr_count-1))) / (curr_count)) );
			sfields[i].avg( doTrimNumber( sfields[i].total() / sfields[i].count() ) );
		}
	}
	
	return sfields;
}

function processSummaryResults(all_results) {
	if(results_done_processed) return;
	
	for(var kk = 0; kk < all_results.length; kk++) {
		var FieldsSummary = [];
			
		var results = all_results[kk];
		labelsUrls.reverse();
			
		var fields = dojo.map(results.fields, function(field) {
//			if(field.alias != "FID")
//				FieldsSummary.push(field.alias);
				
			if( field.type == "esriFieldTypeSingle" ||
				field.type == "esriFieldTypeDouble" ||
				field.type == "esriFieldTypeInteger" ||
				field.type == "esriFieldTypeSmallInteger" ) {
				
				FieldsSummary.push( {"fld_obj": field,
					min: ko.observable(Number.NaN),
					max: ko.observable(Number.NaN),
					avg: ko.observable(Number.NaN),
					total: ko.observable(Number.NaN),
					count: ko.observable(0) } );
			}

			return [];
		});
					
		var geomProjected = null;
		var pparams = new esri.tasks.ProjectParameters();
		
		for( var curr_count = 1; curr_count <= results.features.length ; curr_count ++) {
			try {
				var feature = results.features[curr_count - 1];
				var a = dojo.clone(feature.attributes);
				a["SHAPE"] = feature.geometry;
				
				//lastAttribFeaturesSummary.push(a);
							
				var geometryService = new esri.tasks.GeometryService("http://tasks.arcgisonline.com/ArcGIS/rest/services/Geometry/GeometryServer");
				
				//console.debug(feature.geometry.type);
				
				if (FieldsSummary.length == 0) {
					FieldsSummary.push( {
						"fld_obj": {name: "Count", type: "esriFieldTypeSingle", alias: "Count"},
						min: ko.observable(Number.NaN),
						max: ko.observable(Number.NaN),
						avg: ko.observable(Number.NaN),
						total: ko.observable(Number.NaN),
						count: ko.observable(results.features.length) } );
				}
				else {
					if(feature.geometry != null && feature.geometry.type == "polygon") {
						pparams.geometries = lastGeom;
						pparams.outSR = feature.geometry.spatialReference;
						
						geometryService.project  ( pparams, function(r) {
							geomProjected = r[0];
							
							geometryService.intersect( [geomProjected], feature.geometry, function(g) {
								//console.debug(g);
								
								var areasAndLengthsParams = new esri.tasks.AreasAndLengthsParameters();
								areasAndLengthsParams.lengthUnit = esri.tasks.GeometryService.UNIT_FOOT;
								areasAndLengthsParams.areaUnit   = esri.tasks.GeometryService.UNIT_ACRES;
								areasAndLengthsParams.polygons   = [ g[0], feature.geometry ];
								
								geometryService.areasAndLengths( areasAndLengthsParams, function(r2) {
									var pcntAdj = /*min ( */r2.areas[0]/r2.areas[1] //, 1.00);
									processFields(curr_count, feature, FieldsSummary, pcntAdj);
								});
							});
						});
					}
					else {
						processFields(curr_count, feature, FieldsSummary, 1);
					}
				}
				
				var isAlreadyThere = false;

				for(var l = 0; l < lastStatsFieldsSummaryAll().length; l++) {
					isAlreadyThere = ( lnames[kk] == lastStatsFieldsSummaryAll()[l].label );
					
					if(isAlreadyThere) break;
				}

				if(!isAlreadyThere) {
					lastStatsFieldsSummaryAll.push({"label": lnames[kk], stats: FieldsSummary});
					lnames_checklist.splice( lnames_checklist.indexOf(lnames[kk]), 1 );
				}
			}
			catch(e) {
				console.log(e.stack);
			}
		}
	}
	
	console.debug(lnames_checklist);
	
	for(var no_query_item in lnames_checklist) {
		lastStatsFieldsSummaryAll.push({"label" : lnames_checklist[no_query_item], stats: null});
	}
		
	lnames_checklist = [];
	lnames = [];
	
	results_done_processed = true;
	
	//$('#resultsContainer').jScrollPane({verticalGutter: 0});
}