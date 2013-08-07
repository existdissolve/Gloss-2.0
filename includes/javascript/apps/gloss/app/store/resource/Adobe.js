Ext.define('Gloss.store.resource.Adobe', {
    extend: 'Ext.data.TreeStore',
    alias: 'store.resource.adobe',
    requires: [
        'Ext.data.proxy.Rest',
        'Gloss.model.Resource'
    ],
    model: 'Gloss.model.Resource',
    storeId: 'Adobe_Resources',
    constructor: function( cfg ){
        var me = this;
        cfg = cfg || {};
        me.callParent([Ext.apply({
            proxy: {
                type: 'rest',
                url: '/api/menu/adobe',
                reader: {
                    type: 'json'
                }
            }
        }, cfg)]);
    }
});