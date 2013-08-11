/**
* My Event Handler Hint
*/
component extends="Base" {
    property name="AdobeBugService" inject;
    property name="RailoBugService" inject;

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
        // set some defaults
        event.paramValue( "max", "25" );
        event.paramValue( "offset", "0" );
        event.paramValue( "sortOrder", "CreatedDate DESC" );
        // switch on menu type
        switch( arguments.rc.type ) {
            case "AdobeBug":
                // get criteria
                var c = AdobeBugService.newCriteria();
                break;
            case "RailoBug":
                // get criteria
                var c = RailoBugService.newCriteria();
                break;
        }
        var total= c.count();
        var data = c.list( max=rc.max, offset=rc.offset, sortOrder=rc.sortOrder );
        prc.jsonData = {
            "data" = EntityUtils.parseEntity( entity=data, simpleValues=true ),
            "total" = total
        };
    }
}