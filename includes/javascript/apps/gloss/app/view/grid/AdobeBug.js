Ext.define('Gloss.view.grid.AdobeBug', {
    extend: 'Ext.grid.Panel',
    alias: 'widget.grid.adobebug',
    requires: [
        'Ext.grid.column.Date',
        'Ext.toolbar.Paging',
        'Ext.form.field.ComboBox',
        'Ext.form.Panel',
        'Ext.form.field.Text'
    ],
    title: 'Adobe ColdFusion Bug Tracker',
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
                        },
                        {
                            xtype: 'combobox',
                            name: 'Version',
                            displayField: 'text',
                            valueField: 'value',
                            fieldLabel: 'Version',
                            store: Ext.create('Ext.data.Store', {
                                fields: [ 'text', 'value' ],
                                data: [
                                    { text:'10.0', value:'10.0' },
                                    { text:'9.0.1', value:'9.0.1' },
                                    { text:'9.0', value:'9.0' },
                                    { text:'8.0.1', value:'8.0.1' },
                                    { text:'8.0', value:'8.0' }
                                ]
                            }),
                            plugins: [
                                { ptype: 'cleartrigger' }
                            ],
                            labelWidth:50
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