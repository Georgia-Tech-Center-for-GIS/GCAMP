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
			url: "http://carto.gis.gatech.edu/GCAMP/metadata/" + a.name + ".xml",
			handleAs: "xml",
			load: function(data) {
			
				try {
					lastMetadataLayerTitle (a.name);
					
					var abstractText = data.querySelector("abstract").textContent;
					lastMetadataAbstract (abstractText);
				}
				catch(e) {}
				try {
					var purposeText = data.querySelector("purpose").textContent;
					lastMetadataPurpose (purposeText);
				}
				catch(e) {}
				
				try{
					var links = data.querySelector("onlink").textContent;
					lastMetadataLinks ( links );
					
					var supplinf = data.querySelector("supplinf").textContent;
				}
				catch(e) {
				}
				
				$('#mdtaLink').tab('show');
			},
			error : function () {
				$('#metaError').modal();
			}
	};
	
	esri.request(args);
}