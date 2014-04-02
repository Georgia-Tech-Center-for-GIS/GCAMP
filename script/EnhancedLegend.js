//////////////////////***************************//////////////////////
// Dijit: EnhancedLegend control
// 
// Developer: David Hollema
// 
// Company: Natural Resource Stewardship and Science, National Park Service
// 
// Location: Fort Collins, CO
// 
// Purpose: Builds upon ESRI JavaScript v2.8 Legend Control to allow for 
// legend display of image service layers which include a colormap and optionally
// raster attribute table (hasColormap and hasAttributeTable are true).  This control is intended 
// for use with ArcGIS Server 10.1 (currently pre-release).
// 
// Limitations: This dijit has been tested in Firefox, Chrome, IE7, IE8 and IE9.  Legend image patches are generated 
// using the HTML5 canvas element which is not available in IE7 or IE8.  For those older browsers, the fxcanvas library is
// used which requires Adobe Flash Player 9+. 
//
//	To use with IE8 or earlier, place the following html in the head of your main page.
//	<!--[if lt IE 9]>
//		<script type="text/javascript" src="pathTofxcanvas/jooscript.js"></script>
//		<script type="text/javascript" src="pathTofxcanvas/fxcanvas.js"></script>
//		<script type="text/javascript" src="pathTofxcanvas/flash_backend.js"></script>
//		<comment><script type="text/javascript" src="pathTofxcanvas/canvas_backend.js"></script></comment>
//	<![endif]-->
//
//	For more detailed help, visit http://code.google.com/p/fxcanvas/.
//
//
// Example:  Follow the ESRI JavaScript API documentation to create a legend dijit.  By specifying
// a layerInfos array, it's possible to further control the display of legend items associated
// with an image service by using a custom layerInfo object given below for the imageServiceLayer.
//
// "rasterAttributeTableInfo" is optional and gives the ability to provide a description 
// for a given color value based on the categoryField of the raster attribute table of the service.
// For example, a color patch with value 3 (generated from the colormap) will be given description 'RARE' if the value 'RARE' 
// appears in the raster attribute table in the specified "categoryField" and the specified 
// "valueField" value equals 3.

// How to create an image service with discrete data that has a colormap and raster attribute table.
// 1) Create a file geodatabase.
// 2) Create a mosaic dataset within the file geodatabase.  Within the Pixel Properties settings,
//    set Number of Bands to 1.  If number of bands is not set to 1, the mosaic dataset will automatically
//    set number of bands to 3 upon adding a single band raster with colormap symbology.  The 3 bands correspond to
//    RGB.  With a 3 band mosaic dataset, symbology of the original rasters is preserved but it is not
//	  possible to provide the mosaic dataset with a colormap nor a raster attribute table so any legend creation
//    possibility is lost.  Therefore setting Number of Bands to 1 is required.
// 3) Add rasters to mosaic dataset.
// 4) Go to mosaic dataset properties and Function tab.  Right-click on mosaic function and add the Colormap
//    function.  For the colormap choose your predefined .clr file which represents your desired symbology.
//    Right-click the colormap function and add the Attribute table function.  For attribute table source,
//    Choose a raster file which contains a raster attribute table that is representative of the colormaps
//    for all rasters.
// 5) Right-click mosaic dataset and Share as Image Service.  In the functions area of the service
//    definition, make sure to UNCHECK 'Convert to RGB' or you will lose the colormap and attribute table.
//    Again, only a single band mosaic dataset/image service supports the colormap and attribute table.
//
// var legend = new nrss.dijit.EnhancedLegend({
//			  layerInfos: [
//				{
//					layer: populationDensity,
//					title: "Population Density Total"
//				},
//				  {
//					layer: imageServiceLayer,
//					title: "Forest Density",	
//					subTitle: "Forest Density for ROMO",
//					rasterAttributeTableInfo: {
//						valueField: "Value",
//						categoryField: "CLASSNAME",
//						legendItemDescription: "units/unit",
//						groupValuesByCategory: true,
//						sortFunction: function(a,b){
//							return b.values - a.values;
//						}
//					}
//				  },
//				  {
//					layer: parkBounds,
//					title: "Park Boundaries"
//				  }
//				],
//			  map:map
//			},"legendDiv");
//			legend.startup();	

		
//////////////////////***************************//////////////////////

