/**
 * Main controller for all top-level application functionality
 */
 Ext.define('Gloss.controller.App', {
    extend: 'Gloss.controller.Base',
    views: [
        'Viewport',
        'user.Widget'
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
            component: {
                'button#logout': {
                    click: this.handleLogout
                },
                '[xtype=menu.tree]': {
                    itemclick: this.addHistory
                }
            },
            global: {
                applicationready: this.setupApplication,
                loggedin: this.handleLogin,
                tokenchange: this.dispatch
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
        // show signin button
        var obj = Ext.DomHelper.createHtml( {
            id: 'signinButton',
            tag: 'span',
            children: [
                {
                    tag: 'span',
                    cls: 'g-signin',
                    'data-callback': 'signinCallback',
                    'data-clientid': '844440950130.apps.googleusercontent.com',
                    'data-cookiepolicy': 'single_host_origin',
                    'data-requestvisibleactions': 'http://schemas.google.com/AddActivity',
                    'data-scope': 'https://www.googleapis.com/auth/plus.login'
                }
            ]
        })
        Ext.getCmp( 'user' ).update( obj.toString() )
    },
    /**
     * Add history token to Ext.util.History
     * @param {Ext.tree.View} treeview
     * @param {Ext.data.Model} record
     * @param HTMLElement item
     * @param {Number} index
     * @param {Ext.EventObject} e
     * @param {Object} eOpts
     */
    addHistory: function( treeview, record, item, e, eOpts ) {
        var me = this,
            token = record.get( 'href' ).toLowerCase(),
            type = treeview.up( 'treepanel' ).itemId.toLowerCase(),
            newToken = type + '/' + token;
        if( !Ext.isEmpty( token ) ) {
            Ext.util.History.add( newToken, true, true );
            Ext.globalEvents.fireEvent( 'dispatch', newToken );
            Ext.globalEvents.fireEvent( 'historyadd', treeview.store, treeview.node, record, true, eOpts );
        }
    },
    /**
     * Handles token change and directs creation of content in center region
     * @param {String} token
     */
    dispatch: function( token ) {
        var me = this;
        Ext.globalEvents.fireEvent( 'dispatch', token );
    },
    /**
     * Post Google+ login
     * @param {Object} authResult
     */
    handleLogin: function( authResult ) {
        var me = this,
            spec;
        // add token to Gloss application
        Gloss.app.user.access_token = authResult.access_token;
        Gloss.app.user.client_id = authResult.client_id;
        // request details about user
        gapi.client.load( 'plus', 'v1', function(){
            var request = gapi.client.plus.people.get({
                'userId': 'me'
            });
            request.execute( function( response ) {
                console.log( response )
                // set more details into app
                Gloss.app.user.displayName = response.displayName;
                Gloss.app.user.nickname = response.nickname;
                Gloss.app.user.imageURL50 = response.image.url;
                Gloss.app.user.imageURL16 = response.image.url.replace( '50', '16' );
                Gloss.app.user.id = response.id;
                // now that we have the data, we need to either register the user or update existing user
                Ext.Ajax.request({
                    url: '/api/user/',
                    method: 'POST',
                    params: {
                        AppID: response.id,
                        DisplayName: response.displayName,
                        ImageURL: response.image.url,
                        UserType: 'Google+'
                    },
                    success: function( response, opts ) {
                        console.log( response.responseText );
                        // add user button and menu
                        Ext.getCmp( 'user' ).add({
                            xtype: 'splitbutton',
                            text: Gloss.app.user.displayName,
                            icon: Gloss.app.user.imageURL16,
                            menu: Ext.create('Gloss.view.user.Widget')
                        })
                    }
                })
            });
        });
    },
    /**
     * Log the user out and revoke access for application
     */
    handleLogout: function() {
        Ext.data.JsonP.request({
            url: 'https://accounts.google.com/o/oauth2/revoke',
            timeout: 1000,
            params: {
                token: Gloss.app.user.access_token
            },
            callback: function() {
                Ext.getCmp( 'user' ).down( 'splitbutton' ).destroy();
                Ext.get( 'signinButton' ).setDisplayed( true );
            },
            error: function( e ) {
                console.log( 'fail' )
            }
        });
    }
 })