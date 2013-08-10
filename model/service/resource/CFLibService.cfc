component extends="coldbox.system.orm.hibernate.VirtualEntityService" {
    property name="jSoup" inject="javaLoader:org.jsoup.Jsoup";

    /**
     * Constructor
     */
    public CFLibService function init() {
        super.init( entityName="CFLib" );        
        return this;
    }

    /**
     * Retrieves content from cache or remote source
     * @resource {model.orm.resource.Railo} The resource for which to retrieve content
     * return String
     */
    public String function getContent( required model.orm.resource.CFLib resource ) {
        // parse html and return it
        return scrapeContent( resource.getLink() );
    }

    /**
     * Builds hierarchical menu
     * @menu {Array} The array of menu items
     * @data {Array} Array of data items that will compose the menu
     * @nodecache {Struct} Hash of already-used nodes
     * returns Array
     */
    public Array function buildMenu() {
        var menu = [];
        // set terminal ancestor nodes
        var terminalNodes = getTerminalNodes();
        // loop over terminal nodes
        for( ancestor in terminalNodes ) {
            var childNodes = [];
            var ancestorNode = {
                "text" = ancestor,
                "leaf" = false
            };
            // get children
            var criteria = { "Library"=ancestor };
            var children = findAllWhere( criteria=criteria );
            // loop over children
            for( var child in children ) {
                var node = {
                    "text" = child.getTitle(),
                    "href" = child.getSlug(),
                    "contentid" = child.getResourceID(),
                    "leaf" = true,
                    "qtip" = child.getDescription()
                };
                arrayAppend( childNodes, node );
            }
            // add category children to category node
            ancestorNode[ "children" ] = childNodes;
            // add category node to main menu
            arrayAppend( menu, ancestorNode );
        }
        return menu;
    }

    /**
     * Updates content for CFLib resources
     * @targets {String} The targets for the update (Defaults to all)
     */
    public Void function updateContent( required String targets="*" ) {
        // call each method
        var libraries = getLibraries();
        for( var library in libraries ) {
            var lib = library[ 2 ];
            var udfs = getUDFs( library[ 1 ] );
            for( var udf in udfs ) {
                var node = {
                    "Link" = "http://www.cflib.org/udf/#udf[ 2 ]#",
                    "Slug" = udf[ 2 ],
                    "Title" = udf[ 2 ],
                    "Library" = lib,
                    "PageID" = udf[ 1 ],
                    "Description" = udf[ 3 ]
                };
                var criteria = {
                    "Slug" = udf[ 2 ],
                    "Title" = udf[ 2 ]
                };
                // see if this already exists
                var resource = findWhere( criteria=criteria );
                if( isNull( resource ) ) {
                    var resource = new();
                }
                populate( target=resource, memento=node );
                save( resource );
            }
        }
    }

    /**
     * Gets library-level nodes for CFLib resources
     */
    private Array function getUDFs( required Numeric libraryID ) {
        // get content from Railo documentation site
        var httpService = new http();
            httpService.setURL( "http://www.cflib.org/api/api.cfc" );
            httpService.addparam( type="url", name="method", value="getudfs" );
            httpService.addparam( type="url", name="returnformat", value="json" );
            httpService.addparam( type="url", name="libraryid", value=arguments.libraryID );
        // return file content
        return deserializeJSON( httpService.send().getPrefix().fileContent ).data;
    }

    /**
     * Gets libraries for CFLib resources
     */
    private Array function getLibraries() {
        // get content from Railo documentation site
        var httpService = new http();
            httpService.setURL( "http://www.cflib.org/api/api.cfc" );
            httpService.addparam( type="url", name="method", value="getlibraries" );
            httpService.addparam( type="url", name="returnformat", value="json" );
        // return file content
        return deserializeJSON( httpService.send().getPrefix().fileContent ).data;
    }

    /**
     * Gets top level nodes for CFLib resources
     */
    private Array function getTerminalNodes() {
        var c = newCriteria();
            c.withProjections( distinct="Library" );
        return c.list( sortOrder="Library ASC" );
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
        matchedHTML = jsoupDocument.select( "div.udfDetails" );
        // if we have a match...
        if( isArray( matchedHTML ) && arrayLen( matchedHTML ) ) {
            // define "remove" selectors
            var removeList = [ 
                "script", 
                "noscript", 
                "div##disqus_thread", 
                "iframe", 
                "span[id^=formatted_code]", 
                "div[style^=font:15px]",
                "a[href=http://disqus.com]"
            ];
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
                pre.attr( "style", "" );
                pre.attr( "class", "gloss_code" );
            }
            returnHTML = matchedHTML.html();
        }
        return returnHTML;
    }
}