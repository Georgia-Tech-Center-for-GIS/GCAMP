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

function doIdentify(evt) {
	map.graphics.clear();
	identifyParams.geometry = evt.mapPoint;
	identifyParams.mapExtent = map.extent;
	identifyParams.layerIds = [];
	
	for (var j = 0; j < ly1.visibleLayers.length; j++) {
		identifyParams.layerIds.push(ly1.visibleLayers[j]);
	}
	
	identifyTask.execute(identifyParams,
		function (idResults) {
		if (idResults != null) {
			addToMap(idResults, evt);
		}
	});
}

var factoredResults = null;
var lastIdResults = ko.observableArray();

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
		a.feature.setSymbol(symbol);
		
		map.setExtent(a.feature.geometry.getExtent().expand(1.5));
		
		map.graphics.add(a.feature);
	}
}

function getResultsFields(ftre) {
	var arrayResult = ko.observableArray();
	
	var attribs = ftre.feature.attributes;
	
	var i = 0;
	for (var k in attribs) {
		arrayResult.push( {"Name" : k , "Value" : attribs[k] } );
	}
	
	return arrayResult;
}

function addToMap(idResults, evt) {
	var tempIdResults = idResults;
	factoredResults = [];
	
	lastIdResults.removeAll();
	idViewModel.idOpenLayers.removeAll();
		
	if(idResults.length == 0) {
		return;
	}
	
	for (var i = 0; i < idResults.length; i++) {
		if(factoredResults[ idResults[i].layerName ] == null) {
			factoredResults[ idResults[i].layerName ] = [];
			idViewModel.idOpenLayers.push( idResults[i].layerName );
		}
		
		factoredResults[ idResults[i].layerName ] = factoredResults[ idResults[i].layerName ].filter( function (f) {		
				if( f.feature.attributes.FID ==
						idResults[i].feature.attributes.FID) return false;
					
				return true;
			});
		
		factoredResults[ idResults[i].layerName ].push(idResults[i]);
	}
	
	counter = 0;
	
	for (var j in factoredResults) {
		lastIdResults.push(factoredResults[j]);
	}

	$('.scroll-pane').jScrollPane({verticalGutter: 0});	
}