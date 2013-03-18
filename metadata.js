function dispMetadata(a) {
	//var lyr = map.getLayer(a.mapLayerId);
	var nm = a.name;
	
	console.debug(a);
	
	var args = {
			url: "http://carto.gis.gatech.edu/ViewerJSNew/metadata/" + a.name + ".xml",
			handleAs: "xml",
			load: function(data) {
				var text = data.querySelector("abstract").textContent;
				
				lastMetadata (data.querySelector("abstract").textContent);
				lastMetadataLayerTitle (a.name);
				
				$('#mdtaLink').tab('show');
			},
			error : function () {
				$('#metaError').modal();
			}
	};
	
	esri.request(args);
}