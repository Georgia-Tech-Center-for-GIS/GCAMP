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
	
	lastMetadataLayerTitle (a.name);
	lastMetadataLinkURL ("http://carto.gis.gatech.edu/GCAMP/metadata/" + a.name + ".pdf");

	//var url = "/GCAMP/GCAMPdatalist514.xlsx";

	var args = {
			url: "http://carto.gis.gatech.edu/GCAMP/GCAMPmetadata.csv",
			handleAs: "text",
			load: function(data) {
				var lines = data.split("\n");
				
				dojo.forEach(lines, function(ln) {
					var fields = ln.split(",");
					
					if( fields[0] == lastMetadataLayerTitle() ) {
						fields.splice(1, 1);
						lastMetadataAbstract( fields.join(',') );
					}
					
					$('#mdtaLink').tab('show');
				});
			},
			error : function () {
				$('#metaError').dialog({
					modal: true,
					buttons: {
						"Ok": function() {
							$(this).dialog("close");
						}
					}
				});
			}
	};
	
	esri.request(args);
}