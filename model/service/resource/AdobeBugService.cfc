component extends="coldbox.system.orm.hibernate.VirtualEntityService" {
    /**
     * Constructor
     */
    public AdobeBugService function init() {
        super.init( entityName="AdobeBug" );        
        return this;
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
        /*https://bugbase.adobe.com/index.cfm?event=qSearchBugs&page=2&pageSize=25&gridsortcolumn=&gridsortdirection=ASC&type=Bugs&product=1149&version=7770&prodArea=null&state=null&status=null&reason=null&numFiles=&numFilesOp=%3D&numVotes=&numVotesOp=%3D&creationDate=&creationDateOp=%3D&priority=null&failureType=null&frequency=null&reportedBy=&fixedInBuild=&foundInBuild=&appLanguage=%2D&osLanguage=%2D&platform=%2D&browser=%2D&title=&description=&testConfig=&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=A950058665A294BBED9D77598D34F009&_cf_rc=17*/
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
}


















