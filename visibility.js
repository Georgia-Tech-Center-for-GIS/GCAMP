/**
@file Deals with layer visibility
*/
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

var allMapLayers = ko.observableArray();

var demLayer = null;
var DEM_ESRI = null;
var phyLayer = null;

/**
Returns a list of child layers of the passed layer.
*/
function return_child_layers(mapLyr, mapLyrId, layerInfo) {
	var list = [];
	var lastIndex = 0;
	
	dojo.forEach( layerInfo.subLayerIds, function(id, k) {
	try {					
		var li = mapLyr.layerInfos[id];
		
		//console.debug( viewModel.legendElements()[id] );
		
		//var legendItems = viewModel.legendElements()[ mapLyrId ][id];
		
		if(li != null && li != "undefined") {
			var dispLyr = {
				"mapLayerId" : mapLyrId,
				"seq" : id,
				"name": li.name,
				"url" : mapLyr.url + "/" + id,
				"esriLayer": li,
				"children" : [],
				"minScale" : li.minScale,
				"maxScale" : li.maxScale,
				"isRaster" : false,
				legend : ko.observableArray(),
				//legend : ko.observableArray(legendItems),
				"timeInfo" : null
			};
			
			getMapLayerTimeInfo(mapLyr.url, id, function(lname,ti) {
				li.timeInfo = ti;
				
				timeLayerIds.push( { "id" : id, "label" : lname } );
				checkTimeLayers();
				
			}, checkTimeLayers );
				
			lastIndex = id;

			if(li.subLayerIds) {
				var retval = return_child_layers(mapLyr, mapLyrId, li);
				dispLyr.children = dojo.clone(retval.childLayers);
				lastIndex = retval.lastIndex;
			}
			else {
				availableLayersSummary.push( {data: li.name + "|" + dispLyr.url, label: li.name } );
			}
			}
			}
			catch(e) {
				console.debug(e);
			}
					
			list.push(dispLyr);

	});
	
	var returnValue = { "childLayers": list, "lastIndex": lastIndex };
	
	return returnValue;
}

function return_map_layers() {
	//var mapItems = [];	
	//var mapLyrs = ko.observableArray();
	
	allMapLayers.removeAll();
	availableLayersSummary.removeAll();
	demLayer = null;
	
	for(var j = 1 ; j < map.layerIds.length; j++ ) {
		var currLyrMapId = map.layerIds[j];
		
		var lyr = map.getLayer(currLyrMapId);
		var lastIndex = -1;
		console.debug(lyr.url);
		//var allLyrs = [];
		
		var dispLyrOuter = {
			"children": []
		};

		if(lyr.url == DEM_URL) {
			dispLyrOuter.name = "DEM";
			DEM_ESRI = lyr;
			//soapURL = lyr.url.replace("rest/", "");
			
			esri.request({
				url: lyr.url + "/legend",
				content : {
					f: "JSON"
				},
				load : function(result) {					
					var dispLyr = {
						"mapLayerId" : DEM_ESRI.id,
						"seq" : 0,
						"name": "Digital Elevation Model (DEM)",
						"url" : DEM_URL + "/0",
						"esriLayer": DEM_ESRI.layerInfos[0],
						"children" : [],
						"isRaster" : true,
						"legend"   : result.layers[0],
						"minScale": 0,
						"maxScale": 0,
						"visible": false
					};

					demLayer = dispLyr;
				}
			});
		}
		else if(lyr.url == TulipMapServiceURL || lyr.url.lastIndexOf("tulip") > -1 ||
			lyr.url.lastIndexOf("gchp") > -1) {
			CurrentMainMapServiceURL = lyr.url;

			soapURL = lyr.url.replace("rest/", "");
			
			esri.request({
				url: lyr.url + "/legend",
				handleAs : "json",
				content : {
					"soapUrl": soapURL,
					f: "json"
				},
				load : function(result, a) {
					var newResults = [];
											
					for(var jjj = 0; jjj < result.layers.length; jjj++) {
						newResults[ result.layers[jjj].layerId ] = result.layers[jjj].legend;
					}
					
					console.debug(j);
					
					viewModel.legendElements()[currLyrMapId] = newResults ;
				}
			})

			dojo.forEach( map.getLayer(lyr.id).layerInfos, function (li, i) {						
				if(i-1 >= lastIndex) {
				
					var dispLyr = {
						"mapLayerId" : map.layerIds[j],
						"seq" : i,
						"name": li.name,
						"url" : lyr.url + "/" + i,
						"esriLayer": li,
						"children" : [],
						minScale: 0,
						maxScale: 0,
						legend : ko.observableArray()
						/*"legend" : viewModel.legendElements()[i] */
					};

					if(li.subLayerIds) {
						dispLyr.children = [];
						
						var retval = return_child_layers(lyr, map.layerIds[j], li);
						dispLyr.children = dojo.clone(retval.childLayers);
						lastIndex = retval.lastIndex;
					}
						
					if(li.name.trim() == "Physical" && demLayer != null) {
						dispLyr.children.push(demLayer);
					}
				
					allMapLayers.push(dispLyr);
				}
			});
			
			lastIndex = -1;
				
				/*$('.layerOpacitySlider').slider({
					min: 0,
					max: 1,
					step: 0.1,
					value: 1.0,
					slide: function(event, ui) {
						console.debug(event.delegateTarget.name);
					}
				});*/
			//break;
		}
	}

	lastIndex = -1;

/*
		else if(j > 3) {
/* ======= * /
		else if(lyr.url != NOAA_NautChartURL) { //if(j > 3) {
			//if( mapLyrs.length == 0) continue;
			
/* Leaving merged sections in comment * /
			dispLyrOuter.name = mapLyrs()[ j-3 ].mapLabel;
			
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
			
			allMapLayers.push(dispLyrOuter);
		}*/
}

