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

dojo.require("esri.utils");
dojo.require("esri.IdentityManager");

dojo.require("esri.map"); 
dojo.require("esri.layers.FeatureLayer");
dojo.require("esri.layers.agsdynamic");
dojo.require("esri.tasks.gp"); 
dojo.require("esri.dijit.Legend"); 
dojo.require("esri.dijit.Popup"); 

function allLayersItemNodeCreator(item, hint) {
	var node = dojo.create('tr',
		{
		"class" : "allLyrDndItem",
		"lyrId": item.lid,
		"lyrIdIndex" : item.lyrIdIndex,
		"uniqId" : item.lyrIdIndex.toString() + "_" + item.lyrId
		} );
	var ndTd2 = dojo.create('td', { }, node);
	var btn = new dijit.form.Button({
		label: "Show Layer",
		onClick: function(){	
			vldnd.insertNodes(false, [
				{ name: item.name, lyrIdIndex : item.lyrIdIndex, lyrId: item.lyrId, pid : item.parent }
			]);
			//console.debug(item);
			
			refresh_layers(null, null, null);
		}
	});
	
	ndTd2.appendChild(btn.domNode);

	var ndTd1 = dojo.create('td', {  style : "", innerHTML: item.name}, node);
	
	return { node: node, data: item };
}

var vldnd = null;
var mapref = null;

function refresh_layers(source, nodes, copy) {
	var dndC = dojo.byId('visibleLayersDnd');
	var bArr = [];
	
	dojo.query(".visLyrDndItem", dndC ).sort(function(a,b) {
		var aid = parseInt( a.attributes["lyrId"].value );
		var bid = parseInt( b.attributes["lyrId"].value );
					
		return (aid == bid) ? 0 : ((aid > bid)? 1 : -1);
	}).forEach( function(a, idx) {
		dndC.insertBefore(a, dndC.childNodes[idx]);
	});
	
	vldnd.forInItems( function(item) {
			//console.debug(item.data.lyrIdIndex);
			//console.debug(item.data.lyrId);
			
			if( bArr[ item.data.lyrIdIndex ] == null) 
				bArr[ item.data.lyrIdIndex ] = [];
			
			//bArr[ item.data.lyrIdIndex ].push(item.data.pid);
			bArr[ item.data.lyrIdIndex ].push(item.data.lyrId);
	});
	
	//console.debug(bArr);
	
	mapref.layerIds.forEach( function(item, index) {
		if(bArr[index] != null) {
			mapref.getLayer(item).setVisibility(true);
			mapref.getLayer(item).setVisibleLayers(bArr[index]);
		}
		else {
			mapref.getLayer(item).setVisibility(false);
		}
	});
}

function visibleLayerItemNodeCreator(item, hint) {
	var node = dojo.create('div',
		{
			"class" : "visLyrDndItem",
			"lyrId": item.lyrId,
			"lyrIdIndex" : item.lyrIdIndex,
			"uniqId" : item.lyrIdIndex.toString() + "_" + item.lyrId
		});
	
	var ndTd1 = dojo.create('span', { "class": "", innerHTML: item.name}, node);

	var ndBtn = dojo.create('span', { id: item.name + "_Button", style: "width: 50px; height: 1em;" }, node);
	
	/*var btn = new dijit.form.Button({
		label: "Hide Layer",
		onClick: function(){
			var dndC = dojo.byId('visibleLayersDnd');

			dojo.query("[uniqId=" + item.lyrIdIndex + "_" + item.lyrId +"]", dndC ).forEach( function(a,index) {
				vldnd.selectNone();
				dojo.destroy(a.id);
				vldnd.delItem(a.id);
				
				refresh_layers();
			});
			
		}
	});	*/
	var btn = my.Widget.adopt(dijit.form.Button,
		{
			label: "Hide Layer",
			onClick: function(){
				var dndC = dojo.byId('visibleLayersDnd');

				dojo.query("[uniqId=" + item.lyrIdIndex + "_" + item.lyrId +"]", dndC ).forEach( function(a,index) {
					vldnd.selectNone();
					dojo.destroy(a.id);
					vldnd.delItem(a.id);
				
					refresh_layers();
				});
			
			}
		});
		
	ndBtn.appendChild(btn.domNode);
	
	return { node: node, data: item };
}

var layerTabContainer = null;
var layerTitlePane = null;
var legend = null;

