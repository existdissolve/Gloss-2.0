component extends="coldbox.system.orm.hibernate.VirtualEntityService" {
    /**
     * Constructor
     */
    public RailoService function init() {
        super.init( entityName="Railo" );        
        return this;
    }

    /**
     * Updates content for Adobe ColdFusion resources
     * @targets {String} The targets for the update (Defaults to all)
     */
    public Void function updateContent( required String targets="*" ) {
        var q = new query();
            q.setDataSource( 'gloss' );
            q.setSql( "SELECT * FROM TempMenu" );
        var result = q.execute().getResult();
        var menu = deserializeJSON( result.menu );
        composeMenu( menu=menu );
    }

    /**
     * Recursively builds hierarchical menu
     * @menu {Array} The array of menu items
     * @data {Array} Array of data items that will compose the menu
     * @nodecache {Struct} Hash of already-used nodes
     * returns Array
     */
    public Array function buildMenu( required Any menu=[], required Array data=[], nodecache={} ) {
        // start with terminal anscestors
        if( !arrayLen( arguments.data ) ) {
            arguments.data = list( sortOrder="Parent ASC", asQuery=false );
        }
        // loop over data
        for( var item in arguments.data ) {
            // check if node has already been evaluated
            if( !structKeyExists( arguments.nodecache, item.getPageID() ) ) {
                // add to nodecache
                arguments.nodecache[ item.getPageID() ] = true;
                // setup note
                var node = {
                    "href" = item.getSlug(),
                    "text" = item.getTitle(),
                    "contentid" = item.getResourceID(),
                    "qtip" = item.getTitle()
                };
                // if children, build them recursively
                if( item.hasChild() ) {
                    node[ "children" ] = buildMenu( data=item.getChildren(), nodecache=arguments.nodecache );
                    node[ "leaf" ] = false;
                    //node[ "leaf" ] = false;
                }
                else {
                    node[ "leaf" ] = true;
                }
                // add to menu
                arrayAppend( arguments.menu, node );
            }
        }
        return menu;
    }
    /**
     * Scrapes Adobe CF documentation menu from remote source
     * @tree {Array} Array of menu items
     * @pageId {String} ID of the currently evaluated page
     * return Array
     */
    public Array function scrapeMenu( required Any tree=[] ) {
        //<a [^>]*\bhref\s*=\s*"[^"]*(/index\.cfm/tag/[^"]*)
        var httpService = new http();
            httpService.setURL( "http://railodocs.org/index.cfm/tags/" );
        var result = httpService.send().getPrefix().fileContent;
        var menu = result;
        writedump( menu );
        abort;
        for( var item in menu ) {
            // create node
            var node = {
                "href" = item.href,
                "id" = item.pageId,
                "text" = item.text,
                "children" = []
            };
            if( structKeyExists( item, "position" ) && item.position != "undefined" ) {
                try {
                    node.children = buildTree( pageId=item.pageId ); 
                }
                catch( any e ) {
                    writedump( e );
                    abort;
                }
            }            
            arrayAppend( arguments.tree, node );
        }
        return arguments.tree;
    }
}