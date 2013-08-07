component output="false" {    property name="RailoService" inject;    property name="AdobeService" inject;    property name="CFLibService" inject;    public void function index( required Any event, required Struct rc, required Struct prc ) {        var menu = RailoService.scrapeMenu();        writedump( menu );        abort;    abort;        var httpService = new http();            httpService.setURL( "https://issues.jboss.org/sr/jira.issueviews:searchrequest-xml/temp/SearchRequest.xml" );            httpService.addParam( type="URL", name="jqlQuery", value="project = RAILO AND issuetype = Bug AND resolution = Unresolved ORDER BY priority DESC" );            httpService.addParam( type="URL", name="tempMax", value="10" );        var result = xmlParse( httpService.send().getPrefix().fileContent ).rss.channel;        var total = result.issue.XMLAttributes.total;        var items = [];        var matches = xmlSearch( result, "item" );        for( var match in matches ) {            var item = {                "Title" = xmlSearch( match, "title" )[ 1 ].XmlText,                "Summary" = xmlSearch( match, "summary" )[ 1 ].XmlText,                "Description" = xmlSearch( match, "description" )[ 1 ].XmlText,                "Link" = xmlSearch( match, "link" )[ 1 ].XmlText,                "Key" = xmlSearch( match, "key" )[ 1 ].XmlText            };            arrayAppend( items, item );        }        writedump( items );        abort;        /*var q = new query();            q.setDataSource( 'gloss' );            q.setSql( "SELECT * FROM TempMenu" );        var result = q.execute().getResult();        var menu = deserializeJSON( result.menu );        writedump( menu );        abort;        var httpService = new http();            httpService.setURL( "https://learn.adobe.com/#menu[2].children[ 2 ].href#" );        var result = httpService.send().getPrefix().fileContent;        writedump( reReplaceNoCase( result, '.*?(<div id="main-content" class="wiki-content">.*?</div>).*$', "\1", "all" ) );        abort;*/        var menu = CFLibService.buildMenu();        writedump( serializeJSON( menu ) );        abort;        /** ADOBE **/        AdobeService.updateContent();        abort;        /** RAILO **/        RailoService.updateContent();        abort;    }    public Array function buildTree( required Any tree=[], required String pageId="91357268", counter=0 ) {        var httpService = new http();            httpService.setURL( "https://learn.adobe.com/wiki/pages/children.action?pageId=#arguments.pageId#" );        var result = httpService.send().getPrefix().fileContent;        var menu = deserializeJSON( result );                for( var item in menu ) {            // create node            var node = {                "href" = item.href,                "id" = item.pageId,                "text" = item.text,                "children" = []            };            if( structKeyExists( item, "position" ) && item.position != "undefined" ) {                try {                    node.children = buildTree( pageId=item.pageId, counter=counter++ );                 }                catch( any e ) {                    writedump( e );                    abort;                }            }                        arrayAppend( arguments.tree, node );        }        return arguments.tree;    }}