function init_layer_controls(map) {
	if(!ly1.loaded  /*|| !ly2.loaded*/) return;
	
	layerTitlePane = dijit.byId('layersSection');
	
	//layerTitlePane.containerNode.appendChild( dojo.create("h2",
	//	{ innerHTML: "Layer Information and Visibility" } ) );
	
	mapref = map;
	
	if(dijit.byId('legendSection') == null) {
		legend = new esri.dijit.Legend({
				map : map,
				layerInfos : [/*{title: "Marine Cadastre", layer: ly2},*/ {title: "Local Data", layer: ly1}],
				useAllMapLayers : true
			}, "legendSection");
	}

	legend.startup();
	
	for(var j = 0 ; j < map.layerIds.length; j++ ) {
		var lyr = map.getLayer(map.layerIds[j]);

		//if(j == 0) continue;
		
		var infos = lyr.layerInfos, info;
		var items = [];
		
		var section = dojo.create("h3",
			{ innerHTML: (lyr.url.indexOf("carto") == -1)? "Other Layers" : "Georgia Tech - Carto" } );

		/*new dijit.TitlePane( {
			title: (lyr.url.indexOf("carto") == -1)? "Marine Cadastre Layers" : "Georgia Tech - Carto",
			open: true,
			id: j+"_titlePane"
		});*/
		
		layerTitlePane.containerNode.appendChild(section);
				
		var lastParent = [];
		var lastParentIds = [];
			
		for (var i=0, il=infos.length; i<il; i++) {
			info = infos[i];
			
			if(lastParent != null && lastParent.length > 0) {
				while(lastParentIds.length > 0) {
					var last_parent_index = lastParentIds.pop();
					
					/*console.debug(lastParentIds);
					console.debug(info.parentLayerId);
					console.debug(info.parentLayerId == last_parent_index);*/
					
					if(last_parent_index == info.parentLayerId) {
//						lastParent.push(lastLastParent);
						lastParentIds.push(last_parent_index);
						break;
					}
					else {
						lastParent.pop();
					}
				}
			}

			//console.debug(lastParentIds);
			if(info.subLayerIds != null) {
				var newParent = new dijit.TitlePane({
					title: info.name,
					open: false,
					id: info.name +"_titlePane"
				});
				
			//	var newParent = my.Widget.adopt(dojo.getObject(""),
				//	{
					//});
				//my.Widget._addItem(newParent);
				layerTitlePane._supportingWidgets.push(newParent);
				
				lastParentIds.push(info.id);

				if(lastParent != null && lastParent.length > 0) {
					var lastLastParent = lastParent.pop();
					lastLastParent.containerNode.appendChild(newParent.domNode);
					lastParent.push(lastLastParent);
				}
				else {
					layerTitlePane.containerNode.appendChild(newParent.domNode);
					lastParent = [];
				}
				
				lastParent.push(newParent);

//				if(lastParent != null && lastSubIds != null) {
//					var lastParent2 = new dijit.TitlePane( {
//						title: info.name,
//						id: info.name +"_ctntPane"/*,
//						content: "<h3>"+info.name+"</h3>"*/
//					});
					
//					lastParent.containerNode.appendChild(lastParent2.domNode);
//
//					lastParent = lastParent2;
//				}
//				else {
//					lastSubIds = info.subLayerIds;
//					lastParent = new dijit.TitlePane( {
//						title: info.name,
//						open: false,
//						id: info.name +"_titlePane"
//					});
//					layerTitlePane.containerNode.appendChild(lastParent.domNode);
//				}
				continue;
			}
			
			var tbl = dojo.create('table', {} );
			
			//if(false) {
			//}
			//else {
//				console.debug("IAMHERE");
//				console.debug("legendSection_" + map.layerIds[j] + "_" + i.toString());
				
//				var b = dojo.byId("legendSection_" + map.layerIds[j] + "_" + i.toString());
//				console.debug(b);
//				if(b != null) {
//					b.insertBefore(tbl);
//				}
			//}

			var trrow = dojo.create('tr' , {} );
			var tdcheck = dojo.create('td', {} );
			var tdtitle = dojo.create('td', {} );
			
			var cbox = new dijit.form.CheckBox({
				
				name: map.layerIds[j] + "_" + info.id + "_CheckBox",
				checked: info.defaultVisibility,
				onChange: updateLayerVisibility,
				mapLyrId : map.layerIds[j], lyrId: info.id
				});
				
			layerTitlePane._supportingWidgets.push(cbox);
			
			trrow.appendChild(tdcheck);
			trrow.appendChild(tdtitle);
			
			var layerLink = dojo.create('a', {
				href: '#',
				onClick: "dispLayerInfo(\""+info.name+"\","+info.id+",\""+lyr.url+"\");",
				innerHTML: info.name
			} );
			
			tdcheck.appendChild(cbox.domNode);
			tdtitle.appendChild(layerLink);
			//tdtitle.innerHTML = info.name;
			
			tbl.appendChild(trrow);
			
			if(lastParent == null || lastParent.length == 0) {
				layerTitlePane.containerNode.appendChild(tbl);
			}
			else {
				var lastLastParent = lastParent.pop();
				lastLastParent.containerNode.appendChild(tbl);
				lastParent.push(lastLastParent);
			}
		}
		
		//layerTitlePane.containerNode.appendChild(section.domNode);
	}
	
    //dojo.byId("layer_list").innerHTML = items.join();

    //layer.setVisibleLayers(visible);
    //map.addLayer(layer);
		
	//var layerTitlePane = new dijit.TitlePane( {title: "All Layers", open: false }, "layersSection");
	//var layerContentPane = new dijit.layout.ContentPane( { } , "layersSection" );
	
	/*
	layerTabContainer = new dijit.layout.TabContainer(
		{ tabPosition: "top", useMenu: false, useSlider: false, style: "width: 100%; position: absolute;" }, "layerTabs");
	var allLayers = new dijit.layout.ContentPane(
		{ title : "All Available Layers", selected: true}, "allLayersTab");
	var visibleLayers = new dijit.layout.ContentPane(
		{ title : "Visible Layers"}, "visibleLayersTab");
		
	layerTabContainer.startup();
			
	vldnd = new dojo.dnd.Target("visibleLayersTab", {
		parent: dojo.byId('visibleLayersDnd'),
		creator: visibleLayerItemNodeCreator
	});
	
	dojo.connect(vldnd, "onDrop", refresh_layers);

	for(var j = 0 ; j < map.layerIds.length; j++ ) {
		var lyr = map.getLayer(map.layerIds[j]);
		var vl  = lyr.visibleLayers;
		
		var bArrr = [];
		
		var section = new dijit.TitlePane( { title: lyr.url , open: true, id: j+"_titlePane"} );
		var container = new dijit.layout.ContentPane({title: " ", id: j+"_containerPane"});

		var allDnd = new dojo.dnd.Source(dojo.create('table', {id: j+"_table"}), {
			id: j+"__dnd",
			creator: allLayersItemNodeCreator,
			copyOnly : true,
			selfAccept: false
		});
		
		container.containerNode.appendChild(dojo.create('div', {innerHtml : "Hello" }));
	
		for(var i = 0; i < lyr.layerInfos.length; i++) {
			var aArr = [];
			var li = lyr.layerInfos[i];
			var isVis = (( vl.indexOf(li.id)) != -1 );
			
			//console.debug(j + "   \n   " + i);
			
			if(li.subLayerIds == null) {
				var parent = aArr[li.id] ;
				
				if (parent == null) parent = -1;
				
				allDnd.insertNodes(false, [
					{ name: li.name, lyrIdIndex : j, lyrId: li.id, pid : parent }
					]);
				
				if(isVis) {
					vldnd.insertNodes(false, [
						{ name: li.name, lyrIdIndex : j, lyrId: li.id, pid : parent }
					]);				
				}
			}
			else {
				li.subLayerIds.forEach(function(item, index) {
					aArr[item] = li.id;
				});
			}
		}
		
		container.containerNode.appendChild(allDnd.node);
		section.containerNode.appendChild(container.domNode);
		allLayers.containerNode.appendChild(section.domNode);
	}*/
}

