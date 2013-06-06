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

var mean_curr = ko.computed(function() {
		var stats = [{min: -999, max: -999, avg: -999}];
		var total = 0;
		var min = -999;
		var max = -999;
		var avg = -999;
		
		return stats;
		
		if(lastIdResults().length > 0) {
			var curr_results = lastIdResults.peek()[0];
			var count = 0;
			
			for(var i = 0; i < curr_results.length; i++) {
				var val = parseFloat(curr_results[i].value);
				
				if(isNaN(val)) continue;
				
				total = total + val;
				
				if(min == -999 || val < min) {
					min = val;
				}
				
				if(max == -999 || val > max) {
					max = val;
				}
				
				count++;
			}
			
			avg = total / count;
		}

		stats["min"] = min.toPrecision(3);
		stats["max"] = max.toPrecision(3);
		stats["avg"] = avg.toPrecision(3);
		return stats;
	}, null);
	
var gp = null;
var params = null;

function doIdentify(evt) {
	map.graphics.clear();
	lastIdResults.removeAll();
	idViewModel.idOpenLayers = ko.observableArray();
	
	var centerPoint = new esri.geometry.Point(evt.mapPoint.x,evt.mapPoint.y,evt.mapPoint.spatialReference);
    var mapWidth = map.extent.getWidth();
	var pixelWidth = mapWidth / map.width;
	var tolerance = ptIDTolerance() * pixelWidth;
	var queryExtent = new esri.geometry.Extent (1,1,tolerance,tolerance,evt.mapPoint.spatialReference);
	
    identifyParams.geometry = queryExtent.centerAt(centerPoint);
	identifyParams.mapExtent = map.extent;
	identifyParams.layerIds = /*[0]; / */ viewModel.currentVisibleLayers.peek()[2].vlayers;
	
	//for (var j = 0; j < ly1.visibleLayers.length; j++) {
		//identifyParams.layerIds.push(ly1.visibleLayers[j]);
	//}
	
	{
		/*var features = [];
		features.push(queryExtent.centerAt(centerPoint));
		var featureSet = new esri.tasks.FeatureSet();
		featureSet.features = features;
		
		gp = new esri.tasks.Geoprocessor("http://carto.gis.gatech.edu/ArcGIS/services/CoastToolbox/GPServer/SummarizeMean");
		//params = {"Polygon": featureSet };
		
		gp.execute (params, function(r, m) {
			console.debug(r);
			console.debug(m);
		});*/
	}
	/*{
		var isit = new esri.tasks.ImageServiceIdentifyTask("http://servicesbeta.esri.com/ArcGIS/rest/services/Portland/PortlandAerial/ImageServer");
		var isip = new esri.tasks.ImageServiceIdentifyParameters();
		
		isip.geometry = queryExtent.centerAt(centerPoint);
		//isip.mosaicRule = esri.layers.MosaicRule.METHOD_MAX;
		isit.execute(isip, function (e) {
			console.debug(e);
		});
	}*/
	
	identifyParams.layerIds = identifyParams.layerIds.sort();
	
	identifyTask.execute(identifyParams,
		function (idResults) {
		
		if (idResults != null) {
			console.debug(idResults);
			
			addToMap(idResults, evt);
		}
	});
}

var dispIDTolerance = ko.computed(function() {
		var currIDtol = ptIDTolerance();
		
		if(typeof map != 'undefined') {
		
			var mapWidth = map.extent.getWidth();
			var pixelWidth = mapWidth / map.width;
			var tolerance = currIDtol * pixelWidth;

			return ((tolerance/5240).toPrecision(2) + " miles");
		}
		else
			return "-999 miles";
			
	}, null);

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
		
		$('.scroll-pane').jScrollPane({verticalGutter: 0});
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
			var ly1 = map.getLayer( map.layerIds[2] );
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
	
	$('.scroll-pane').jScrollPane({verticalGutter: 0});	
}

function aaah(e){
	console.debug(e);
}

var selectedLayersSummary = ko.observableArray();
var availableLayersSummary= ko.observableArray();
var lastStatsFieldsSummaryAll = ko.observableArray();
var summQry = null;
var labelsUrls = [];

var lastGeom = null;
var qobjs = [];
var lnames = [];
var lnames_checklist = [];
var promises;

var results_done_processed = false;