var xmlMeta;
var lastMetadataAbstract = ko.observable();
var lastMetadataPurpose  = ko.observable();
var lastMetadataLinks    = ko.observable();
var lastMetadataLayerTitle = ko.observable();

var viewModel = {
	themes : ko.observableArray(),
	currentVisibleLayers: ko.observableArray(),
	legendElements: ko.observable({}),
	
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
		
		//var element = $('.scroll-pane').jScrollPane({verticalGutter: 0});
		//var api = element.data('jsp');
	},
	
	
	toggleVisibleLayer : function (a) {
		var lyr = map.getLayer(a.mapLayerId);
		
		if(lyr != null) {
			var vl = lyr.visibleLayers;
			var nl = [];
			
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
			
			if(nl.length == 0) {
				lyr.setVisibility(false);
			}
			else {
				lyr.setVisibility(true);
			}
			
			console.debug(a);
			
			a.legend ( viewModel.legendElements()[a.mapLayerId][a.seq] );
			
			lyr.setVisibleLayers(nl);
			legend.refresh();
		}
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
	//if(!ly1.loaded  /*|| !ly2.loaded*/) return;
	/*if(viewModel.currentVisibleLayers.peek().length == 0) */{
		for(var i = 0; i< map.layerIds.length; i++) {
			var reallyVisibleLayers = [];
			
			var lyr = map.getLayer(map.layerIds[i]);
			
			if(lyr.hasOwnProperty("visibleLayers")) {
				for(var j = 0; j < lyr.visibleLayers.length; j++) {			
					if( lyr.layerInfos[ lyr.visibleLayers[j] ].subLayerIds == null) {
						reallyVisibleLayers.push(lyr.visibleLayers[j]);
					}
				}
			}
			
			var newVal = {
				"mapLyr" : map.layerIds[i],
				"vlayers": reallyVisibleLayers
			};
			
			viewModel.currentVisibleLayers.push(newVal);
		}
	}
	
	return_map_layers();
	resetSummaryPane();
}

var qry = null;
var a = [];

function updateLayerVisibility (changeValue) {
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