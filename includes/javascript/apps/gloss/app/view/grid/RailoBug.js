Ext.define('Gloss.view.grid.RailoBug', {
    extend: 'Ext.grid.Panel',
    alias: 'widget.grid.railobug',
    requires: [
        'Ext.grid.column.Date',
        'Ext.toolbar.Paging'
    ],
    title: 'Railo Issue Tracker',
    viewConfig: {
        deferEmptyText: false,
        emptyText: 'Sorry, no bugs matched your search criteria!',
        markDirty: false
    },
    initComponent: function() {
        var me = this,
            store = Ext.create( 'Gloss.store.resource.RailoBug' );
        Ext.applyIf(me, {
            store: store,
            columns: {
                items: [
                    {
                        text: 'Slug',
                        dataIndex: 'Slug'
                    },
                    {
                        text: 'Title',
                        dataIndex: 'Title',
                        flex: 1
                    },
                    {
                        text: 'Summary',
                        dataIndex: 'Summary',
                        flex: 1
                    },
                    {
                        xtype: 'datecolumn',
                        text: 'Created',
                        dataIndex: 'CreatedDate',
                        format: 'Y-m-d'
                    }
                ]
            },
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    ui: 'footer',
                    items: [
                        {
                            xtype: 'triggerfield',
                            name: 'Query',
                            fieldLabel: 'Search',
                            labelWidth:50,
                            plugins: [
                                { ptype: 'cleartrigger' }
                            ]
                        }
                    ]
                },
                {
                    xtype: 'pagingtoolbar',
                    ui: 'footer',
                    defaultButtonUI: 'default',
                    dock: 'bottom',
                    displayInfo: true,
                    store: store
                }
            ]            
        });
        me.callParent( arguments );
    }
});