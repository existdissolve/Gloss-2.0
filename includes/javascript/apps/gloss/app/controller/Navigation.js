/**
 * Primary controller for navigation actions with the Gloss application
 */
Ext.define('Gloss.controller.Navigation', {
    extend: 'Gloss.controller.Base',
    views: [
        'menu.Tree',
        'grid.AdobeBug',
        'grid.RailoBug'
    ],
    stores: [
        'resource.Adobe',
        'resource.Railo',
        'resource.CFLib',
        'resource.AdobeBug',
        'resource.RailoBug'
    ],
    refs: [
        { ref:'CenterRegion', selector:'[xtype=layout.center]' },
        { ref:'AdobeBugGrid', selector:'[xtype=grid.adobebug' },
        { ref:'RailoBugGrid', selector:'[xtype=grid.railobug' }        
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
                },
                'treepanel#BugNav': {
                    itemclick: this.onBugNavClick
                },
                '[xtype=layout.center] grid[xtype*=bug]': {
                    beforerender: this.onBugGridLoad
                }
            },
            global: {},
            store: {}
        });
        this.callParent();
    },
    /**
     * Loads content for a selected navigation item
     * @param {Ext.data.Model} record
     * @param {String} type
     */
    loadContent: function( record, type ) {
        var me = this,
            itemId = record.get( 'ResourceID' );
        // make sure that this has content of some kind
        if( itemId > 0 ) {
            // check if this content already exists in the region
            if( me.contentExists( itemId ) ) {
                return false;
            }
            Ext.Ajax.request({
                url: '/api/content/' + type,
                method: 'GET',
                params: {
                    ResourceID: itemId
                },
                success: function( request, options ) {
                    var content = Ext.widget( 'panel', {
                        title: record.get( 'text' ),
                        html: Ext.decode( request.responseText ),
                        itemId: itemId
                    });
                    me.updateCenterContent( content, itemId );
                },
                failure: function( request, options ) {

                }
            });
        }
    },
    /**
     * Loads grid for the selected bug resource
     * @param {String} type
     */
    loadBugGrid: function( type ) {
        var me = this,
            targetXType = type=='AdobeBug' ? 'grid.adobebug' : 'grid.railobug';
        // create the widget
        var grid = Ext.widget( targetXType, {
            itemId: type
        });
        // add grid to center region
        me.updateCenterContent( grid, type );
    },
    /**
     * Smartly updates main center region of application with passed content
     * @param {Ext.Component} content
     * @param {String/Number} itemId
     */
    updateCenterContent: function( content, itemId ) {
        var me = this,
            center = me.getCenterRegion();

        // check if this content already exists in the region
        if( me.contentExists( itemId ) ) {
            return false;
        }
        // suspend layouts
        Ext.suspendLayouts();
        // remove and destroy all center region content
        center.removeAll( true );
        // add passed content
        center.add( content );
        // resume layouts and flush batched layout changes
        Ext.resumeLayouts( true );
    },
    /**
     * Checks if requested content has already been rendered
     * @param {String/Number} itemId
     */
    contentExists: function( itemId ) {
        var me = this,
            center = me.getCenterRegion();
        // return match
        return !Ext.isEmpty( center.down( '[itemId=' + itemId + ']' ) ) ? true : false;
    },
    /**
     * Handles click events on Bug menu items
     * @private
     * @param {Ext.view.View} view
     * @param {Ext.data.Model} record
     * @param HTMLElement item
     * @param {Number} index
     * @param {Ext.EventObject} e
     * @param {Object} eOpts
     */
    onBugNavClick: function( view, record, item, index, e, eOpts ) {
        var me = this,
            type = index==0 ? 'AdobeBug' : 'RailoBug';
        // stop the event
        e.stopEvent();
        
        // call load content
        me.loadBugGrid( type );
    },
    /**
     * Handles click events on Adobe menu items
     * @private
     * @param {Ext.view.View} view
     * @param {Ext.data.Model} record
     * @param HTMLElement item
     * @param {Number} index
     * @param {Ext.EventObject} e
     * @param {Object} eOpts
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
     * @param {Object} eOpts
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
     * @param {Object} eOpts
     */
    onCFLibNavClick: function( view, record, item, index, e, eOpts ) {
        var me = this;
        // stop the event
        e.stopEvent();
        // call load content
        me.loadContent( record, 'CFLib' );
    },
    /**
     * Handles grid render events for bug-based grids
     * @private
     * @param {Ext.grid.Panel} grid
     * @param {Object} eOpts
     */
    onBugGridLoad: function( grid, eOpts ) {
        var me = this,
            store = grid.getStore();
        // load store
        store.load();
    }
});
