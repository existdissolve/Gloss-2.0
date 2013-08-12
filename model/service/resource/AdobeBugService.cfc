component extends="coldbox.system.orm.hibernate.VirtualEntityService" {
    property name="jSoup" inject="javaLoader:org.jsoup.Jsoup";
    property name="cachebox" inject="cachebox";

    /**
     * Constructor
     */
    public AdobeBugService function init() {
        super.init( entityName="AdobeBug" );        
        return this;
    }

    /**
     * Retrieves content from cache or remote source
     * @resource {model.orm.resource.AdobeBug} The resource for which to retrieve content
     * return String
     */
    public String function getContent( required model.orm.resource.AdobeBug resource ) {
        var key = arguments.resource.buildContentCacheKey();
        var content = "";
        // get default cache
        var cache = cachebox.getDefaultCache();
        // if item exists in cache...
        if( cache.lookup( key ) ) {
            content = cache.get( key );
        }
        // not in cache; retrieve it remotely
        else {
            // parse html
            content = scrapeContent( resource.getLink() );
            // add to cache
            cache.set( key, content, 0 );
        }         
        return content;
    }

    /**
     * Updates content for Railo resources
     * @targets {String} The targets for the update (Defaults to all)
     */
    public Void function updateContent( required String targets="7770,9291,9290,9289,9288" ) {
        // loop over targets
        for( var target in targets ) {
            // each menu is a collection of data ready to be inserted
            var menu = scrapeBugs( target );
            // loop over menu items
            for( var item in menu ) {
                var criteria = {
                    "Slug" = item.slug
                };
                // see if this already exists
                var resource = findWhere( criteria=criteria );
                if( isNull( resource ) ) {
                    var resource = new();
                }
                // popluate with some data
                populate( target=resource, memento=item, nullEmptyInclude="*" );
                // save resource
                save( resource );
            }
        }
    }

    /**
     * Scrapes Adobe Bug tracker remote source
     * return Array
     */
    public Array function scrapeBugs( required String resource=7770 ) {
        // version hash
        var versions = {
            7770 = "10.0",
            9291 = "8.0",
            9290 = "8.0.1",
            9289 = "9.0",
            9288 = "9.0.1"
        };
        // tracking array
        var items = [];
        // http service
        var httpService = new http();
            httpService.setURL( "https://bugbase.adobe.com/index.cfm" );
            httpService.addParam( type="URL", name="event", value="qSearchBugs" );
            httpService.addParam( type="URL", name="page", value="1" );
            httpService.addParam( type="URL", name="pageSize", value="10000" );
            httpService.addParam( type="URL", name="type", value="Bugs" );
            httpService.addParam( type="URL", name="product", value="1149" );
            httpService.addParam( type="URL", name="version", value=arguments.resource );
        var result = deserializeJSON( replaceNoCase( httpService.send().getPrefix().fileContent, "//", "", "one" ) );
        // loop over results
        for( var item in result.query.data ) {
            arrayAppend( items, {
                "DefectID" = item[ 1 ],
                "Status" = item[ 2 ],
                "Reason" = item[ 3 ],
                "CreatedDate" = item[ 5 ],
                "Title" = item[ 4 ],
                "Slug" = item[ 1 ],
                "Version" = versions[ arguments.resource ],
                "Link" = "https://bugbase.adobe.com/index.cfm?event=bug&id=#item[ 1 ]#"
            });
        }
        return items;
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
        matchedHTML = jsoupDocument.select( "div.content" );
        // if we have a match...
        if( isArray( matchedHTML ) && arrayLen( matchedHTML ) ) {
            // define "remove" selectors
            var removeList = [ "div.notLoggedIn", "div##votes", "div##comment", "h3:contains(Attachments)", "div.listed.last" ];
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