Ext.define('Gloss.store.resource.CFLib', {
    extend: 'Ext.data.TreeStore',
    alias: 'store.resource.cflib',
    requires: [
        'Ext.data.proxy.Rest',
        'Gloss.model.Resource'
    ],
    model: 'Gloss.model.Resource',
    storeId: 'CFLib_Resources',
    constructor: function( cfg ){
        var me = this;
        cfg = cfg || {};
        me.callParent([Ext.apply({
            proxy: {
                type: 'rest',
                url: '/api/menu/cflib',
                reader: {
                    type: 'json'
                }
            }
        }, cfg)]);
    }
});