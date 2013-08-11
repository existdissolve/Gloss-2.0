Ext.define('Gloss.store.resource.AdobeBug', {
    extend: 'Ext.data.Store',
    alias: 'store.resource.adobebug',
    requires: [
        'Ext.data.proxy.Rest',
        'Gloss.model.AdobeBug'
    ],
    model: 'Gloss.model.AdobeBug',
    storeId: 'AdobeBug_Resources',
    remoteSort: true,
    remoteFilter: true,
    constructor: function( cfg ){
        var me = this;
        cfg = cfg || {};
        me.callParent([Ext.apply({
            proxy: {
                type: 'rest',
                url: '/api/bug/adobebug',
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