Ext.define('Gloss.store.Resources', {
    extend: 'Ext.data.TreeStore',
    alias: 'store.resource',
    storeId: 'Resources',
    autoLoad: true,
    root: {
        expanded: false
    },
    menuType: null,
    constructor: function( cfg ){
        var me = this;
        cfg = cfg || {};
        me.callParent([Ext.apply({
            proxy: {
                type: 'rest',
                url: '/api/menu/' + me.menuType
            }
        }, cfg)]);
    }
});