var qry = null;
var a = [];

function updateLayerVisibility (changeValue) {
	console.debug(changeValue);
	console.debug(this);
	
	qry = dojo.query(".dijitChecked", dojo.byId('layersSection'));
	
	a = new Array();
	
	for(var k = 0; k < qry.length; k++) {
		//if(qry[k] == this && changeValue == false) continue;
				
		//console.debug( qry[k] );
		
		var item = dijit.registry.getEnclosingWidget(qry[k]);
		console.debug(item);
		
		if ( a[ item.mapLyrId ] == null ) {
			a[ item.mapLyrId ] = new Array();
		}
		
//		console.debug( a[layerParts[0]] );
		
		a[ item.mapLyrId ].push(item.lyrId);
	}
	
	for(var l in a) {
		console.debug( a[l] );
		
		map.getLayer(l).setVisibleLayers(a[l]);
	}
	
	legend.refresh();
}

function dispLayerInfo(name, id, wurl) {
	var lyrInfoPane = dijit.byId('layerInfoPane');
	
	esri.request(
		{ url : wurl + "/" + id.toString() + "?f=json",
		  handleAs : "json"}).
		then(function(data) {
			var dstring = "<ul>";

			for(item in data) {
				dstring += "<li><b>" + item + "</b>: " + data[item];
			}
			
			dstring += "</ul>";
			
			lyrInfoPane.setContent("<h3>"+name+"</h3><pre>"+dstring+"</pre>");
			dijit.byId('RightTabs').selectChild(dijit.byId('layerInfoPane'));
			toggleIdentifyOn(dijit.byId('RightExPanel'));
		});
}