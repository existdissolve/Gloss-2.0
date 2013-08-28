<!DOCTYPE html>
<html>
    <head>
        <cfoutput>
            <cfset description = structKeyExists( rc.content, "getDescription" ) && !isNull( rc.content.getDescription() ) ? rc.content.getDescription() : "" >
            <title>#rc.content.getTitle()#</title>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <meta property="og:title" content="#rc.content.getTitle()#" />
            <meta property="og:image" content="" />
            <meta property="og:description" content="#description#" />
            <meta property="og:url" content="http://cfgloss.com/#lcase( rc.type )#/#rc.content.getResourceID()#" />
            <meta property="og:type" content="website" />
            <meta property="site_name" content="CFGloss" />
        </cfoutput>
    </head>
    <body></body>
</html>
