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
		/*
		if(ly1.visibleLayers[j] != -1 && ly1.layerInfos[ ly1.visibleLayers[j] ] != null &&
		ly1.layerInfos[ ly1.visibleLayers[j] ].parentLayerId != -1) {
		identifyParams.layerIds.push( ly1.layerInfos[ ly1.visibleLayers[j] ].parentLayerId );
		}*/
	}
	
	//console.debug(identifyParams.layerIds);
	
	identifyTask.execute(identifyParams,
		function (idResults) {
		if (idResults != null) {
			addToMap(idResults, evt);
		}
	});
}

var lastIdResults = null;
var factoredResults = [];

function addToMap(idResults, evt) {
	lastIdResults = idResults;
	factoredResults  = [];
	
	if(idResults.length == 0) {
		return;
	}
	
	var bidPanel = dijit.byId('bottomIDPanel');
	bidPanel.destroyDescendants();
	
	//console.debug(idResults);

	for (var i = 0; i < idResults.length; i++) {
		if(factoredResults[ idResults[i].layerName ] == null) {
			factoredResults[ idResults[i].layerName ] = [];
		}
		
		factoredResults[ idResults[i].layerName ].push(idResults[i]);
	}
	
	counter = 0;
	lastIdResults = factoredResults;
	
	for (var j in factoredResults) {
		var root = dojo.create('div', {});
		
		console.debug(j);
		console.debug(factoredResults[j]);
		
		var grp = factoredResults[j];
		
		for(var k in grp) {
			var feat = grp[k].feature;
			var attribs = feat.attributes;
			
			if (feat.geometry == null) {
			} else {
				layerTitle = dojo.create('div', { "class": "idLayerLabel"}, root);
				var layerLink = dojo.create('a', {
						href : "#",
						onClick : "showIdentifySymbol(\"" + j + "\"," + k + ");",
						innerHTML : "Click to highlight feature"
					}, layerTitle);
			}
			
			var attrTable = dojo.create('table', {
					style : "margin-left: 15px;"
				}, root);
			
			for (var l in attribs) {
				var attrTr = dojo.create('tr', {}, attrTable);
				var attrName = dojo.create('td', {
						innerHTML : l,
						"class" : "idAttribLabel"
					}, attrTr);
				var attrValue = dojo.create('td', {
						innerHTML : attribs[l],
						"class" : "idAttribValue"
					}, attrTr);
			}
			
			counter++;
		}
		
		var tpane = new dijit.TitlePane({ title: j, content: root.outerHTML });
		bidPanel.containerNode.appendChild(tpane.domNode);
		
		bidPanel._supportingWidgets.push(tpane);
	}
	
	//dijit.byId('bottomIDPanel').setContent(root.outerHTML);
	
	toggleIdentifyOn(dijit.byId('LeftExPanel'));
	dijit.byId('LeftTabs').selectChild(dijit.byId('bottomIDPanel'));
	
	//map.infoWindow.show(evt.screenPoint, map.getInfoWindowAnchor(evt.screenPoint));
}

function showIdentifySymbol(i, j) {
	map.graphics.clear();
	lastIdResults[i][j].feature.setSymbol(symbol);
	
	map.setExtent(lastIdResults[i][j].feature.geometry.getExtent().expand(1.5));
	
	map.graphics.add(lastIdResults[i][j].feature);
}