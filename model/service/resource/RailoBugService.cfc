component displayname="RailoBugService" extends="coldbox.system.orm.hibernate.VirtualEntityService" {
    property name="jSoup" inject="javaLoader:org.jsoup.Jsoup";
    property name="cachebox" inject="cachebox";

    /**
     * Constructor
     */
    public RailoBugService function init() {   
        super.init( entityName="RailoBug" );          
        return this;
    }

    /**
     * Retrieves content from cache or remote source
     * @resource {model.orm.resource.RailoBug} The resource for which to retrieve content
     * return String
     */
    public String function getContent( required model.orm.resource.RailoBug resource ) {
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
     * Updates content for Railo Bug resources
     * @targets {String} The targets for the update (Defaults to all)
     */
    public Void function updateContent( required String targets="*" ) {
        // each menu is a collection of data ready to be inserted
        var items = scrapeBugs();
        // loop over menu items
        for( var item in items ) {
            var criteria = {
                "Slug" = item.slug
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

    /**
     * Scrapes Railo Bug tracker remote source
     * return Array
     */
    public Array function scrapeBugs() {
        // create query string
        var defaultQuery = "project=RAILO AND issuetype=Bug AND resolution=Unresolved ORDER BY priority DESC";
        // http service
        var httpService = new http();
            httpService.setURL( "https://issues.jboss.org/sr/jira.issueviews:searchrequest-xml/temp/SearchRequest.xml" );
            httpService.addParam( type="URL", name="jqlQuery", value=defaultQuery );
            httpService.addParam( type="URL", name="tempMax", value=10000 );
        // get the results
        var result = xmlParse( httpService.send().getPrefix().fileContent ).rss.channel;
        // get the total
        var total = result.issue.XMLAttributes.total;
        // get matches
        var matches = xmlSearch( result, "item" );
        // items to return 
        var items = [];
        for( var match in matches ) {
            var item = {
                "Title" = xmlSearch( match, "title" )[ 1 ].XmlText,
                "Summary" = xmlSearch( match, "summary" )[ 1 ].XmlText,
                "Description" = xmlSearch( match, "description" )[ 1 ].XmlText,
                "Link" = xmlSearch( match, "link" )[ 1 ].XmlText,
                "Slug" = xmlSearch( match, "key" )[ 1 ].XmlText,
                "CreatedDate" = xmlSearch( match, "created" )[ 1 ].XmlText
            };
            arrayAppend( items, item );
        }
        return items;
    }

    /**
     * Scrapes content from remote page and processes with jSoup library
     * @url The url to scrapes
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
        matchedHTML = jsoupDocument.select( "div##issue-content" );
        // if we have a match...
        if( isArray( matchedHTML ) && arrayLen( matchedHTML ) ) {
            // define "remove" selectors
            var removeList = [ 
                ".twixi",
                "li##rowForcustomfield_12311040",
                "div##activitymodule",
                "div##greenhopper-agile-issue-web-panel",
                "div##heading-avatar",
                "ul.breadcrumbs",
                "div.command-bar",
                "img",
                ".status-view",
                "div##votes-val",
                "div##watchers-val",
                "fieldset.parameters",
                "div##wrap-labels",
                "div##attachmentmodule",
                "div##view-subtasks"
            ];
            // loop over remove selectors
            for( var item in removeList ) {
                var removeMatches = matchedHTML.select( item );
                // loop over matches
                for( var match in removeMatches ) {
                    if( item=="div##wrap-labels" ) {
                        var parent = match.parent();
                        parent.remove();
                    }
                    else {
                        // remove the match
                        match.remove();
                    }
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