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
     * Builds menu
     * @menu {Array} The array of menu items
     * @data {Array} Array of data items that will compose the menu
     * @nodecache {Struct} Hash of already-used nodes
     * returns Array
     */
    public Array function buildMenu() {
        var menu = [];
        // get tag menu
        var tagMenu = prepareTagChildren();
        // add tag to main menu
        arrayAppend( menu, tagMenu );
        // get fn menu
        var fnMenu = prepareFunctionChildren();
        // add fn to main menu
        arrayAppend( menu, fnMenu );
        // get obj menu
        var objMenu = prepareObjectChildren();
        // add tag to main menu
        arrayAppend( menu, objMenu );
        // return it
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

    /**
     * Creates special hash mappings for submenus
     * @results {Array} Results array to parse
     * @type {String} The type of map to create
     * @position {String} Special formatting for key names
     * return Struct
     */
    private Struct function getHashMap( required Array results, required String type="slug", required String position="left" ) {
        var hashmap = createObject( "java", "java.util.LinkedHashMap" ).init();
        // loop over results, create
        for( var item in arguments.results ) {
            var text = arguments.type=="slug" ? item.getSlug() : item.getClass();
            switch( arguments.position ){
                case "left": 
                    hashmap [ ucase( left( text, 1 ) ) ] = [];
                    break;
                default:
                    hashmap [ text ] = [];
                    break;
            }
        }
        return hashmap; 
    }

    /**
     * Prepares tag-category items for menu insertion
     * return Struct
     */
    private Struct function prepareTagChildren() {
        // tags
        var tags = findAllWhere( criteria={ Category="tag" } );
        // tag children
        var tagnodes = getHashMap( results=tags, type="slug", position="left" );
        // loop over tags
        for( var tag in tags ) {
            var match = left( tag.getSlug(), 1 );
            var node = {
                "href" = tag.getSlug(),
                "text" = tag.getTitle(),
                "contentid" = tag.getResourceID(),
                "qtip" = tag.getTitle(),
                "leaf" = true
            };
            arrayAppend( tagnodes[ ucase( match ) ], node );
        }
        // add menu node
        var tagMenu = {
            "text" = "Tags",
            "children" = []
        };
        // loop over mapped nodes
        for( var map in tagnodes ) {
            arrayAppend( tagMenu.children, {
                "text" = map,
                "children" = tagnodes[ map ],
                "qtip" = map
            });
        }
        return tagMenu;
    }

    /**
     * Prepares fn-category items for menu insertion
     * return Struct
     */
    private Struct function prepareFunctionChildren() {
        // functions
        var functions = findAllWhere( criteria={ Category="function" } );
        // fn children
        var fnnodes = getHashMap( results=functions, type="slug", position="left" );
        // loop over tags
        for( var fn in functions ) {
            var match = left( fn.getSlug(), 1 );
            var node = {
                "href" = fn.getSlug(),
                "text" = fn.getTitle(),
                "contentid" = fn.getResourceID(),
                "qtip" = fn.getTitle(),
                "leaf" = true
            };
            arrayAppend( fnnodes[ ucase( match ) ], node );
        }
        // add menu node
        var fnMenu = {
            "text" = "Functions",
            "children" = []
        };
        // loop over mapped nodes
        for( var map in fnnodes ) {
            arrayAppend( fnMenu.children, {
                "text" = map,
                "children" = fnnodes[ map ],
                "qtip" = map
            });
        }
        return fnMenu;
    }

    /**
     * Prepares object-category items for menu insertion
     * return Struct
     */
    private Struct function prepareObjectChildren() {
        // objects
        var objects = findAllWhere( criteria={ Category="object" }, sortOrder="Class" );
        var objnodes = getHashMap( results=objects, type="class", position="full" );
        // loop over objects
        for( var obj in objects ) {
            var node = {
                "href" = obj.getSlug(),
                "text" = obj.getTitle(),
                "contentid" = obj.getResourceID(),
                "qtip" = obj.getTitle(),
                "leaf" = true
            };
            arrayAppend( objnodes[ obj.getClass() ], node );
        }
        // add menu node
        var objMenu = {
            "text" = "Objects",
            "children" = []
        };
        for( var map in objnodes ) {
            arrayAppend( objMenu.children, {
                "text" = map,
                "children" = objnodes[ map ],
                "qtip" = map
            });
        }
        return objMenu;
    }
}