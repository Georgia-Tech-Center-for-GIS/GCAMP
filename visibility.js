dojo.require("dijit.form.DateTextBox");
dojo.require("dijit.Toolbar");

dojo.require("dojo.store.Memory");

dojo.require("dojo.dnd.Source");
dojo.require("dijit.TitlePane");

dojo.require("dijit.layout.BorderContainer"); 
dojo.require("dijit.layout.ContentPane"); 
dojo.require("dijit.layout.TabContainer");
dojo.require("dijit.form.CheckBox");

dojo.require("dojox.layout.ExpandoPane");

dojo.require("dojox.xml.DomParser");

dojo.require("esri.utils");
dojo.require("esri.IdentityManager");

dojo.require("esri.map"); 
dojo.require("esri.layers.FeatureLayer");
dojo.require("esri.layers.agsdynamic");
dojo.require("esri.tasks.gp"); 
dojo.require("esri.dijit.Legend"); 
dojo.require("esri.dijit.Popup"); 

var layerTabContainer = null;
var layerTitlePane = null;

function return_child_layers(mapLyr, mapLyrId, layerInfo) {
	var list = [];
	var lastIndex = 0;
	
	dojo.forEach( layerInfo.subLayerIds, function(id, k) {
		var li = mapLyr.layerInfos[id];
		var dispLyr = {
			"mapLayerId" : mapLyrId,
			"seq" : id,
			"name": li.name,
			"url" : mapLyr.url + "/" + id,
			"esriLayer": li,
			"children" : []
		};
		
		lastIndex = id;

		if(li.subLayerIds) {
			var retval = return_child_layers(mapLyr, mapLyrId, li);
			
			dispLyr.children = dojo.clone(retval.childLayers);
			lastIndex = retval.lastIndex;
		}
		
		list.push(dispLyr);
	});
	
	var returnValue = { "childLayers": list, "lastIndex": lastIndex };
	
	//console.debug(list);
	return returnValue;
}

function return_map_layers() {
	var mapItems = [];
	var lastIndex = -1;
	
	for(var j = 0 ; j < map.layerIds.length; j++ ) {
		var lyr = map.getLayer(map.layerIds[j]);
		
		var dispLyrOuter = {
			"children": []
		};
		
		console.debug(lyr);
		
		switch(j) {
			case 0:
			continue;
			
			case 1:
			dispLyrOuter.name = "Carto";
			break;
			
			default:
			dispLyrOuter.name = "H" + j.toString();
			break;
		};
		
		var allLyrs = [];
	
		dojo.forEach( lyr.layerInfos, function (li, i) {
			if(i-1 < lastIndex) {
			}
			else {
				var dispLyr = {
					"mapLayerId" : map.layerIds[j],
					"seq" : i,
					"name": li.name,
					"url" : lyr.url + "/" + i,
					"esriLayer": li,
					"children" : []
				};

				if(li.subLayerIds) {				
					var retval = return_child_layers(lyr, map.layerIds[j], li);
					dispLyr.children = dojo.clone(retval.childLayers);
					lastIndex = retval.lastIndex;
				}
				
				dispLyrOuter.children.push(dispLyr);
			}
		});
		
		mapItems.push(dispLyrOuter);
	}
	
	return mapItems;
}

var viewModel = {
	themes :ko.observableArray(['Carto']),
	currentVisibleLayers: ko.observableArray(),
	
	isOpenTheme : function (a) {
		var themeName = a;
	
		if( viewModel.themes.indexOf(themeName) !== -1) {
			return true;
		}
		return false;
	}, 

	setOpenTheme: function(a) {
		var themeName = a.name;
	
		if( viewModel.isOpenTheme(themeName) ) {
			viewModel.themes.remove(themeName);
		}
		else {
			viewModel.themes.push(themeName);
		}
		
		var element = $('.scroll-pane').jScrollPane({verticalGutter: 0});
		var api = element.data('jsp');

	},
	
	toggleVisibleLayer : function (a) {	
		var lyr = map.getLayer(a.mapLayerId);
		var vl = lyr.visibleLayers;
		var nl = [];
		
		//console.debug(a);
		//console.debug(vl);
		
		nl = vl.filter(function(c) {
			var a = [];
			var b = false;
						
			if(lyr.layerInfos[c].subLayerIds == null) {
				return true;
			}
			else {
				return false;
			}
		});
		
		if(vl.lastIndexOf(a.esriLayer.id) !== -1 ) {
			nl = nl.filter(function(b) { if(b == a.esriLayer.id) return false; else return true; } );
		}
		else {
			nl.push(a.esriLayer.id);
		}
		
		var newVal = {
			"mapLyr" : a.mapLayerId,
			"vlayers": nl
		};
		
		viewModel.currentVisibleLayers.remove( function(i) {
			if(i.mapLyr == a.mapLayerId) return true;
			else return false;
		});
		
		viewModel.currentVisibleLayers.push(newVal);
		
		lyr.setVisibleLayers(nl);
		
		legend.refresh();
	},
	
	isVisibleLayer : function(a,b) {
		try {
			var visibleArray = viewModel.currentVisibleLayers();
			var vl = visibleArray.filter( function( i) {
				if(i.mapLyr == a) return true;
				else return false;
			})[0].vlayers;
			
			if(vl.lastIndexOf(b) !== -1 ) {
				return true;
			}
			else {
				return false;
			}
		}
		catch(e) {
			return false;
		}
	}
};