function doSummaryQuery(geom) {
	//if(geom[0].type != "POLYGON") return;
	
	lastGeom = geom;
	results_done_processed = false;
	
	var tempArray = new Array();
	
	lastStatsFieldsSummaryAll.removeAll();
	lastAttribFeaturesSummary.removeAll();
	lastStatsFieldsSummary.removeAll();

	/*labelsUrls = [];

	if(summQry == null) summQry = new esri.tasks.Query();
	
	summQry.where = "1=1";
	summQry.returnGeometry = true;
	summQry.spatialRelationship = esri.tasks.Query.SPATIAL_REL_CONTAINS;
	summQry.geometry = geom[0];
	summQry.outSpatialReference = map.spatialReference;
	summQry.outFields= ["*"];
	//map.graphics.add(geom[0]);
	
	var layersToQuery = selectedLayersSummary();
	qobjs = [];
			  
	for(var layerIndex = 0; layerIndex < layersToQuery.length; layerIndex++) {
		//console.debug(layersToQuery[layerIndex]);
		
		var currUrl = layersToQuery[layerIndex].url;
		labelsUrls[currUrl] = layersToQuery[layerIndex].label;
		lnames.push (layersToQuery[layerIndex].label);
		console.debug(currUrl);
		
		try {
			var qt = new esri.tasks.QueryTask( currUrl );
//			qobjs.push(qt.execute(summQry , processSummaryResults));
		}
		catch(e) {
			console.debug(e);
		}
	}*/
	
	//submit to bathymetry testing
	/** */
	try {
//		var gp_bathy = new esri.tasks.Geoprocessor("http://carto.gis.gatech.edu/ArcGIS/rest/services/CoastToolbox/GPServer/SummImagery");
		var gp_bathy = new esri.tasks.Geoprocessor("http://tulip.gis.gatech.edu:6080/arcgis/rest/services/GACoast/SummImagery/GPServer/SummImagery");
		//dojo.connect(gp_bathy, "onExecuteComplete", );

		//map.showZoomSlider();
        map.graphics.clear();
        
        var symbol = new esri.symbol.SimpleFillSymbol("none", new esri.symbol.SimpleLineSymbol("dashdot", new dojo.Color([255,0,0]), 2), new dojo.Color([255,255,0,0.25]));
        var graphic = new esri.Graphic(geom[0],symbol);

        map.graphics.add(graphic);
		console.debug(graphic);
		
		var features= [];
        features.push(graphic);

        var featureSet = new esri.tasks.FeatureSet();
        featureSet.features = features;
		
        var params = { "Input value raster" : "\"D:\\GISData\\CoastalGa\\WM84\\Energy\\ga_off_pwr90\"", "Offshore Wind Speed 90m" : "D:\\GISData\\CoastalGa\\WM84\\Energy\\ga_off_pwr90" }; // "InputFeatures" : featureSet };
		params.InputFeatures = featureSet;
		//params.InputFeatures.features[0].attributes = {"Id" : 1};
		//params.InputRaster = "D:\\GISData\\CoastalGa\\WM84\\Energy\\offsyrmeanwm";
		//params.ETOPO2_Bathy_SE_IMG = "\\\\carto\\GISDATA\\GACMSP\\GISDATA\\GCAMP\\sediment\\seabedxtr.img";
		//params.InputRaster = "http://tulip.gis.gatech.edu:6080/arcgis/rest/services/GACoast/coastal2213/MapServer/82";
		//params.Input = "D:\\GISData\\CoastalGa\\WM84\\Energy\\ga_off_pwr90";
		params.InputRasterPath  = "\"D:\\GISData\\CoastalGa\\WM84\\Energy\\ga_off_pwr90\"";
		
		console.debug(params);
		
        gp_bathy.execute(params, function(r, m) {		
			console.debug(r);
			
			//lastStatsFieldsSummary.push(  );
					
			tempArray.push({"label": "Bathymetry", stats: new ko.observableArray( [
			{
				"fld_obj": {name: "Area Stats", type: "esriFieldTypeSingle", alias: "Z Area Stats"},
					min: ko.observable(r[0].value.features[0].attributes.MIN),
					max: ko.observable(r[0].value.features[0].attributes.MAX),
					avg: ko.observable(r[0].value.features[0].attributes.MEAN),
					total: ko.observable(r[0].value.features[0].attributes.SUM),
					count: ko.observable(r[0].value.features[0].attributes.AREA) }])
			});
			
			lastStatsFieldsSummaryAll(tempArray);
		}, function(e) {
		});
	}
	catch( e) {
		console.debug(e);
	}
	/** */
}

var lastAttribFieldsSummary = ko.observableArray();
var lastAttribFeaturesSummary = ko.observableArray();
var lastStatsFieldsSummary = ko.observableArray();

