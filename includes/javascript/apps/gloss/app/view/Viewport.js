Ext.define('Gloss.view.Viewport', {
    extend: 'Ext.container.Viewport',
    requires:[
        'Ext.layout.container.Fit',
        'Gloss.view.Navigation'
    ],
    layout: {
        type: 'fit'
    },
    items: [{
        xtype: 'navigation'
    }]
});
