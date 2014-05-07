//Written By: Michael Snuffer, InTech Software Solutions, Inc.
//            michael.snuffer@comcast.net

//Constants =====================================================================

//Wait until Initialization is complete or a max of 60 Seconds.
var LoadAllMaps_TimeoutSecs = 60;
var SetTimeout_Timer_MilliSecs = 100; //1/10th second. This is the amount of wait time between callbacks to the KeepInitializingMaps
var LoadAllMaps_TimeoutCount = (LoadAllMaps_TimeoutSecs * 1000) / SetTimeout_Timer_MilliSecs;

var LoadSingleMap_RetryAfter_TimeoutSecs = 15; //Waits this long for a single MapService to load.  If fails, aborts and retries repeatedly until the LoadAllMaps_TimeoutSecs is elapsed.

var mbIsMapDebugMessagesOn = false;  //Set this to true to get alert describing which services succeeded failed to load and how many times the system tried.

//The ServiceType_ Constants for the "sServiceType" parameter of the "new MapSvcDef(...)" call.
var ServiceType_Dynamic = "ST_Dynamic"; 
var ServiceType_Tiled = "ST_Tiled";

// DVA Added image type constant for Image Services
var ServiceType_Image = "ST_Image";

//Classes =====================================================================

//MapSvcList Class ----------

//Note that initializeAllMapSerivceLayers() is not thread-safe.  It may only be called
//  for one instance at a time
function MapSvcList()
{
  //Private Fields ============================================================
  var moMap = null;
  var msAlertToDisplayOnMapLoadFailure = null;
  var mfnCallbackAfterInitialize = null;
    
  // Public Fields ============================================================
  this.prototype = new Array();  //Inherits from Array();

  //Private Methods ===========================================================
     //OK, they may be public, but just don't call them.  
  
  this.callback = function()
  {
    if (mbIsMapDebugMessagesOn)
      alert(getMapDebugMessage(this));
  
    if (mfnCallbackAfterInitialize != null)
      mfnCallbackAfterInitialize();
  }

  this.failureAlert = function()
  { 
    if (msAlertToDisplayOnMapLoadFailure != null && msAlertToDisplayOnMapLoadFailure != "")
      alert(msAlertToDisplayOnMapLoadFailure + getMapDebugMessage(this));
    else
      alert("Error: One or more map services failed to initialize." + getMapDebugMessage(this));
  }
  
  function getMapDebugMessage(thisObject)
  {
    var sDebugInfo = "";
    if (mbIsMapDebugMessagesOn)
    {
      sDebugInfo += "\r\n";
      for(var iIdx=0; iIdx < thisObject.length; iIdx++)
        sDebugInfo += "\r\n" + 
                       iIdx + ") " + thisObject[iIdx].Url + 
                       ": Init'd?-" + (thisObject[iIdx].MapServiceLayer != null) + 
                       " | Loaded?-" + (thisObject[iIdx].MapServiceLayer == null ? false : thisObject[iIdx].MapServiceLayer.loaded +
                       " | RetryCnt-" + thisObject[iIdx].RetryCnt) ;
    }
    return sDebugInfo;
  }
  //Public Methods ============================================================
  
  //Description: Adds to the Array/Collection of MapSvcDef's to be added to the map.
  //Parameters: oMapSvcDef - An MapSvcDef class object instance.
  //!IMPORTANT! --> Add oMapSvcDef objects in the z-order you want them to be displayed.
  //                (bottom most first to topmost last).
  this.add = function(oMapSvcDef)
  {
      this.push(oMapSvcDef);
  }
  
  this.remove = function () {
	  this.pop();
  }

  //Description: Kicks off the Map Initialization and Loading process
  //Parameters: oEsriMap = the esri.map() object to add the map service--esri.layer()--objects to.
  //            sAlertToDisplayOnMapLoadFailure: A message to be displayed if the services fail to load.
  //            fnCallbackAfterInitialize: An optional function to be called after all MapServices
  //                                       are successfully loaded (can pass in null if no callback desired)
  this.initializeAllMapSerivceLayers = function(oEsriMap, sAlertToDisplayOnMapLoadFailure, fnCallbackAfterInitialize)
  {
    //Store these so for use during the initialization process
    moMap = oEsriMap;
    mfnCallbackAfterInitialize = fnCallbackAfterInitialize;
    msAlertToDisplayOnMapLoadFailure = sAlertToDisplayOnMapLoadFailure;
    moProcessingMapSvcList = this; //Keep this reference up-to-date;

    keepInitializingMaps(0);
  }
  
}//MapSvcList Class


//MapSvcDef Class ----------

