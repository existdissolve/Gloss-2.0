/**
* My Event Handler Hint
*/
component extends="Base" {
    property name="AdobeService" inject;
    property name="RailoService" inject;
    property name="CFLibService" inject;
    property name="cachebox" inject="cachebox";

    // OPTIONAL HANDLER PROPERTIES
    this.prehandler_only     = "";
    this.prehandler_except     = "";
    this.posthandler_only     = "";
    this.posthandler_except = "";
    this.aroundHandler_only = "";
    this.aroundHandler_except = "";        

    // REST Allowed HTTP Methods Ex: this.allowedMethods = {delete='POST,DELETE',index='GET'}
    this.allowedMethods = {
        index = "GET"
    };
    
    /**
    IMPLICIT FUNCTIONS: Uncomment to use
    function preHandler(event,rc,prc,action,eventArguments){
        var rc = event.getCollection();
    }
    function postHandler(event,rc,prc,action,eventArguments){
        var rc = event.getCollection();
    }
    function aroundHandler(event,rc,prc,targetAction,eventArguments){
        var rc = event.getCollection();
        // executed targeted action
        arguments.targetAction(event);
    }
    function onMissingAction(event,rc,prc,missingAction,eventArguments){
        var rc = event.getCollection();
    }
    function onError(event,rc,prc,faultAction,exception,eventArguments){
        var rc = event.getCollection();
    }
    */

    // Index
    public Any function index( required Any event, required Struct rc, required Struct prc ) {
        var key = "menu-" & arguments.rc.type;
        // get default cache
        var cache = cachebox.getDefaultCache();
        // if item exists in cache...
        if( cache.lookup( key ) ) {
            var menu = cache.get( key );
        }
        // not in cache
        else {
            switch( arguments.rc.type ) {
                case "Adobe":
                    var menu = AdobeService.buildMenu();
                    break;
                case "Railo":
                    var menu = RailoService.buildMenu();
                    break;
                case "CFLib":
                    var menu = CFLibService.buildMenu();
                    break;
            }
            // add to cache
            cache.set( key, menu, 0 );
        }  
        prc.jsonData = menu;
    }
}