function init_layer_controls(map) {
	if(!ly1.loaded  /*|| !ly2.loaded*/) return;
	ko.applyBindings();
}

var qry = null;
var a = [];

function updateLayerVisibility (changeValue) {
	console.debug(changeValue);
	console.debug(this);
	
	qry = dojo.query(".dijitChecked", dojo.byId('layersSection'));
	
	a = new Array();
	
	for(var k = 0; k < qry.length; k++) {
		var item = dijit.registry.getEnclosingWidget(qry[k]);
		console.debug(item);
		
		if ( a[ item.mapLyrId ] == null ) {
			a[ item.mapLyrId ] = new Array();
		}
		
		a[ item.mapLyrId ].push(item.lyrId);
	}
	
	for(var l in a) {
		console.debug( a[l] );
		
		map.getLayer(l).setVisibleLayers(a[l]);
	}
	
	legend.refresh();
}

var xmldata = null;
var jsonObj = null;

function xmlToJson(xml) {
var obj = {};
try {
  // Create the return object

  if (xml.nodeType == 1) { // element
    // do attributes
    if (xml.attributes != null && xml.attributes.length > 0) {
    obj["@attributes"] = {};
      for (var j = 0; j < xml.attributes.length; j++) {
        var attribute = xml.attributes.item[j];
        obj["@attributes"][attribute.nodeName] = attribute.nodeValue;
      }
    }
  } else if (xml.nodeType == 3) { // text
    obj = xml.nodeValue;
  }

  // do children
  if (xml.childNodes != null && xml.childNodes.length > 0) {
    for(var i = 0; i < xml.childNodes.length; i++) {
      var item = xml.childNodes[i];
	  
      var nodeName = item.nodeName;
      if (typeof(obj[nodeName]) == "undefined") {
        obj[nodeName] = xmlToJson(item);
      } else {
        if (typeof(obj[nodeName].length) == "undefined") {
          var old = obj[nodeName];
          obj[nodeName] = [];
          obj[nodeName].push(old);
        }
        obj[nodeName].push(xmlToJson(item));
      }
    }
  }
  }
  catch( exception ) {}
  
  return obj;
  
};

function dispLayerInfo(name, id, wurl) {
	var lyrInfoPane = dijit.byId('layerInfoPane');
	//var jsdom = dojox.xml.DomParser.parse(xml);

    //console.debug(xmlToJson(jsdom));
	
	esri.request(
		//{ url : wurl + "/" + id.toString() + "?f=json",
		{ url: "http://carto.gis.gatech.edu/coast/metadata/" + name + ".xml",
		  handleAs : "text"}).
		then(function(data) {
			/*var dstring = "<ul>";

			for(item in data) {
				dstring += "<li><b>" + item + "</b>: " + data[item];
			}
			
			dstring += "</ul>";*/
			var jsdom = dojox.xml.DomParser.parse(data);
			xmldata = jsdom;
			
			jsonObj = xmlToJson(jsdom);
			
			var dstring = "";
			lyrInfoPane.setContent("<h3>"+name+"</h3>");
			
			dijit.byId('LeftTabs').selectChild(dijit.byId('layerInfoPane'));
			toggleIdentifyOn(dijit.byId('LeftExPanel'));
		});
}

function dispLayerAttribs(url,id) {
	console.debug('"+lyr.url+"');
	dijit.byId('attributesPanelSelector').setValue(url +"/" +id );
	//dijit.byId('LeftTabs').selectChild(dijit.byId('attributesPanel'));
	toggleIdentifyOn(dijit.byId('RightExPanel'));
}