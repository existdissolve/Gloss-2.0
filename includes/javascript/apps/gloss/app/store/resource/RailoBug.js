Ext.define('Gloss.store.resource.RailoBug', {
    extend: 'Ext.data.Store',
    alias: 'store.resource.railobug',
    requires: [
        'Ext.data.proxy.Rest',
        'Gloss.model.RailoBug'
    ],
    model: 'Gloss.model.RailoBug',
    storeId: 'RailoBug_Resources',
    remoteSort: true,
    remoteFilter: true,
    constructor: function( cfg ){
        var me = this;
        cfg = cfg || {};
        me.callParent([Ext.apply({
            proxy: {
                type: 'rest',
                url: '/api/bug/railobug',
                limitParam: 'max',
                startParam: 'offset',
                sortParam: 'sortOrder',
                reader: {
                    type: 'json',
                    root: 'data',
                    totalProperty: 'total'
                }
            }
        }, cfg)]);
    }
});