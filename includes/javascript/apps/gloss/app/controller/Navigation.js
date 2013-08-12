/**
 * Primary controller for navigation actions with the Gloss application
 */
Ext.define('Gloss.controller.Navigation', {
    extend: 'Gloss.controller.Base',
    views: [
        'menu.Tree',
        'grid.AdobeBug',
        'grid.RailoBug',
        'Bug'
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
        { ref:'AdobeBugGrid', selector:'[xtype=grid.adobebug]' },
        { ref:'RailoBugGrid', selector:'[xtype=grid.railobug]' },
        { ref:'BugBorder', selector:'[xtype=bug]' },
        { ref:'BugDetail', selector:'[itemId=Details]'}        
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
                },
                '[xtype=layout.center] grid[xtype=grid.adobebug]': {
                    itemclick: this.onAdobeBugGridItemClick
                },
                '[xtype=layout.center] grid[xtype=grid.railobug]': {
                    itemclick: this.onRailoBugGridItemClick
                },
                '[xtype=layout.center] grid[xtype*=bug] toolbar[dock=top] field': {
                    change: this.onBugGridSearch
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
     * Loads content for a selected bug
     * @param {Ext.data.Model} record
     * @param {String} type
     */
    loadBugContent: function( record, type ) {
        var me = this,
            itemId = record.get( 'ResourceID' );
        // make sure that this has content of some kind
        if( itemId > 0 ) {
            // check if this content already exists in the region
            if( me.contentExists( itemId ) ) {
                return false;
            }
            Ext.Ajax.request({
                url: '/api/bug/' + type + '/' + itemId,
                method: 'GET',
                success: function( request, options ) {
                    var detail = me.getBugDetail(),
                        title = type=='AdobeBug' ? 'Bug ' + record.get( 'DefectID' ) : record.get( 'Slug' );
                    // update detail panel
                    detail.update( Ext.decode( request.responseText ) );
                    // set title
                    detail.setTitle( title );
                    // expand if collapsed
                    detail.expand();
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
            targetXType = type=='AdobeBug' ? 'grid.adobebug' : 'grid.railobug',
            grid,
            border;
        // create the widget
        border = Ext.create( 'Gloss.view.Bug' );
        border.add({
            xtype: targetXType,
            region: 'center',
            itemId: type
        });
        // add grid to center region
        me.updateCenterContent( border, type );
    },
    /**
     * Applies filters to bug grid
     * @param {String} type
     * @param {Array} filters
     */
    searchBugGrid: function( type, filters ) {
        var me = this,
            grid = type=='AdobeBug' ? me.getAdobeBugGrid() : me.getRailoBugGrid(),
            store = grid.getStore();
        // silently clear filters
        store.clearFilter( true );
        // filter store
        store.filter( filters );
    },
    /**
     * Clears filters from bug grid
     * @param {String} type
     */
    clearBugGridSearch: function( type ) {
        var me = this,
            grid = type=='AdobeBug' ? me.getAdobeBugGrid() : me.getRailoBugGrid(),
            store = grid.getStore();
        // loudly clear filters
        store.clearFilter( false );
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
    },
    /**
     * Handles grid search changes
     * @private
     * @param {Ext.form.Field} field
     * @param {Object} newValue
     * @param {Object} oldValue
     * @param {Object} eOpts
     */
    onBugGridSearch: function( field, newValue, oldValue, eOpts ) {
        var me = this,
            grid = field.up( 'grid' ),
            type = grid.xtype=='grid.adobebug' ? 'AdobeBug' : 'RailoBug',
            fields = field.up( 'toolbar' ).query( 'field' ),
            filters = [];
        // loop over fields
        for( var i=0; i<fields.length; i++ ) {
            var field = fields[ i ];
            // if a value exists, add as a filter
            if( !Ext.isEmpty( field.getValue() ) ) {
                filters.push({
                    property: field.name,
                    value: field.getValue()
                });
            }
        }
        // if there are filters...
        if( filters.length ) {
            me.searchBugGrid( type, filters );
        }
        else {
            me.clearBugGridSearch( type );
        }
    },
    /**
     * Handles click events on Bug grid items
     * @private
     * @param {Ext.view.View} view
     * @param {Ext.data.Model} record
     * @param HTMLElement item
     * @param {Number} index
     * @param {Ext.EventObject} e
     * @param {Object} eOpts
     */
    onAdobeBugGridItemClick: function( view, record, item, index, e, eOpts ) {
        var me = this;
        me.loadBugContent( record, 'AdobeBug' );
    },
    /**
     * Handles click events on Bug grid items
     * @private
     * @param {Ext.view.View} view
     * @param {Ext.data.Model} record
     * @param HTMLElement item
     * @param {Number} index
     * @param {Ext.EventObject} e
     * @param {Object} eOpts
     */
    onRailoBugGridItemClick: function( view, record, item, index, e, eOpts ) {
        var me = this;
        me.loadBugContent( record, 'RailoBug' );
    }
});
