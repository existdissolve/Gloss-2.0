Ext.define('Gloss.view.Viewport', {
    extend: 'Ext.container.Viewport',
    requires:[
        'Gloss.view.layout.Center',
        'Gloss.view.layout.West',
        'Ext.layout.container.Border'
    ],
    layout: {
        type: 'border'
    },
    items: [
        {   
            xtype: 'layout.west'
        },
        {   
            xtype: 'layout.center'
        }
    ]
});
