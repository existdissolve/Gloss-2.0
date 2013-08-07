Ext.define('Gloss.store.resource.Railo', {
    extend: 'Ext.data.TreeStore',
    alias: 'store.resource.railo',
    requires: [
        'Ext.data.proxy.Rest',
        'Gloss.model.Resource'
    ],
    model: 'Gloss.model.Resource',
    storeId: 'Railo_Resources',
    constructor: function( cfg ){
        var me = this;
        cfg = cfg || {};
        me.callParent([Ext.apply({
            proxy: {
                type: 'rest',
                url: '/api/menu/railo',
                reader: {
                    type: 'json'
                }
            }
        }, cfg)]);
    }
});