if (!dojo._hasResource["nrss.dijit.EnhancedLegend"]) {
    dojo._hasResource["nrss.dijit.EnhancedLegend"] = true;
    dojo.provide("nrss.dijit.EnhancedLegend");
    dojo.require("esri.dijit.Legend");    
    (function () {
        var _1 = [dojo.moduleUrl("nrss.dijit", "css/EnhancedLegend.css")];
        var _2 = document.getElementsByTagName("head").item(0),
            _3;
        for (var i = 0, il = _1.length; i < il; i++) {
            _3 = document.createElement("link");
            _3.type = "text/css";
            _3.rel = "stylesheet";
            _3.href = _1[i].toString();
            _2.appendChild(_3);
        }
    }());
    dojo.declare("nrss.dijit.EnhancedLegend", [dijit._Widget], {
		widgetsInTemplate: false,
        layers: null,
        alignRight: false,
        _ieTimer: 100,
        constructor: function (params, srcNodeRef) {
            dojo.mixin(this, esri.bundle.widgets.legend);
            params = params || {};
            if (!params.map) {
                console.error("esri.dijit.Legend: unable to find the 'map' property in parameters");
                return;
            }
            if (!srcNodeRef) {
                console.error("esri.dijit.Legend: must specify a container for the legend");
                return;
            }
            this.map = params.map;
            this.layerInfos = params.layerInfos;
            this._respectCurrentMapScale = (params.respectCurrentMapScale === false) ? false : true;
            this.arrangement = (params.arrangement === esri.dijit.Legend.ALIGN_RIGHT) ? esri.dijit.Legend.ALIGN_RIGHT : esri.dijit.Legend.ALIGN_LEFT;
            if (this.arrangement === esri.dijit.Legend.ALIGN_RIGHT) {
                this.alignRight = true;
            }
            this._surfaceItems = [];
        },
        startup: function () {
            this.inherited(arguments);
            this._initialize();
            if (dojo.isIE) {
                this._repaintItems = dojo.hitch(this, this._repaintItems);
                setTimeout(this._repaintItems, this._ieTimer);
            }
        },
        destroy: function () {
            this._deactivate();
            this.inherited(arguments);
        },
        refresh: function (layerInfos) {
            if (!this.domNode) {
                return;
            }
            if (layerInfos) {
                this.layerInfos = layerInfos;
                this.layers = [];
                dojo.forEach(this.layerInfos, function (layerInfo) {
                    if (this._isSupportedLayerType(layerInfo.layer)) {
                        if (layerInfo.title) {
                            layerInfo.layer._titleForLegend = layerInfo.title;
                        }
                        this.layers.push(layerInfo.layer);
                    }
                }, this);
            } else {
                if (this.useAllMapLayers) {
                    this.layerInfos = null;
                    this.layers = null;
                }
            }
            for (var i = this.domNode.children.length - 1; i >= 0; i--) {
                dojo.destroy(this.domNode.children[i]);
            }
            this.startup();
        },
        _legendUrl: "http://utility.arcgis.com/sharing/tools/legend",
        _initialize: function () {
            if (this.layerInfos) {
                this.layers = [];
                dojo.forEach(this.layerInfos, function (layerInfo) {
                    if (this._isSupportedLayerType(layerInfo.layer)) {
                        if (layerInfo.title) {
                            layerInfo.layer._titleForLegend = layerInfo.title;
                        }
                        this.layers.push(layerInfo.layer);
                    }
                }, this);
            }
            this.useAllMapLayers = false;
            if (!this.layers) {
                this.useAllMapLayers = true;
                this.layers = [];
                var _9 = [];
                dojo.forEach(this.map.layerIds, function (_a) {
                    var _b = this.map.getLayer(_a);
                    if (this._isSupportedLayerType(_b)) {
                        if (_b.arcgisProps && _b.arcgisProps.title) {
                            _b._titleForLegend = _b.arcgisProps.title;
                        }
                        this.layers.push(_b);
                    }
                    if (_b.declaredClass == "esri.layers.KMLLayer") {
                        dojo.forEach(_b.getLayers(), function (_c) {
                            _9.push(_c.id);
                        }, this);
                    }
                }, this);
                dojo.forEach(this.map.graphicsLayerIds, function (_d) {
                    var _e = this.map.getLayer(_d);
                    if (dojo.indexOf(_9, _d) == -1) {
                        if (this._isSupportedLayerType(_e) && _e._params && _e._params.drawMode) {
                            if (_e.arcgisProps && _e.arcgisProps.title) {
                                _e._titleForLegend = _e.arcgisProps.title;
                            }
                            this.layers.push(_e);
                        }
                    }
                }, this);
            }
            this._createLegend();
        },
        _activate: function () {
            this._deactivate();
            if (this._respectCurrentMapScale) {
                this._ozeConnect = dojo.connect(this.map, "onZoomEnd", this, "_refreshLayers");
            }
            if (this.useAllMapLayers) {
                this._olaConnect = dojo.connect(this.map, "onLayerAdd", this, "_updateAllMapLayers");
                this._olrConnect = dojo.connect(this.map, "onLayerRemove", this, "_updateAllMapLayers");
                this._olroConnect = dojo.connect(this.map, "onLayersReordered", this, "_updateAllMapLayers");
            }
            dojo.forEach(this.layers, function (_f) {
                _f.ovcConnect = dojo.connect(_f, "onVisibilityChange", this, "_refreshLayers");
                if (_f.declaredClass === "esri.layers.ArcGISDynamicMapServiceLayer" && _f.supportsDynamicLayers) {
                    _f.odcConnect = dojo.connect(_f, "_onDynamicLayersChange", this, "_updateDynamicLayers");
                }
            }, this);
        },
        _deactivate: function () {
            if (this._ozeConnect) {
                dojo.disconnect(this._ozeConnect);
            }
            if (this._olaConnect) {
                dojo.disconnect(this._olaConnect);
            }
            if (this._olroConnect) {
                dojo.disconnect(this._olroConnect);
            }
            if (this._olrConnect) {
                dojo.disconnect(this._olrConnect);
            }
            dojo.forEach(this.layers, function (_10) {
                if (_10.ovcConnect) {
                    dojo.disconnect(_10.ovcConnect);
                }
                if (_10.odcConnect) {
                    dojo.disconnect(_10.odcConnect);
                }
            }, this);
        },
        _updateDynamicLayers: function () {
            this._dynamicLayerChanged = true;
            this._refreshLayers();
        },
        _refreshLayers: function () {
            this.refresh();
        },
        _updateAllMapLayers: function () {
            this.layers = [];
            dojo.forEach(this.map.layerIds, function (_11) {
                var _12 = this.map.getLayer(_11);
                if (this._isSupportedLayerType(_12)) {
                    this.layers.push(_12);
                }
            }, this);
            dojo.forEach(this.map.graphicsLayerIds, function (_13) {
                var _14 = this.map.getLayer(_13);
                if (this._isSupportedLayerType(_14) && _14._params && _14._params.drawMode) {
                    this.layers.push(_14);
                }
            }, this);
            this.refresh();
        },
        _createLegend: function () {
            dojo.style(this.domNode, "position", "relative");
            dojo.create("div", {
                id: this.id + "_msg",
                innerHTML: this.NLS_creatingLegend + "..."
            }, this.domNode);
            var candidateLayers = [];
            dojo.forEach(this.layers, function (layer) {
                if (layer.declaredClass == "esri.layers.KMLLayer") {
                    dojo.forEach(layer.getLayers(), function (kmlSubLayers) {
                        if (kmlSubLayers.declaredClass == "esri.layers.FeatureLayer" && layer._titleForLegend) {
                            kmlSubLayers._titleForLegend = layer._titleForLegend + " - ";
                            if (kmlSubLayers.geometryType == "esriGeometryPoint") {
                                kmlSubLayers._titleForLegend += "Points";
                            } else {
                                if (kmlSubLayers.geometryType == "esriGeometryPolyline") {
                                    kmlSubLayers._titleForLegend += "Lines";
                                } else {
                                    if (kmlSubLayers.geometryType == "esriGeometryPolygon") {
                                        kmlSubLayers._titleForLegend += "Polygons";
                                    }
                                }
                            }
                            candidateLayers.push(kmlSubLayers);
                        }
                    });
                } else {
                    candidateLayers.push(layer);
                }
            }, this);
            var refinedCandidateLayers = [];
            dojo.forEach(candidateLayers, function (layer) {                
				switch (layer.declaredClass)
				{
					case "esri.layers.ArcGISImageServiceLayer":
					{
						if (layer.visible === true && layer.hasColormap === true){
							this._createLegendGrid(layer);
							if (layer.legendResponse) {
								this._createLegendForLayer(layer);
								console.log("Image service legend already fetched.");
							}
							else {				
								//need to wait on legend request from service endpoint and also the legend item
								//creation process which is ansynchronous when using fxcanvas
								var deferred = this._legendRequest(layer).then(dojo.hitch(this, function(resp){
									return this._createImageServerLegendItems(layer, layer.colormap);
								})).then(dojo.hitch(this, function(legendItems){
									//sort the legend items according to sort function								
									var layerInfo = dojo.filter(this.layerInfos, function(layerInfo){
										return layerInfo.layer === layer;
									})[0];
									if (layerInfo && layerInfo.rasterAttributeTableInfo.sortFunction){
										try {
											legendItems.sort(layerInfo.rasterAttributeTableInfo.sortFunction);
										}
										catch (e){
											console.error("Error in sorting legend items. " + e);
										}
									}
									layer.legendResponse = this._convertColormapToLegend(legendItems);
									this._createLegendForLayer(layer);																			
								}));
								refinedCandidateLayers.push(deferred);
							}								
						}
						break;
					}						
					default:
					{
						if (layer.visible === true && (layer.layerInfos || layer.renderer)) {
							this._createLegendGrid(layer);
							if ((layer.legendResponse || layer.renderer) && !this._dynamicLayerChanged) {
								this._createLegendForLayer(layer);
							} else {
								refinedCandidateLayers.push(this._legendRequest(layer));
							}
							this._dynamicLayerChanged = false;
						}
						break;
					}
				}				
            }, this);

            if (refinedCandidateLayers.length === 0) 
			{
                dojo.byId(this.id + "_msg").innerHTML = this.NLS_noLegend;
                this._activate();
            } 
			else 
			{
                var _1a = new dojo.DeferredList(refinedCandidateLayers);
                _1a.addCallback(dojo.hitch(this, function (_1b) {
                    dojo.byId(this.id + "_msg").innerHTML = this.NLS_noLegend;
                    this._activate();
                }));
            }
        },
		_createLegendGrid: function(layer){
			var d = dojo.create("div", {
				id: this.id + "_" + layer.id,				
				style: "display: none;",
				"class": "esriLegendService"
			});
			dojo.create("span", {
				innerHTML: this._getServiceTitle(layer),
				"class": "esriLegendServiceLabel"
			}, dojo.create("td", {
				align: (this.alignRight ? "right" : "")
			}, dojo.create("tr", {}, dojo.create("tbody", {}, dojo.create("table", {
				width: "95%"
			}, d)))));
			dojo.place(d, this.id, "first");
			if (dojo.isIE) {
				dojo.style(dojo.byId(this.id + "_" + layer.id), "display", "none");
			}
		},
        _createLegendForLayer: function (layer) {
            if (layer.legendResponse || layer.renderer) {
                var _1d = false;
                if (layer.legendResponse) {
                    dojo.forEach(layer.layerInfos, function (_1e, i) {
                        var f = this._buildLegendItems(layer, _1e, i);
                        _1d = _1d || f;
                    }, this);
                } else {
                    if (layer.renderer) {
                        var id;
                        if (!layer.url) {
                            id = "fc_" + layer.id;
                        } else {
                            id = layer.url.substring(layer.url.lastIndexOf("/") + 1, layer.url.length);
                        }
                        var _1f = {
                            id: id,
                            name: null,
                            subLayerIds: null,
                            parentLayerId: -1
                        };
                        _1d = this._buildLegendItems(layer, _1f, 0);
                    }
                }
                if (_1d) {
                    dojo.style(dojo.byId(this.id + "_" + layer.id), "display", "block");
                    dojo.style(dojo.byId(this.id + "_msg"), "display", "none");
                }
            }
        },
        _legendRequest: function (layer) {
            if (!layer.loaded) {
                dojo.connect(layer, "onLoad", dojo.hitch(this, "_legendRequest"));
                return;
            }			
            //handle image services separately
			if (layer.declaredClass === "esri.layers.ArcGISImageServiceLayer"){
				if (layer.version >= 10.1){
					var layerInfo = this._getLayerInfoForLayer(layer);
					if (layerInfo && layerInfo.rasterAttributeTableInfo){
						return new dojo.DeferredList([this._legendRequestImageServer(layer), this._rasterAttributeTableRequestServer(layer)]);
					}
					return this._legendRequestImageServer(layer);
				}
			}
			else if (layer.version >= 10.01) {
                return this._legendRequestServer(layer);
            } else {
                return this._legendRequestTools(layer);
            }
        },
		_getLayerInfoForLayer: function (layer) {
			var layerInfo;
			if (this.layerInfos){
				var layerInfo = dojo.filter(this.layerInfos, function(layerInfo){
					return layerInfo.layer.id === layer.id;
				})[0];
			}
			return layerInfo;
		},
		//fetch colormap from image server, post 10.1
		_legendRequestImageServer: function (layer) {
			var url = layer.url + "/colormap";
			var requestObj = {};
            requestObj.f = "json";
			
			var processLegendResponse = dojo.hitch(this, "_processImageServerLegendResponse");
			var deferred = esri.request({
                url: url,
                content: requestObj,
                callbackParamName: "callback",
                load: function (resp) {
                    processLegendResponse(layer, resp);
                },
                error: esriConfig.defaults.io.errorHandler
            });
            return deferred;
		},
		//fetch attribute table if provided
		_rasterAttributeTableRequestServer: function (layer) {
			var deferred = new dojo.Deferred();
			var layerInfo = this._getLayerInfoForLayer(layer);
			if (layerInfo && layerInfo.rasterAttributeTableInfo){
				var url = layer.url + "/rasterattributetable";
				var requestObj = {};
				requestObj.f = "json";
				
				var processAttributeTableResponse = dojo.hitch(this, "_processRasterAttributeTableResponse");
				deferred = esri.request({
					url: url,
					content: requestObj,
					callbackParamName: "callback",
					load: function (resp) {
						processAttributeTableResponse(layer, resp);
					},
					error: esriConfig.defaults.io.errorHandler
				});
			}
			return deferred;
		},
		//legend from arcgis server REST API, post 10.01
        _legendRequestServer: function (layer) {
            var url = layer.url;
            var pos = url.indexOf("?");
            if (pos > -1) {
                url = url.substring(0, pos) + "/legend" + url.substring(pos);
            } else {
                url += "/legend";
            }
            var processLegendResponse = dojo.hitch(this, "_processLegendResponse");
            var requestObj = {};
            requestObj.f = "json";
            if (layer._params.dynamicLayers) {
                requestObj.dynamicLayers = layer._params.dynamicLayers;
                if (requestObj.dynamicLayers === "[{}]") {
                    requestObj.dynamicLayers = "[]";
                }
            }
            var deferred = esri.request({
                url: url,
                content: requestObj,
                callbackParamName: "callback",
                load: function (resp, b) {
                    processLegendResponse(layer, resp, b);
                },
                error: esriConfig.defaults.io.errorHandler
            });
            return deferred;
        },
		//arcgis.com legend service
        _legendRequestTools: function (_27) {
            var p = _27.url.toLowerCase().indexOf("/rest/");
            var _28 = _27.url.substring(0, p) + _27.url.substring(p + 5, _27.url.length);
            var url = this._legendUrl + "?soapUrl=" + escape(_28);
            if (!dojo.isIE) {
                url += "&returnbytes=true";
            }
            var _29 = dojo.hitch(this, "_processLegendResponse");
            var _2a = {};
            _2a.f = "json";
            var _2b = esri.request({
                url: url,
                content: _2a,
                callbackParamName: "callback",
                load: function (_2c, _2d) {
                    _29(_27, _2c, _2d);
                },
                error: esriConfig.defaults.io.errorHandler
            });
            return _2b;
        },
        _processLegendResponse: function (layer, resp) {
            if (resp && resp.layers) {
                layer.legendResponse = resp;
                this._createLegendForLayer(layer);
            } else {
                console.log("Legend could not get generated for " + layer.url + ": " + dojo.toJson(resp));
            }
        },
		_processImageServerLegendResponse: function (layer, resp) {
            if (resp) {
                this._disguiseImageServiceLayerAsMapServiceLayer(layer);
				layer.colormap = resp.colormap;
            } else {
                console.log("Legend could not get generated for " + layer.url + ": " + dojo.toJson(resp));
            }
        },
		_processRasterAttributeTableResponse: function (layer, resp) {
			if (resp){
				layer.ratResponse = resp;				
			} else {
                console.log("Raster attribute table info could not be retrieved for " + layerInfo.layer.url + ": " + dojo.toJson(resp));
            }
		},
		_convertColormapToLegend: function(legendItems) {		
			var legend = {
				layers: [{
					layerId: 0,
					layerName: "This value is not used!",
					layerType: "Image Service Layer",
					legend: legendItems
				}]
			};			
			return legend;			
		},				
		_createImageServerLegendItems: function (layer, colormap){
			var deferred = new dojo.Deferred();
			
			//read any category information from raster attribute table
			var ratInfo;
			if (layer.ratResponse){
				ratInfo = this._getLayerInfoForLayer(layer).rasterAttributeTableInfo;				
			}			
			var legendItems = [];			
			var labelSuffix = "";
			var groups = null;
			if (ratInfo){
				var legendItemDescription = (ratInfo.legendItemDescription) ? ratInfo.legendItemDescription: "";
				labelSuffix = (legendItemDescription) ? " " + legendItemDescription : "";
				
				//group by category field
				if (ratInfo.groupValuesByCategory === true && ratInfo.valueField && ratInfo.categoryField){
					groups = this._groupColormapValues(colormap, layer, ratInfo);
					this._collapseColormapIntoGroups(colormap, groups);
				}					
			}
			
			try {
				//IE browsers older than IE9, asynchronous when using fxcanvas
				if (dojo.isIE < 9) {
					var colorValueCount = colormap.length;
					dojo.forEach(colormap, function (colorValue){
						encodePatchBase64({r:colorValue[1], g:colorValue[2], b:colorValue[3]}, function(base64Img){
							legendItems.push(getLegendItem(base64Img,colorValue,ratInfo));
							colorValueCount--;
							if (colorValueCount === 0){
								deferred.callback(legendItems);
							}
						});
					});
				}
				//IE9 or non-IE browsers, synchronous model
				else {
					dojo.forEach(colormap, function (colorValue){
						var base64Img = encodePatchBase64({r:colorValue[1], g:colorValue[2], b:colorValue[3]}); //.then(function(base64img){
						legendItems.push(getLegendItem(base64Img,colorValue,ratInfo));
					});
					deferred.callback(legendItems);
				}
			}
			catch(err){
				console.error(err);
			}			
			return deferred;

			function getLegendItem(base64Img, colorValue, ratInfo){
				var label = patchValues = colorValue[0].toString();							
				
				if (ratInfo && ratInfo.valueField && ratInfo.categoryField){									
					var colorValueFeature = dojo.filter(layer.ratResponse.features, function(ratFeature){
						return ratFeature.attributes[ratInfo.valueField] === colorValue[0];
					})[0];
					if (colorValueFeature){					
						//for groups, show comma separated values if more than one
						if (ratInfo.groupValuesByCategory === true){
							var matchedGroup = dojo.filter(groups, function(group) {
								return group.categoryValue === colorValueFeature.attributes[ratInfo.categoryField];
							})[0];
							patchValues = matchedGroup.values.join();
						}
						label = colorValueFeature.attributes[ratInfo.categoryField] + " (" + patchValues + labelSuffix + ")";
					} else {
						console.log("Colormap value " + colorValue[0].toString() + " contains no corresponding raster attribute table entry.");
					}	
				}										
				else {
					label += labelSuffix;
				}
				
				return {
					contentType: "image/png",
					imageData: base64Img,
					values: patchValues,
					label: label
				};				
			}
			
			var canvas = null, colors = {};
			
			// use canvas to get a base64 encoded string of the image								
			function encodePatchBase64(colors, callback) { 
				canvas = document.createElement('canvas'); // create a temporary canvas element
				canvas.width = 20;
				canvas.height = 20;
				var context = canvas.getContext('2d'); // get the context for the canvas element
				context.fillStyle = "rgb(" + [colors.r,colors.g,colors.b].join() + ")";  				
				context.fillRect (0, 0, 20, 20);  
				
				//should only load for IE versions less than 9				
				if (dojo.isIE < 9) {										
					document.body.appendChild(canvas);
					canvas.toDataURL('image/png', callback);					
				}
				else {						
					return canvas.toDataURL('image/png'); // and return the base64 encoded data url of the complete canvas
				}
			}
		},		
		_groupColormapValues: function(colormap, layer, ratInfo){
			//find all features from raster attribute table with common category field value
			var groupedRATFeatures = [];				
			
			//loop through all features in raster attribute table.
			dojo.forEach(layer.ratResponse.features, function(groupByFeature){					
				var categoryValue = groupByFeature.attributes[ratInfo.categoryField];
				
				//make sure this category hasn't already been processed
				var processedCategories = dojo.map(groupedRATFeatures, "return item.categoryValue");
				var hasCategoryBeenProcessed = dojo.some(processedCategories, function(processedCategory){
					return processedCategory === categoryValue;
				});
				
				//if this category hasn't been processed, add the category name and participating values
				if (!hasCategoryBeenProcessed){
					//get all the features from the rasterattributetable within the current category
					var group = dojo.filter(layer.ratResponse.features, function(feature){
						return feature.attributes[ratInfo.categoryField] === categoryValue;
					});
					//just get the value
					var values = dojo.map(group, function(item){
						return item.attributes[ratInfo.valueField];
					});
					groupedRATFeatures.push({
						categoryValue: categoryValue, 
						values: values
					});
				}					
			});		
			
			return groupedRATFeatures;
		},
		_collapseColormapIntoGroups: function(colormap, groups){
			//clone groups array to leave original intact with all values because we will be decrementing the first value
			var groupsClone = dojo.clone(groups, "return item;");
			
			//remove items from the colormap to leave only those with the minimum value for a given category				
			dojo.forEach(groupsClone, function(group){
				group.values.splice(0,1);
			});
			var colormapValues = dojo.map(colormap, "return item[0]");
			dojo.forEach(groupsClone, function(group){
				dojo.forEach(group.values, function(value){
					var idx = dojo.indexOf(colormapValues, value);
					if (idx != -1){
						colormap.splice(idx,1);
						colormapValues.splice(idx,1);
					}
				});
			});
		},
		_disguiseImageServiceLayerAsMapServiceLayer: function(layer){
			var layerInfo = dojo.filter(this.layerInfos, function(layerInfo){
				return layerInfo.layer === layer;
			})[0];
			
			var subTitle = "";
			if (layerInfo){
				subTitle = (layerInfo.subTitle) ? layerInfo.subTitle : "";
			}
			
			layer.layerInfos = [
				{
					defaultVisibility: true,
					id: 0,
					maxScale: 0,
					minScale: 0,
					name: subTitle, //use subtitle if available
					parentLayerId: -1,
					subLayerIds: null					
				}
			];
			layer.visibleLayers = [0];
		},
        _buildLegendItems: function (layer, layerInfo, pos) {
            var _32 = false;
            var _33 = dojo.byId(this.id + "_" + layer.id);
            var _34 = layerInfo.subLayerIds;
            var _35 = layerInfo.parentLayerId;
            if (_34) {
                var _36 = dojo.create("div", {
                    id: this.id + "_" + layer.id + "_" + layerInfo.id + "_group",
                    style: "display: none;",
                    "class": (_35 == -1) ? ((pos > 0) ? "esriLegendGroupLayer" : "") : (this.alignRight ? "esriLegendRight" : "esriLegendLeft")
                }, (_35 == -1) ? _33 : dojo.byId(this.id + "_" + layer.id + "_" + _35 + "_group"));
                if (dojo.isIE) {
                    dojo.style(dojo.byId(this.id + "_" + layer.id + "_" + layerInfo.id + "_group"), "display", "none");
                }
                dojo.create("td", {
                    innerHTML: layerInfo.name.replace(/[\<]/g, "&lt;").replace(/[\>]/g, "&gt;"),
                    align: (this.alignRight ? "right" : "")
                }, dojo.create("tr", {}, dojo.create("tbody", {}, dojo.create("table", {
                    width: "95%",
                    "class": "esriLegendLayerLabel"
                }, _36))));
            } else {
                if (layer.visibleLayers && ("," + layer.visibleLayers + ",").indexOf("," + layerInfo.id + ",") == -1) {
                    return _32;
                }
                var d = dojo.create("div", {
                    id: this.id + "_" + layer.id + "_" + layerInfo.id,
                    style: "display:none;",
                    "class": (_35 > -1) ? (this.alignRight ? "esriLegendRight" : "esriLegendLeft") : ""
                }, (_35 == -1) ? _33 : dojo.byId(this.id + "_" + layer.id + "_" + _35 + "_group"));
                if (dojo.isIE) {
                    dojo.style(dojo.byId(this.id + "_" + layer.id + "_" + layerInfo.id), "display", "none");
                }
                dojo.create("td", {
                    innerHTML: (layerInfo.name) ? layerInfo.name.replace(/[\<]/g, "&lt;").replace(/[\>]/g, "&gt;") : "",					
                    align: (this.alignRight ? "right" : "")
                }, dojo.create("tr", {}, dojo.create("tbody", {}, dojo.create("table", {
                    width: "95%",
                    "class": "esriLegendLayerLabel"
                }, d))));
                if (layer.legendResponse) {
                    _32 = _32 || this._buildLegendItems_Tools(layer, layerInfo, d);
                } else {
                    if (layer.renderer) {
                        _32 = _32 || this._buildLegendItems_Renderer(layer, layerInfo, d);
                    }
                }
            }
            return _32;
        },
        _buildLegendItems_Tools: function (_37, _38, _39) {
            var _3a = _38.parentLayerId;
            var _3b = esri.geometry.getScale(this.map);
            var _3c = false;
            if (!this._respectCurrentMapScale || (this._respectCurrentMapScale && this._isLayerInScale(_37, _38, _3b))) {
                for (var i = 0; i < _37.legendResponse.layers.length; i++) {
                    if (_38.id == _37.legendResponse.layers[i].layerId) {
                        var _3d = _37.legendResponse.layers[i].legend;
                        if (_3d.length == 3 && _3d[0].label.replace(/\s+/g, "").indexOf(":Band_") > -1) {} else {
                            var _3e = dojo.create("tbody", {}, dojo.create("table", {
                                cellpadding: 0,
                                cellspacing: 0,
                                width: "95%",
                                "class": "esriLegendLayer"
                            }, _39));
                            dojo.forEach(_3d, function (_3f) {
                                if ((_3f.url && _3f.url.indexOf("http") === 0) || (_3f.imageData && _3f.imageData.length > 0)) {
                                    _3c = true;
                                    this._buildRow_Tools(_3f, _3e, _37, _38.id);
                                }
                            }, this);
                        }
                        break;
                    }
                }
            }
            if (_3c) {
                dojo.style(dojo.byId(this.id + "_" + _37.id + "_" + _38.id), "display", "block");
                if (_3a > -1) {
                    dojo.style(dojo.byId(this.id + "_" + _37.id + "_" + _3a + "_group"), "display", "block");
                    this._findParentGroup(_37.id, _37, _3a);
                }
            }
            return _3c;
        },
        _buildRow_Tools: function (_40, _41, _42, _43) {
            var tr = dojo.create("tr", {}, _41);
            var _44;
            var _45;
            if (this.alignRight) {
                _44 = dojo.create("td", {
                    align: "right"
                }, tr);
                _45 = dojo.create("td", {
                    align: "right",
                    width: 35
                }, tr);
            } else {
                _45 = dojo.create("td", {
                    width: 35
                }, tr);
                _44 = dojo.create("td", {}, tr);
            }
            var src = _40.url;            
			if (_40.imageData && _40.imageData.length > 0) {
				src = _40.imageData;
				var base64prefix = "data:image/png;base64,";
				if (!(src.substr(0,22) === base64prefix)){
					src = base64prefix + src;
				}
            } else {
                if (_40.url && _40.url.indexOf("http") !== 0) {
                    src = _42.url + "/" + _43 + "/images/" + _40.url;
                }
            }
            var img = dojo.create("img", {
                src: src,				
                border: 0,
                style: "opacity:" + _42.opacity
            }, _45);
            dojo.create("td", {
                innerHTML: _40.label.replace(/[\<]/g, "&lt;").replace(/[\>]/g, "&gt;"),
                align: (this.alignRight ? "right" : "")
            }, dojo.create("tr", {}, dojo.create("tbody", {}, dojo.create("table", {
                width: "95%",
                dir: "ltr"
            }, _44))));
            if (dojo.isIE < 9) {
                img.style.filter = "alpha(opacity=" + (_42.opacity * 100) + ")";
            }
        },
        _buildLegendItems_Renderer: function (_46, _47, _48) {
            var _49 = _47.parentLayerId;
            var _4a = esri.geometry.getScale(this.map);
            var _4b = false;
            if (!this._respectCurrentMapScale || this._isLayerInScale(_46, _47, _4a)) {
                var _4c;
                if (_46.renderer instanceof esri.renderer.UniqueValueRenderer) {
                    if (_46.renderer.infos && _46.renderer.infos.length > 0) {
                        _4b = true;
                        _4c = dojo.create("tbody", {}, dojo.create("table", {
                            cellpadding: 0,
                            cellspacing: 0,
                            width: "95%",
                            "class": "esriLegendLayer"
                        }, _48));
                        dojo.forEach(_46.renderer.infos, function (_4d, _4e) {
                            var _4f = null;
                            if (_46._editable && _46.types) {
                                _4f = this._getTemplateFromTypes(_46.types, _4d.value);
                            }
                            var _50 = _4d.label;
                            if (!_50 || _50.length === 0) {
                                _50 = _4d.value;
                            }
                            this._buildRow_Renderer(_46, _4d.symbol, _50, _4f, _4c);
                        }, this);
                    }
                }
                if (_46.renderer instanceof esri.renderer.ClassBreaksRenderer) {
                    if (_46.renderer.infos && _46.renderer.infos.length > 0) {
                        _4b = true;
                        _4c = dojo.create("tbody", {}, dojo.create("table", {
                            cellpadding: 0,
                            cellspacing: 0,
                            width: "95%",
                            "class": "esriLegendLayer"
                        }, _48));
                        dojo.forEach(_46.renderer.infos, function (_51, _52) {
                            var _53 = _51.label;
                            if (!_53 || _53.length === 0) {
                                _53 = _51.minValue + " - " + _51.maxValue;
                            }
                            this._buildRow_Renderer(_46, _51.symbol, _53, null, _4c);
                        }, this);
                    }
                }
                if (_46.renderer instanceof esri.renderer.SimpleRenderer) {
                    _4b = true;
                    _4c = dojo.create("tbody", {}, dojo.create("table", {
                        cellpadding: 0,
                        cellspacing: 0,
                        width: "95%",
                        "class": "esriLegendLayer"
                    }, _48));
                    var _54 = null;
                    if (_46._editable && _46.templates && _46.templates.length > 0) {
                        _54 = _46.templates[0];
                    }
                    this._buildRow_Renderer(_46, _46.renderer.symbol, _46.renderer.label, _54, _4c);
                }
                if (_46.renderer.defaultSymbol) {
                    _4b = true;
                    _4c = dojo.create("tbody", {}, dojo.create("table", {
                        cellpadding: 0,
                        cellspacing: 0,
                        width: "95%",
                        "class": "esriLegendLayer"
                    }, _48));
                    this._buildRow_Renderer(_46, _46.renderer.defaultSymbol, _46.renderer.defaultLabel ? _46.renderer.defaultLabel : "others", null, _4c);
                }
            }
            if (_4b) {
                dojo.style(dojo.byId(this.id + "_" + _46.id + "_" + _47.id), "display", "block");
                if (_49 > -1) {
                    dojo.style(dojo.byId(this.id + "_" + _46.id + "_" + _49 + "_group"), "display", "block");
                    this._findParentGroup(_46.id, _49);
                }
            }
            return _4b;
        },
        _buildRow_Renderer: function (_55, _56, _57, _58, _59) {
            var tr = dojo.create("tr", {}, _59);
            var _5a;
            var _5b;
            if (this.alignRight) {
                _5a = dojo.create("td", {
                    align: "right"
                }, tr);
                _5b = dojo.create("td", {
                    align: "right",
                    width: 35
                }, tr);
            } else {
                _5b = dojo.create("td", {
                    width: 35
                }, tr);
                _5a = dojo.create("td", {}, tr);
            }
            var _5c = 30;
            if (_56.type == "simplemarkersymbol") {
                _5c = Math.min(Math.max(_5c, _56.size + 12), 125);
            } else {
                if (_56.type == "picturemarkersymbol") {
                    _5c = Math.min(Math.max(_5c, _56.width), 125);
                }
            }
            var div = dojo.create("div", {
                style: "width:" + _5c + "px;height:" + _5c + "px;"
            }, _5b);
            dojo.create("td", {
                innerHTML: _57 ? _57.replace(/[\<]/g, "&lt;").replace(/[\>]/g, "&gt;").replace(/^#/, "") : "",
                align: (this.alignRight ? "right" : "")
            }, dojo.create("tr", {}, dojo.create("tbody", {}, dojo.create("table", {
                width: "95%"
            }, _5a))));
            var _5d = this._drawSymbol(div, _56, _5c, _5c, _58, _55.opacity);
            this._surfaceItems.push(_5d);
        },
        _drawSymbol: function (_5e, sym, _5f, _60, _61, _62) {
            var _63 = esri.symbol.fromJson(sym.toJson());
            if (_63.type === "simplelinesymbol" || _63.type === "cartographiclinesymbol" || _63.type === "textsymbol") {
                var _64 = _63.color.toRgba();
                _64[3] = _64[3] * _62;
                _63.color.setColor(_64);
            } else {
                if (_63.type === "simplemarkersymbol" || _63.type === "simplefillsymbol") {
                    var _64 = _63.color.toRgba();
                    _64[3] = _64[3] * _62;
                    _63.color.setColor(_64);
                    if (_63.outline) {
                        _64 = _63.outline.color.toRgba();
                        _64[3] = _64[3] * _62;
                        _63.outline.color.setColor(_64);
                    }
                } else {
                    if (_63.type === "picturemarkersymbol") {
                        _5e.style.opacity = _62;
                        _5e.style.filter = "alpha(opacity=(" + _62 * 100 + "))";
                    }
                }
            }
            var _65 = dojox.gfx.createSurface(_5e, _5f, _60);
            if (dojo.isIE) {
                var _66 = _65.getEventSource();
                dojo.style(_66, "position", "relative");
                dojo.style(_66.parentNode, "position", "relative");
            }
            var _67 = this._getDrawingToolShape(_63, _61) || esri.symbol.getShapeDescriptors(_63);
            var _68;
            try {
                _68 = _65.createShape(_67.defaultShape).setFill(_67.fill).setStroke(_67.stroke);
            } catch (e) {
                _65.clear();
                _65.destroy();
                return;
            }
            var dim = _65.getDimensions();
            var _69 = {
                dx: dim.width / 2,
                dy: dim.height / 2
            };
            var _6a = _68.getBoundingBox(),
                _6b = _6a.width,
                _6c = _6a.height;
            if (_6b > _5f || _6c > _60) {
                var _6d = _6b > _6c ? _6b : _6c;
                var _6e = _5f < _60 ? _5f : _60;
                var _6f = (_6e - 5) / _6d;
                dojo.mixin(_69, {
                    xx: _6f,
                    yy: _6f
                });
            }
            _68.applyTransform(_69);
            return _65;
        },
        _getDrawingToolShape: function (_70, _71) {
            var _72, _73 = _71 ? _71.drawingTool || null : null;
            switch (_73) {
            case "esriFeatureEditToolArrow":
                _72 = {
                    type: "path",
                    path: "M 10,1 L 3,8 L 3,5 L -15,5 L -15,-2 L 3,-2 L 3,-5 L 10,1 E"
                };
                break;
            case "esriFeatureEditToolTriangle":
                _72 = {
                    type: "path",
                    path: "M -10,14 L 2,-10 L 14,14 L -10,14 E"
                };
                break;
            case "esriFeatureEditToolRectangle":
                _72 = {
                    type: "path",
                    path: "M -10,-10 L 10,-10 L 10,10 L -10,10 L -10,-10 E"
                };
                break;
            case "esriFeatureEditToolCircle":
                _72 = {
                    type: "circle",
                    cx: 0,
                    cy: 0,
                    r: 10
                };
                break;
            case "esriFeatureEditToolEllipse":
                _72 = {
                    type: "ellipse",
                    cx: 0,
                    cy: 0,
                    rx: 10,
                    ry: 5
                };
                break;
            default:
                return null;
            }
            return {
                defaultShape: _72,
                fill: _70.getFill(),
                stroke: _70.getStroke()
            };
        },
        _repaintItems: function () {
            dojo.forEach(this._surfaceItems, function (_74) {
                this._repaint(_74);
            }, this);
        },
        _repaint: function (_75) {
            if (!_75) {
                return;
            }
            if (_75.getStroke && _75.setStroke) {
                _75.setStroke(_75.getStroke());
            }
            try {
                if (_75.getFill && _75.setFill) {
                    _75.setFill(_75.getFill());
                }
            } catch (e) {}
            if (_75.children && dojo.isArray(_75.children)) {
                dojo.forEach(_75.children, this._repaint, this);
            }
        },
        _getTemplateFromTypes: function (_76, _77) {
            for (var i = 0; i < _76.length; i++) {
                if (_76[i].id == _77 && _76[i].templates && _76[i].templates.length > 0) {
                    return _76[i].templates[0];
                }
            }
            return null;
        },
        _findParentGroup: function (_78, _79, _7a) {
            var _7b = _79.layerInfos;
            for (var k = 0; k < _7b.length; k++) {
                if (_7a == _7b[k].id) {
                    if (_7b[k].parentLayerId > -1) {
                        dojo.style(dojo.byId(this.id + "_" + _78 + "_" + _7b[k].parentLayerId + "_group"), "display", "block");
                        this._findParentGroup(_78, _79, _7b[k].parentLayerId);
                    }
                    break;
                }
            }
        },
        _isLayerInScale: function (_7c, _7d, _7e) {
            var _7f = true;
            if (_7c.legendResponse && _7c.legendResponse.layers) {
                for (var i = 0; i < _7c.legendResponse.layers.length; i++) {
                    var _80 = _7c.legendResponse.layers[i];
                    if (_7d.id == _80.layerId) {
                        if (_80.minScale == 0 && _7c.tileInfo) {
                            _80.minScale = _7c.tileInfo.lods[0].scale + 1;
                        }
                        if (_80.maxScale == 0 && _7c.tileInfo) {
                            _80.maxScale = _7c.tileInfo.lods[_7c.tileInfo.lods.length - 1].scale - 1;
                        }
                        if ((_80.minScale > 0 && _80.minScale < _7e) || _80.maxScale > _7e) {
                            _7f = false;
                        }
                        break;
                    }
                }
            } else {
                if (_7c.minScale || _7c.maxScale) {
                    if ((_7c.minScale && _7c.minScale < _7e) || _7c.maxScale && _7c.maxScale > _7e) {
                        _7f = false;
                    }
                }
            }
            return _7f;
        },
        _getServiceTitle: function (_81) {
            var _82 = _81._titleForLegend;
            if (!_82) {
                _82 = _81.url;
                if (!_81.url) {
                    _82 = "";
                } else {
                    if (_81.url.indexOf("/MapServer") > -1) {
                        _82 = _81.url.substring(0, _81.url.indexOf("/MapServer"));
                        _82 = _82.substring(_82.lastIndexOf("/") + 1, _82.length);
                    } else {
                        if (_81.url.indexOf("/ImageServer") > -1) {
                            _82 = _81.url.substring(0, _81.url.indexOf("/ImageServer"));
                            _82 = _82.substring(_82.lastIndexOf("/") + 1, _82.length);
                        } else {
                            if (_81.url.indexOf("/FeatureServer") > -1) {
                                _82 = _81.url.substring(0, _81.url.indexOf("/FeatureServer"));
                                _82 = _82.substring(_82.lastIndexOf("/") + 1, _82.length);
                            }
                        }
                    }
                }
                if (_81.name) {
                    if (_82.length > 0) {
                        _82 += " - " + _81.name;
                    } else {
                        _82 = _81.name;
                    }
                }
            }
            return dojox.html.entities.encode(_82);
        },
        _isSupportedLayerType: function (layer) {
            if (layer && (layer.declaredClass === "esri.layers.ArcGISImageServiceLayer" || layer.declaredClass === "esri.layers.ArcGISDynamicMapServiceLayer" || layer.declaredClass === "esri.layers.ArcGISTiledMapServiceLayer" || layer.declaredClass === "esri.layers.FeatureLayer" || layer.declaredClass == "esri.layers.KMLLayer")) {
                return true;
            }
            return false;
        }
    });
    dojo.mixin(esri.dijit.Legend, {
        ALIGN_LEFT: 0,
        ALIGN_RIGHT: 1
    });
}