//Parameters: sID - A user-defined ID that uniquely identifies a map service Layer object within a map.
//            sUrl - URL to the map service rest API (Example "http://{ServerName}/ArcGIS/rest/services/{ServicName}/MapServer"
//            sServiceType - must pass in one of the following constants:  ServiceType_Dynamic, ServiceType_Tiled
//            oEsriMap - the esri.map() object to add this map service--esri.layer()--object to.
//            fnCallbackBeforeAddToMap - If you would like to make modifications to the esri.layer() object prior
//                                       adding it to the map, supply a callback function.  Note that this
//                                       function must contain a single parameter--the esri.layer object.
//                                       (can pass in null if no callback desired)
function MapSvcDef(sID, sUrl, sServiceType, oEsriMap, fnCallbackBeforeAddToMap)
{
  //Constants ====================================
  
  //Private Fields ====================================
  var thisObject = this; //Makes this object visible to private methods.
  var mbIsInitialized = false;
  var mdtInitializationStarted = null;
  var moMap = oEsriMap;
  var mfnCallbackBeforeAddToMap = fnCallbackBeforeAddToMap;

  //Public Fields ====================================
  this.ID = sID;
  this.Url = sUrl;
  this.ServiceType = sServiceType;
  this.IsAddedToMap = false;
  this.IsReady = false;
  this.MapServiceLayer = null;  //Note that once all initialization is complete, you can access the esri.layer object via this "Property"
  this.RetryCnt = -1; //Just want to keep track of how many times this is retried.
  
  //Private Methods ====================================
  function isLoaded()
  {
    var bIsLoaded = false;
    if (thisObject.MapServiceLayer != null)
      bIsLoaded = thisObject.MapServiceLayer.loaded;
    
    return bIsLoaded;
  }

  //Public Methods ====================================
  this.tryLoad = function()
  {
    if (!mbIsInitialized)
    {
      switch (this.ServiceType)
      {
        case ServiceType_Tiled:
          this.MapServiceLayer = new esri.layers.ArcGISTiledMapServiceLayer(this.Url, {id: this.ID}); 
          break;
        case ServiceType_Dynamic:
          this.MapServiceLayer = new esri.layers.ArcGISDynamicMapServiceLayer(this.Url, {id: this.ID}); 
          break;
		//Added by DVA to load image services
		case ServiceType_Image:
		  this.MapServiceLayer = new esri.layers.ArcGISImageServiceLayer(this.Url, {id: this.ID});
		  break;
      }
      mdtInitializationStarted = new Date();
      mbIsInitialized = true;
      this.RetryCnt++;
    }
    else
    {
      if (!isLoaded()) 
      {
        //Start Retry Logic ---------------
        var dtCurTime = new Date();
        var iElapsedTime = dtCurTime.getTime() - mdtInitializationStarted.getTime();
        if ((iElapsedTime / 1000) > LoadSingleMap_RetryAfter_TimeoutSecs)
        {
          //OK, here is the key to the whole thing.  At this point we
          // are giving up on this map service request.  We will
          // delete the current maps service layer and retry the 
          // request.  This allows for the first request to fail
          // and auto-requests the second try.
          delete this.MapServiceLayer;
          this.MapServiceLayer = null;
          mdtInitializationStarted = null;
          mbIsInitialized = false;
          this.tryLoad();  //Retry to load from scratch.
        }
        //End Retry Logic ---------------
      }
    }
    
    //If the service had been added to the map, it is ready.
    this.IsReady = isLoaded();
    
  }//tryLoad
  
  this.addToMap = function()
  {
    if (!this.IsAddedToMap)
    {
      //Do any initialization prior to adding to the map
      // NOTE: Any post-add initialization can be done on Page_Map_Load
      if (mfnCallbackBeforeAddToMap != null)
        mfnCallbackBeforeAddToMap(this.MapServiceLayer);
      
      //Add to the map
      moMap.addLayer(this.MapServiceLayer);
      this.IsAddedToMap = true;
    }
  }
}//MapSvcDef Class 


//CreateCollection Class ----------

//Thank you Manikandan Balakrishnan(Manikandan.net) for this
// cool collection creater class.
function CreateCollection(sClassName)    
{
    var oArray = new Array();
    eval("var oCollectionObject = new " + sClassName + "()");
    for(_item in oCollectionObject)
    {
      eval("oArray." + _item + "=oCollectionObject." + _item);
    }
    return oArray;
}//CreateCollection Class

//Public Var's ===========================================================
var moProcessingMapSvcList = this; //provides access to this object in private functions

//Functions ===============================================================

//This function will interatively initialize and load each map one at a time.
//  If a map does not load in LoadSingleMap_RetryAfter_TimeoutSecs seconds, will keep retrying until loaded.
//  Once the first map is loaded successfully, will attempt to load each successive map until all are loaded.
function keepInitializingMaps(iInterationCnt)
{
  //Make sure all the expected map service layers have been initialized.
  var bIsAllMapServiceLayersLoaded = true;
  
  //The following for() loop will:
  //   - Attempt to load each map service
  //   - Monitor whether the map services were successfully loaded.
  //   - delete and re-load any service that is not successfully starting.
  
  //OPTION #1: This for() loop will start all map services at once, and then just monitor all of
  //             them until all successfully load.
  for (var iIdx = 0; iIdx < moProcessingMapSvcList.length; iIdx++)
  //OPTION #2: This more conservative approach will attempt to start map services one at a time and 
  //             wait until each is loaded before attempting to load the next in the list.
  //for (var iIdx = 0; iIdx < moProcessingMapSvcList.length && bIsAllMapServiceLayersLoaded; iIdx++)
  {
    //Start the services and add them to the map in order.
    if(!moProcessingMapSvcList[iIdx].IsReady) 
      moProcessingMapSvcList[iIdx].tryLoad();
  
    bIsAllMapServiceLayersLoaded = (bIsAllMapServiceLayersLoaded && moProcessingMapSvcList[iIdx].IsReady);
  }
  
  if (!bIsAllMapServiceLayersLoaded)
  {
    if (iInterationCnt <= LoadAllMaps_TimeoutCount)
    {
      //Wait for a while, then retry...
      setTimeout("keepInitializingMaps(" + (iInterationCnt + 1) + ");", SetTimeout_Timer_MilliSecs);
    }
    else 
    {
      //Alas, we have failed to load all maps and the timeout has expired.
      moProcessingMapSvcList.failureAlert();
    }
  }
  else
  {
    //Oh, Joy! Success!  Now add all maps to the EsriMap object.
    for (var iIdx = 0; iIdx < moProcessingMapSvcList.length; iIdx++)
      moProcessingMapSvcList[iIdx].addToMap();
      
    //We are done, continue by calling back post-load-success function
    moProcessingMapSvcList.callback();
    
    //Once the callback finishes, remove the temporary reference to this object.
    moProcessingMapSvcList = null;
  }
}