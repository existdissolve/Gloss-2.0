Ext.define('Gloss.view.grid.AdobeBug', {
    extend: 'Ext.grid.Panel',
    alias: 'widget.grid.adobebug',
    requires: [
        'Ext.grid.column.Date',
        'Ext.toolbar.Paging'
    ],
    viewConfig: {
        deferEmptyText: false,
        emptyText: 'Sorry, no bugs matched your search criteria!',
        markDirty: false
    },
    initComponent: function() {
        var me = this,
            store = Ext.create( 'Gloss.store.resource.AdobeBug' );
        Ext.applyIf(me, {
            store: store,
            columns: {
                items: [
                    {
                        text: 'Defect ID',
                        dataIndex: 'DefectID'
                    },
                    {
                        text: 'Title',
                        dataIndex: 'Title',
                        flex: 1
                    },
                    {
                        text: 'Status',
                        dataIndex: 'Status'
                    },
                    {
                        text: 'Reason',
                        dataIndex: 'Reason'
                    },
                    {
                        text: 'Version',
                        dataIndex: 'Version'
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