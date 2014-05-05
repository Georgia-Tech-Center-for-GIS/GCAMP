/**
@file Retrieves and displays layer metadata
*/

/**
	Sends metadata request to service
	@param a specifies which layer to process request
*/
function dispMetadata(a) {
	//var lyr = map.getLayer(a.mapLayerId);
	var nm = a.name;
	
	console.debug(a);
	
	var args = {
			url: "http://carto.gis.gatech.edu/ViewerJSNew/metadata/" + a.name + ".xml",
			handleAs: "xml",
			load: function(data) {
			
				var abstractText = data.querySelector("abstract").textContent;
				var purposeText = data.querySelector("purpose").textContent;
				var supplinf = data.querySelector("supplinf").textContent;
				
				var links = data.querySelector("onlink").textContent;
				
				lastMetadataAbstract (abstractText);
				lastMetadataPurpose (purposeText);
				lastMetadataLinks ( links );
				lastMetadataLayerTitle (a.name);
				
				$('#mdtaLink').tab('show');
			},
			error : function () {
				$('#metaError').modal();
			}
	};
	
	esri.request(args);
}