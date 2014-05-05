var format = ko.observable("PDF");
var borderLess = ko.observable();
var paperSize = ko.observable("letter");
var units = ko.observable("pixels");
var shotHeightDisplay = ko.observable(480);
var shotWidthDisplay  = ko.observable(640);
var mapPrintTitle = ko.observable("Geogia Coastal Viewer");
var landscape = ko.observable(false);

var dpi = 150;

require([
	"esri/map", "esri/layers/FeatureLayer", 
	"esri/dijit/Print", "esri/tasks/PrintTemplate", 
	"esri/tasks/LegendLayer",
	"esri/request", "esri/config",
	"dojo/_base/array", "dojo/dom", "dojo/parser",
	"dijit/layout/BorderContainer", "dijit/layout/ContentPane", "dojo/domReady!"
], function(
	Map, FeatureLayer, 
	Print, PrintTemplate, 
	esriRequest, esriConfig,
	arrayUtils, dom, parser
) {
}
);

var printInfo = null;
var printer = null;

var le = null;
//"http://tulip.gis.gatech.edu:6080/arcgis/rest/services/Utilities/PrintingTools/GPServer/Export%20Web%20Map%20Task"
//"http://tulip.gis.gatech.edu:6080/arcgis/rest/services/GACoast/ExportWebMap2_Test/GPServer"

var isChrome = navigator.userAgent.toLowerCase().indexOf('chrome') > -1;
var isSafari = navigator.userAgent.toLowerCase().indexOf('safari') > -1;

function downloadFile(sUrl) {
 
    //If in Chrome or Safari - download via virtual link click
    if ((isChrome || isSafari) && false) {
        //Creating new link node.
        var link = document.createElement('a');
        link.href = sUrl;
 
        if (link.download !== undefined){
            //Set HTML5 download attribute. This will prevent file from opening if supported.
            var fileName = sUrl.substring(sUrl.lastIndexOf('/') + 1, sUrl.length);
            link.download = fileName;
        }
 
        //Dispatching click event.
        if (document.createEvent) {
            var e = document.createEvent('MouseEvents');
            e.initEvent('click' ,true ,true);
            link.dispatchEvent(e);
            return true;
        }
    }
 
    // Force file download (whether supported by server).
    var query = '?download';
    window.open(sUrl + query);
}

function sendPrintJob() {
	printInfo = esri.request(({
		"url" : "http://tulip.gis.gatech.edu:6080/arcgis/rest/services/GACoast/AdvancedPrinting/GPServer/AdvancedPrinting",
		"content" : {"f" : "json" }
	}));
	
	printInfo.then(function(r) {
		var ptemplate = new esri.tasks.PrintTemplate();	
		
		if(format() == "PDF" || !borderLess()) {
			switch(paperSize()) {
				case "letter": (landscape())? ptemplate.layout = "Letter ANSI A Landscape" : ptemplate.layout = "Letter ANSI A Portrait" ;
//				shotWidthDisplay(11 * dpi); shotHeightDisplay(8.5 * dpi);break;
				case "ledger": (landscape())? ptemplate.layout = "Tabloid ANSI B Landscape": ptemplate.layout = "Tabloid ANSI B Portrait";
//				shotWidthDisplay(17 * dpi); shotHeightDisplay(11 * dpi); break;
				case "A3":	   (landscape())? ptemplate.layout = "A3 Landscape": ptemplate.layout = "A3 Portrait";
//				shotWidthDisplay(16.54 * dpi); shotHeightDisplay(11.69 * dpi); break;
				case "A4":	   (landscape())? ptemplate.layout = "A4 Landscape": ptemplate.layout = "A4 Portrait";
//				shotWidthDisplay(11.69 * dpi); shotHeightDisplay( 8.27 * dpi); break;
			}
		}
		else {
			ptemplate.layout = "MAP_ONLY";
			
			if(format() == "PDF") {
				switch(paperSize()) {
					case "letter": shotWidthDisplay(11 * dpi); shotHeightDisplay(8.5 * dpi);break;
					case "ledger": shotWidthDisplay(17 * dpi); shotHeightDisplay(11 * dpi); break;
					case "A3":	   shotWidthDisplay(16.54 * dpi); shotHeightDisplay(11.69 * dpi); break;
					case "A4":	   shotWidthDisplay(11.69 * dpi); shotHeightDisplay( 8.27 * dpi); break;
				}
			}
			
			ptemplate.exportOptions = {
				"width":	shotWidthDisplay(),
				"height":	shotHeightDisplay(),
				"dpi":		dpi
			};
		}
				
		var llayers = new esri.tasks.LegendLayer();
		llayers.legendId = map.layerIds[3];
		llayers.subLayerIds = map.getLayer(map.layerIds[3] ).visibleLayers;
			
		ptemplate.layoutOptions = { "legendLayers" : null, titleText: mapPrintTitle() };
		
		console.debug( ptemplate.exportOptions );
		
		ptemplate.format = format();
		ptemplate.label  = mapPrintTitle();
		
		var pparams = new esri.tasks.PrintParameters();
		pparams.map = map;
		pparams.template = ptemplate;
		
		var pt = new esri.tasks.PrintTask( "http://tulip.gis.gatech.edu:6080/arcgis/rest/services/Utilities/PrintingTools/GPServer/Export%20Web%20Map%20Task" );
		pt.execute(pparams, function(rr) {
			console.debug(rr);
			downloadFile(rr.url);
			printDlgCancel();
		});
	});
}

function printDlgCancel() {
	$('#printing-popover').hide();
}