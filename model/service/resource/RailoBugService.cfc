component displayname="RailoBugService" {
    /**
     * Constructor
     */
    public RailoBugService function init() {       
        return this;
    }

    public Array function searchBugs( required Numeric page, required String query="" ) {
        // create query string
        var defaultQuery = "project=RAILO AND issuetype=Bug AND resolution=Unresolved";
        if( arguments.query != "" ) {
            defaultQuery &= " AND text ~ 'query'";
        }
        defaultQuery &= " ORDER BY priority DESC";
        // http service
        var httpService = new http();
            httpService.setURL( "https://issues.jboss.org/sr/jira.issueviews:searchrequest-xml/temp/SearchRequest.xml" );
            httpService.addParam( type="URL", name="jqlQuery", value=defaultQuery );
            httpService.addParam( type="URL", name="tempMax", value=20 );
        // get the results
        var result = xmlParse( httpService.send().getPrefix().fileContent ).rss.channel;
        // get the total
        var total = result.issue.XMLAttributes.total;
        // get matches
        var matches = xmlSearch( result, "item" );
        // items to return 
        var items = [];
        writedump( total );
        for( var match in matches ) {
            var item = {
                "Title" = xmlSearch( match, "title" )[ 1 ].XmlText,
                "Summary" = xmlSearch( match, "summary" )[ 1 ].XmlText,
                "Description" = xmlSearch( match, "description" )[ 1 ].XmlText,
                "Link" = xmlSearch( match, "link" )[ 1 ].XmlText,
                "Key" = xmlSearch( match, "key" )[ 1 ].XmlText
            };
            arrayAppend( items, item );
        }
        writedump( items );
        abort;
    }
}