<cfscript>
    // Allow unique URL or combination (false)
    setUniqueURLS(false);
    // Auto reload configuration, true in dev makes sense
    //setAutoReload(false);
    // Sets automatic route extension detection and places the extension in the rc.format
    setExtensionDetection(true);
    //setValidExtensions('json');
    
    // Base URL
    if( len(getSetting('AppMapping') ) lte 1){
        setBaseURL("http://#cgi.HTTP_HOST#/index.cfm");
    }
    else{
        setBaseURL("http://#cgi.HTTP_HOST#/#getSetting('AppMapping')#/index.cfm");
    }
    // Your Application Routes
    addRoute( pattern="/api/bug/adobebug/:resourceid", handler="Bug", action={ GET="detail" }, matchVariables="type=AdobeBug" );
    addRoute( pattern="/api/bug/railobug", handler="Bug", action={ GET="index" }, matchVariables="type=RailoBug" );
    addRoute( pattern="/api/bug/adobebug", handler="Bug", action={ GET="index" }, matchVariables="type=AdobeBug" );

    addRoute( pattern="/api/menu/railo", handler="Menu", action={ GET="index" }, matchVariables="type=Railo" );
    addRoute( pattern="/api/menu/adobe", handler="Menu", action={ GET="index" }, matchVariables="type=Adobe" );
    addRoute( pattern="/api/menu/cflib", handler="Menu", action={ GET="index" }, matchVariables="type=CFLib" );

    addRoute( pattern="/api/content/railo", handler="Content", action={ GET="index" }, matchVariables="type=Railo" );
    addRoute( pattern="/api/content/adobe", handler="Content", action={ GET="index" }, matchVariables="type=Adobe" );
    addRoute( pattern="/api/content/cflib", handler="Content", action={ GET="index" }, matchVariables="type=CFLib" );

    addRoute(pattern=":handler/:action?");
</cfscript>