/**
 * Primary controller for navigation actions with the Gloss application
 */
Ext.define('Gloss.controller.Navigation', {
    extend: 'Gloss.controller.Base',
    views: [
        'menu.Tree',
        'Navigation',
        'Content'
    ],
    refs: [
        { ref:'Content', selector:'[xtype=content]' }
    ],
    init: function() {
        this.listen({
            controller: {},
            component: {
                'treepanel#AdobeNav': {
                    itemclick: this.onAdobeNavClick
                },
                'treepanel#RailoNav ': {
                    itemclick: this.onRailoNavClick
                },
                'treepanel#CFLibNav': {
                    itemclick: this.onCFLibNavClick
                }
            },
            global: {},
            store: {}
        });
        this.callParent();
    },
    /**
     * Handles click events on Adobe menu items
     * @private
     * @param {Ext.view.View} view
     * @param {Ext.data.Model} record
     * @param HTMLElement item
     * @param {Number} index
     * @param {Ext.EventObject} e
     * @param {Object}
     */
    onAdobeNavClick: function( view, record, item, index, e, eOpts ) {
        var me = this;
        // stop the event
        e.stopEvent();
        // call load content
        me.loadContent( record, 'Adobe' );
    },
    /**
     * Handles click events on Railo menu items
     * @private
     * @param {Ext.view.View} view
     * @param {Ext.data.Model} record
     * @param HTMLElement item
     * @param {Number} index
     * @param {Ext.EventObject} e
     * @param {Object}
     */
    onRailoNavClick: function( view, record, item, index, e, eOpts ) {
        var me = this;
        // stop the event
        e.stopEvent();
        // call load content
        me.loadContent( record, 'Railo' );
    },
    /**
     * Handles click events on CFLib menu items
     * @private
     * @param {Ext.view.View} view
     * @param {Ext.data.Model} record
     * @param HTMLElement item
     * @param {Number} index
     * @param {Ext.EventObject} e
     * @param {Object}
     */
    onCFLibNavClick: function( view, record, item, index, e, eOpts ) {
        var me = this;
        // stop the event
        e.stopEvent();
        // call load content
        me.loadContent( record, 'CFLib' );
    },
    /**
     * Loads content for a selected navigation item
     * @param {Ext.data.Model}
     * @param {String}
     */
    loadContent: function( record, type ) {
        var me = this,
            content = me.getContent();
        // make sure that this has content of some kind
        if( record.get( 'contentid' ) > 0 ) {
            Ext.Ajax.request({
                url: '/api/content/' + type,
                method: 'GET',
                params: {
                    ResourceID: record.get( 'contentid' )
                },
                success: function( request, options ) {
                    var text = request.responseText;
                    content.setTitle( record.get( 'text' ) );
                    content.update( Ext.decode( text ) );
                },
                failure: function( request, options ) {

                }
            });
        }
    }
});
