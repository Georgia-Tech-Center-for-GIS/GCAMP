dojo.require("dijit.form.DateTextBox");
dojo.require("dijit.Toolbar");

dojo.require("dojo.store.Memory");
dojo.require("dojo.data.ItemFileReadStore");

dojo.require("dojo.dnd.Source");
dojo.require("dijit.TitlePane");

dojo.require("dijit.layout.BorderContainer"); 
dojo.require("dijit.layout.ContentPane"); 
dojo.require("dijit.layout.TabContainer");
dojo.require("dijit.form.CheckBox");

dojo.require("dojox.layout.ExpandoPane");
dojo.require("dojox.grid.DataGrid");

dojo.require("esri.utils");
dojo.require("esri.IdentityManager");

dojo.require("esri.map"); 
dojo.require("esri.layers.FeatureLayer");
dojo.require("esri.layers.agsdynamic");
dojo.require("esri.tasks.gp"); 
dojo.require("esri.dijit.Legend"); 
dojo.require("esri.dijit.Popup");

//dojo.require("dgrid.OnDemandGrid");

var grid = null;
var store = null;

var lastAttribFields = ko.observableArray();
var lastAttribFeatures = ko.observableArray();
var lastAttribURL = ko.observable();
var lastStatsFields = ko.observableArray();
var lastStatsAvg = ko.observableArray();

function initAttributesLayerList() {
	var lyrList = [];
	
	for(var j = 0 ; j < map.layerIds.length; j++ ) {
		var lyr = map.getLayer(map.layerIds[j]);
		var infos = lyr.layerInfos, info;
		
		for (var i=0, il=infos.length; i<il; i++) {
			info = infos[i];
			
			if(info.subLayerIds == null && info.name.search("Basemap") == -1) {
				lyrList.push({label : info.name, value : lyr.url+"/" + i});
			}
		}
	}
	
	//console.debug(lyrList);
	
	var layerStoreMemory2 = new dojo.store.Memory({data: lyrList});
	var layerStore2 = new dojo.data.ObjectStore({objectStore: layerStoreMemory2});
			
	var lyrSelect2 = new dijit.form.Select({
		id: 'attributesPanelSelector',
		name: "",
		style: "width: 15em; height: 1em;",
		options: lyrList,
		maxHeight: "5em;"});
		
	lyrSelect2.placeAt("SelectMapLayerAttributes");
	
	dojo.connect(lyrSelect2, "onChange", function(evt) {
		getAttributesLayer(evt);
	});
	
	lyrSelect2.startup();
}

var koNaN = ko.observable(Number.NaN);

function getAttributesLayer (url) {
	try {
	lastAttribURL(url);
	
	lastAttribFeatures.removeAll();
	lastAttribFields.removeAll();
	lastStatsFields.removeAll();
	
	var qt = new esri.tasks.QueryTask( url );
	var query = new esri.tasks.Query();
	
	qt.DisableClientCaching = true;
	
	query.where = "1=1";
	query.returnGeometry = true;
	query.outSpatialReference = map.spatialReference;
	query.outFields= ["*"];
	
	qt.execute(query, function(results) {
		console.debug(results);
		
		var fields = dojo.map(results.fields, function(field) {
			if(field.alias != "FID")
				lastAttribFields.push({"name" : field.name, "alias" : field.alias});
				
			if( field.type == "esriFieldTypeSingle" ||
				field.type == "esriFieldTypeDouble" ||
				field.type == "esriFieldTypeInteger" ||
				field.type == "esriFieldTypeSmallInteger" ) {
				lastStatsFields.push( {"fld_obj": field,
					min: ko.observable(Number.NaN),
					max: ko.observable(Number.NaN),
					avg: ko.observable(Number.NaN),
					total: ko.observable(Number.NaN),
					count: ko.observable(0) } );
			}

			return [];
			
			//var item = [];
			//item['name'] = field.alias;
			//item['field']= field.name;
			//return dojo.clone(item);
		});
		
		var sfields = lastStatsFields.peek();
		
		var items = dojo.map(results.features, function(feature) {
			//console.debug(feature);
			var a = dojo.clone(feature.attributes);
			a["SHAPE"] = feature.geometry;
			lastAttribFeatures.push(a);
			//map.graphics.add(feature);
			
			for(var i = 0; i < sfields.length; i++) {
				var value = feature.attributes[ sfields[i]["fld_obj"].name ];
				
				if( isNaN( sfields[i].max() ) || value > sfields[i].max())
					lastStatsFields()[i].max(value);
				
				if( isNaN( sfields[i].min() ) || value < sfields[i].min())
					lastStatsFields()[i].min(value);
					
				if( isNaN( sfields[i].total() ) )
					lastStatsFields()[i].total(value);
				else
					lastStatsFields()[i].total(value + lastStatsFields()[i].total());
				
				var lastCount = lastStatsFields()[i].count();
				lastStatsFields()[i].count(lastStatsFields()[i].count()+1);
					
				if( isNaN( sfields[i].avg() ) )
					lastStatsFields()[i].avg(value);
				else {
					lastStatsFields()[i].avg((value + (lastStatsFields()[i].avg() * lastCount)) / (lastCount+1) );
				}
			}
			return dojo.clone(feature.attributes);
		});
		
		for(var i = 0; i < sfields.length; i++) {
			lastStatsFields()[i].min(lastStatsFields()[i].min().toFixed(3));
			lastStatsFields()[i].avg(lastStatsFields()[i].avg().toFixed(3));
			lastStatsFields()[i].max(lastStatsFields()[i].max().toFixed(3));
			lastStatsFields()[i].total(lastStatsFields()[i].total().toFixed(3));
		}
		
		$('#attribPopoutPanel').dialog({height : 500, width: 650, title:"Attribute Table"});
		
		/*if( lastStatsFields().length > 0 ) {
			$('#sumStatsPopoutPanel').dialog({height : 300, width: 400, title:"Statistics Table"});
		}
		else {
			$('#sumStatsPopoutPanel').dialog('close')
		}*/
		
		$('.attribRow').hover(
			function() {
				$(this).addClass("highlight");
			},
			function() {
				$(this).removeClass("highlight");
			}
		);
			
		/*
		
		var layout = [fields];
		
		var items = dojo.map(results.features, function(feature) {
			return dojo.clone(feature.attributes);
		});
		
		data = {
			identifier: results.fields[0].name,
			items: items
		};
		
		store = new dojo.data.ItemFileReadStore({data: data});
		
		if(grid != null) {
			grid.destroy();
		}
		
		grid = new dojox.grid.DataGrid( {id: 'attribGrid', store: store, structure : layout, rowSelector: '20px'});
		grid.placeAt("gridDiv");
		//grid.setStore( store);

		grid.startup();
		*/
	});
	}
	catch(eeeee) {
		console.debug(eeeee);
	}
}

function dispAttribTable(a) {
	getAttributesLayer(a.url);
}

var lastShape = null;
var c = null;

function doAttribZoom(a) {
	lastShape = a;
	
	console.debug(a);
	
	var b = a["SHAPE"];
	if(b.type == "point") {
		c =  new esri.geometry.Extent(b.x-65000,b.y-65000,b.x+65000,b.y+65000, map.spatialReference);
	}
	else {
		c = b.getExtent().expand(1.75);
	}
	
	map.setExtent(c);
}

function showStatsDlg() {
	$("#sumStatsPopoutPanel").dialog({height : 300, width: 400, title:"Statistics Table"});
}