function processFields(curr_count, feature, sfields, pcntAdj) {
	for(var i = 0; i < sfields.length; i++) {
		var value = parseFloat( feature.attributes[ sfields[i]["fld_obj"].name ] );
		
		value *= pcntAdj;
		
		if( isNaN( sfields[i].max() ) || value > sfields[i].max())
			sfields[i].max(value);
		
		if( isNaN( sfields[i].min() ) || value < sfields[i].min())
			sfields[i].min(value);
			
		if( isNaN( sfields[i].total() ) )
			sfields[i].total(value);
		else
			sfields[i].total(value + sfields[i].total());
		
		sfields[i].count( curr_count );
			
		if( isNaN( sfields[i].avg() ) )
			sfields[i].avg(value);
		else {
			sfields[i].avg((value + (sfields[i].avg() * (curr_count-1))) / (curr_count) );
		}
	}
}

function processSummaryResults(all_results) {
	if(results_done_processed) return;
	
	lastStatsFieldsSummaryAll.removeAll();
	lnames_checklist = lnames.slice(0);
	
	for(var kk = 0; kk < all_results.length; kk++) {
		lastStatsFieldsSummary = ko.observableArray();
		
		var results = all_results[kk];
		labelsUrls.reverse();
			
		//, function(results) {
			var fields = dojo.map(results.fields, function(field) {
				if(field.alias != "FID")
					lastAttribFieldsSummary.push(field.alias);
					
				if( field.type == "esriFieldTypeSingle" ||
					field.type == "esriFieldTypeDouble" ||
					field.type == "esriFieldTypeInteger" ||
					field.type == "esriFieldTypeSmallInteger" ) {
					lastStatsFieldsSummary.push( {"fld_obj": field,
						min: ko.observable(Number.NaN),
						max: ko.observable(Number.NaN),
						avg: ko.observable(Number.NaN),
						total: ko.observable(Number.NaN),
						count: ko.observable(0) } );
				}

				return [];
			});
					
			var sfields = lastStatsFieldsSummary.peek();
			
			var geomProjected = null;
			var pparams = new esri.tasks.ProjectParameters();
			
			for( var curr_count = 1; curr_count <= results.features.length ; curr_count ++) { //= dojo.map(results.features, function(feature) {
				try {
					var feature = results.features[curr_count - 1];
					var a = dojo.clone(feature.attributes);
					a["SHAPE"] = feature.geometry;
					lastAttribFeaturesSummary.push(a);
					//map.graphics.add(feature);
								
					var geometryService = new esri.tasks.GeometryService("http://tasks.arcgisonline.com/ArcGIS/rest/services/Geometry/GeometryServer");
					
					console.debug(feature.geometry.type);
					
					if(feature.geometry.type == "polygon") {
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
									processFields(curr_count, feature, sfields, pcntAdj);
								});
							});
						});
					}
					else {
						processFields(curr_count, feature, sfields, 1);
					}

					for(var i = 0; i < lastStatsFieldsSummary().length; i++) {
						lastStatsFieldsSummary()[i].min(lastStatsFieldsSummary()[i].min().toFixed(3));
						lastStatsFieldsSummary()[i].avg(lastStatsFieldsSummary()[i].avg().toFixed(3));
						lastStatsFieldsSummary()[i].max(lastStatsFieldsSummary()[i].max().toFixed(3));
						lastStatsFieldsSummary()[i].total(lastStatsFieldsSummary()[i].total().toFixed(3));
					}
					
					if (lastStatsFieldsSummary().length == 0) {
						lastStatsFieldsSummary.push( {
							"fld_obj": {name: "Count", type: "esriFieldTypeSingle", alias: "Count"},
							min: ko.observable(Number.NaN),
							max: ko.observable(Number.NaN),
							avg: ko.observable(Number.NaN),
							total: ko.observable(Number.NaN),
							count: ko.observable(results.features.length) } );
					}
					
					var isAlreadyThere = false;
					
					for(var l = 0; l < lastStatsFieldsSummaryAll().length; l++) {
						isAlreadyThere = ( lnames[kk] == lastStatsFieldsSummaryAll()[l].label );
						
						if(isAlreadyThere) break;
					}
					
					if(!isAlreadyThere) {
						lastStatsFieldsSummaryAll.push({"label": lnames[kk], stats: lastStatsFieldsSummary});
						lnames_checklist.splice( lnames_checklist.indexOf(lastStatsFieldsSummaryAll()[0].label), 1 );
					}
				}
				catch(e) {
				}
				//dojo.clone(feature.attributes);
			}//);
	}
	
	console.debug(lnames_checklist);
	
	for(var no_query_item in lnames_checklist) {
		lastStatsFieldsSummaryAll.push({"label" : lnames_checklist[no_query_item], stats: null});
	}
	
	lnames_checklist = [];
	lnames = [];
	
	results_done_processed = true;
}