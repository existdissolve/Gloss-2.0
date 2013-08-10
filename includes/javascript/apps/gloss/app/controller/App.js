/**
 * Main controller for all top-level application functionality
 */
 Ext.define('Gloss.controller.App', {
    extend: 'Gloss.controller.Base',
    views: [
        'Viewport'
    ],
    refs: [
        {
            ref: 'Viewport',
            selector: 'viewport'
        }
    ],
    init: function() {
        this.listen({
            controller: {},
            component: {},
            global: {
                applicationready: this.setupApplication
            },
            store: {}
        });
        this.callParent();
    },
    /**
     * Entry point for application. Renders the Viewport, and executes any other setup required for the application
     */
    setupApplication: function() {
        var me = this;
        // create the Viewport
        Ext.create( 'Gloss.view.Viewport' );
        // init Ext.util.History on app launch; if there is a hash in the url, our controller will load the appropriate content
        Ext.util.History.init(function(){
            var hash = document.location.hash;
            Ext.globalEvents.fireEvent( 'tokenchange', hash.replace( '#', '' ) );
        })
        // add change handler for Ext.util.History; when a change in the token
        // occurs, this will fire our controller's event to load the appropriate content
        Ext.util.History.on( 'change', function( token ){
            Ext.globalEvents.fireEvent( 'tokenchange', token );
        });
    },
    /**
     * Add history token to Ext.util.History
     * @param {String} token
     */
    addHistory: function( token ) {
        var me = this;
        if( !Ext.isEmpty( token ) && token != 'logout' ) {
            Ext.util.History.add( token );
        }
    }
 })