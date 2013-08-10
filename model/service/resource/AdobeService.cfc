component extends="coldbox.system.orm.hibernate.VirtualEntityService" {
    property name="jSoup" inject="javaLoader:org.jsoup.Jsoup";
    /**
     * Constructor
     */
    public AdobeService function init() {
        super.init( entityName="Adobe" );        
        return this;
    }

    /**
     * Retrieves content from cache or remote source
     * @resource {model.orm.resource.Adobe} The resource for which to retrieve content
     * return String
     */
    public String function getContent( required model.orm.resource.Adobe resource ) {
        // parse html and return it
        return scrapeContent( resource.getLink() );
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
     * Recursively persists menu items to database
     * @menu {Array} Array of menu items
     * @parent {cfgloss.model.orm.resource.Adobe} The parent of the current data
     */
    public Void function composeMenu( required Any menu=[], cfgloss.model.orm.resource.Adobe parent ) {
        // loop over menu
        for( var item in menu ) {
            var slug = listLast( item.href, "/" );
            var node = {
                "Link" = "https://learn.adobe.com" & item.href,
                "Slug" = slug,
                "Title" = item.text,
                "PageID" = item.id
            };
            if( isDefined( "arguments.parent" ) ) {
                node[ "Parent" ] = arguments.Parent.getResourceID();
            }
            var criteria = {
                "Slug" = slug,
                "Title" = item.text
            };
            // see if this already exists
            var resource = findWhere( criteria=criteria );
            if( isNull( resource ) ) {
                var resource = new();
            }
            // popluate with some data
            populate( target=resource, memento=node, composeRelationships=true );
            // save resource
            save( resource );
            // check if children exist
            if( arrayLen( item.children ) ) {
                composeMenu( menu=item.children, parent=resource );
            }
        }
    }

    /**
     * Recursively scrapes Adobe CF documentation menu from remote source
     * @tree {Array} Array of menu items
     * @pageId {String} ID of the currently evaluated page
     * return Array
     */
    public Array function scrapeMenu( required Any tree=[], required String pageId="91357268" ) {
        var httpService = new http();
            httpService.setURL( "https://learn.adobe.com/wiki/pages/children.action?pageId=#arguments.pageId#" );
        var result = httpService.send().getPrefix().fileContent;
        var menu = deserializeJSON( result );
        
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

    /**
     * Scrapes content from remote page and processes with jSoup library
     * @html The html content to parse
     * return String
     */
    private String function scrapeContent( required String url ) {
        var returnHTML = "";
        // retrieve content 
        var httpService = new http();
            httpService.setURL( arguments.url );
        var html = httpService.send().getPrefix().fileContent;
        // parse the results
        var jsoupDocument = jSoup.parse( html );
        // get by selector
        matchedHTML = jsoupDocument.select( "div##main-content" );
        // if we have a match...
        if( isArray( matchedHTML ) && arrayLen( matchedHTML ) ) {
            // define "remove" selectors
            var removeList = [ "a[href*=backtotop]", "img[src*=warning.png]" ];
            // loop over remove selectors
            for( var item in removeList ) {
                var removeMatches = matchedHTML.select( item );
                // loop over matches
                for( var match in removeMatches ) {
                    // remove the match
                    match.remove();
                }
            }
            // fix pre elements
            var pres = matchedHTML.select( 'pre' );
            for( var pre in pres ) {
                pre.attr( "class", "gloss_code" );
            }
            returnHTML = matchedHTML.html();
        }
        return returnHTML;
    }
}