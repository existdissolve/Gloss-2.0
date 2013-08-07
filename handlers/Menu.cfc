/**
* My Event Handler Hint
*/
component{
    property name="AdobeService" inject;
    property name="RailoService" inject;
    property name="CFLibService" inject;

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
        // switch on menu type
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
        event.renderData( data=menu, type="json" );
    }
}