component displayname="RailoBugService" extends="coldbox.system.orm.hibernate.VirtualEntityService" {
    /**
     * Constructor
     */
    public RailoBugService function init() {   
        super.init( entityName="RailoBug" );          
        return this;
    }

    /**
     * Updates content for Railo Bug resources
     * @targets {String} The targets for the update (Defaults to all)
     */
    public Void function updateContent( required String targets="*" ) {
        deleteAll();
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
}