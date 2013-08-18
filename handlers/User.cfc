/**
* My Event Handler Hint
*/
component{
    property name="UserService" inject;

    // OPTIONAL HANDLER PROPERTIES
    this.prehandler_only     = "";
    this.prehandler_except     = "";
    this.posthandler_only     = "";
    this.posthandler_except = "";
    this.aroundHandler_only = "";
    this.aroundHandler_except = "";        

    // REST Allowed HTTP Methods Ex: this.allowedMethods = {delete='POST,DELETE',index='GET'}
    this.allowedMethods = {
        register = "POST"
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
    public Any function register( required Any event, required Struct rc, required Struct prc ) {
        var userresult = {};
        if( structKeyExists( rc, "AppID" ) && rc.AppID != "" ) {
            // check if user exists
            var user = UserService.findWhere( criteria={ AppID=rc.AppID } );
            // user exists
            if( !isNull( user ) ) {
                // update details
                user.setDisplayName( rc.DisplayName );
                user.setImageURL( rc.ImageURL );                
            }
            // user doesn't exist...create record
            else {
                user = UserService.new();
                user.setAppID( rc.AppID );
                user.setDisplayName( rc.DisplayName );
                user.setImageURL( rc.ImageURL );
                user.setUserType( rc.UserType );
            }
            UserService.save( user );
            userresult = {
                "UserID" = user.getUserID()
            };
        }
        event.renderData( data=userresult, type="json" );
    }
}