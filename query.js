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
dojo.require("esri.tasks.query");

dojo.require("esri.layers.wms");

dojo.require("dojox.xmpp.util");
dojo.require("esri.dijit.BasemapGallery");

var ptIDTolerance = ko.observable(15);

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
	identifyParams.layerIds = viewModel.currentVisibleLayers.peek()[1].vlayers;
	
	//for (var j = 0; j < ly1.visibleLayers.length; j++) {
		//identifyParams.layerIds.push(ly1.visibleLayers[j]);
	//}
	
	identifyParams.layerIds = identifyParams.layerIds.sort();
	
	identifyTask.execute(identifyParams,
		function (idResults) {
			console.debug("IAMHERE");
			
		if (idResults != null) {
			console.debug(idResults);
			
			addToMap(idResults, evt);
		}
	});
}

var lastIdResults = ko.observableArray();

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
			console.debug(k);
			console.debug(attribs[k]);
			
			arrayResult.push( {"Name" : k , "Value" : attribs[k] } );
		}
	}
	
	return arrayResult;
}

//var newResults =  null; //ko.observableArray();

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
		
		if( layerName == "") {
			layerName = ly1.layerInfos[ idResults[i].layerId ].name + " (Raster)";
			idResults[i].layerName = layerName;
		}
		
		if( idResults[i].displayFieldName == "" ) {
			idResults[i].displayFieldName = "Pixel Value";		
			idResults[i].value = idResults[i].feature.attributes["Pixel Value"];
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