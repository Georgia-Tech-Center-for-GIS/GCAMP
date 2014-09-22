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

	var url = "/GCAMP/GCAMPdatalist514.xlsx";

	var args = {
			url: "GCAMPmetadata.csv",
			handleAs: "text",
			load: function(data) {
				var lines = data.split("\n");
				
				dojo.foreach(lines, function(ln) {
					var fields = ln.split(",");
				});
			
				$('#mdtaLink').tab('show');
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