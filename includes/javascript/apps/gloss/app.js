/**
 * @class Gloss
 * @singleton
 */
/*
    This file is generated and updated by Sencha Cmd. You can edit this file as
    needed for your application, but these edits will have to be merged by
    Sencha Cmd when upgrading.
*/

// DO NOT DELETE - this directive is required for Sencha Cmd packages to work.
//@require @packageOverrides

Ext.application({
    name: 'Gloss',
    extend: 'Gloss.Application',
    autoCreateViewport: false,
    launch: function( args ) {
        // "this" = Ext.app.Application
        var me = this;
        Ext.globalEvents.fireEvent( 'applicationready' );
    }
});
