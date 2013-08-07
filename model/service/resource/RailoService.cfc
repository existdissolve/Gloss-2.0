component extends="coldbox.system.orm.hibernate.VirtualEntityService" {
    /**
     * Constructor
     */
    public RailoService function init() {
        super.init( entityName="Railo" );        
        return this;
    }

    /**
     * Updates content for Railo resources
     * @targets {String} The targets for the update (Defaults to all)
     */
    public Void function updateContent( required String targets="tag,function,object" ) {
        // loop over targets
        deleteAll();
        for( var target in targets ) {
            // each menu is a collection of data ready to be inserted
            var menu = scrapeMenu( target );
            // loop over menu items
            for( var item in menu ) {
                var criteria = {
                    "Slug" = item.slug,
                    "Title" = item.title
                };
                // see if this already exists
                var resource = findWhere( criteria=criteria );
                if( isNull( resource ) ) {
                    var resource = new();
                }
                // popluate with some data
                populate( target=resource, memento=item );
                // save resource
                save( resource );
            }
        }
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
     * Scrapes Railo documentation menu from remote source
     * @resource {String} Name of the resource to scrape
     * return Array
     */
    public Array function scrapeMenu( required String resource ) {
        var httpService = new http();
            httpService.setURL( "http://railodocs.org/index.cfm/#arguments.resource#s/" );
        var result = httpService.send().getPrefix().fileContent;
        // item tracker
        var items = [];
        // get matches
        var matches = reMatch( '<a [^>]*\bhref\s*=\s*"[^"]*(/index\.cfm/#arguments.resource#/[^"]*).*?>.*?</a>', result );
        // loop over matches to create resource array
        for( var match in matches ) {
            var link = reReplaceNoCase( match, '<a [^>]*\bhref\s*=\s*"[^"]*(/index\.cfm/#arguments.resource#/[^"]*).*?>(.*?)</a>', '\1', 'one' );
            var title = reReplaceNoCase( match, '<a [^>]*\bhref\s*=\s*"[^"]*(/index\.cfm/#arguments.resource#/[^"]*).*?>(.*?)</a>', '\2', 'one' );
            var slug = reReplaceNoCase( link, "/index\.cfm/#arguments.resource#/(.*?)/.*$", "\1", "one" );
            // create node
            var item = {
                "link" = link,
                "slug" = slug,
                "title" = reReplaceNoCase( title, "<[^<]+?>", "", "all" ),
                "category" = arguments.resource
            };
            if( arguments.resource=="object" ) {
                var parsed = reMatch( "(.*)\.(.*)", title );
                item[ "class" ] = reReplaceNoCase( title, "(.*)\.(.*)", "\1", "one" );
                item[ "title" ] = reReplaceNoCase( title, "(.*)\.(.*)", "\2", "one" );
                item[ "slug" ] = reReplaceNoCase( link, "/index\.cfm/#arguments.resource#/#item[ 'class' ]#/(.*?)", "\1", "one" );
            }    
            arrayAppend( items, item );
        }
        return items;
    }
}