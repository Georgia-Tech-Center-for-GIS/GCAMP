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

function getAttributesLayer (url) {
	
	var qt = new esri.tasks.QueryTask( url );
	var query = new esri.tasks.Query();
	
	query.where = "1=1";
	query.returnGeometry = false;
	query.outFields= ["*"];
	
	qt.execute(query, function(results) {
		//console.debug(results);
			
		var fields = dojo.map(results.fields, function(field) {
			var item = [];
			item['name'] = field.alias;
			item['field']= field.name;
			return dojo.clone(item);
		});
		
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
	});
	
}