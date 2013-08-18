Ext.define('Gloss.view.Viewport', {
    extend: 'Ext.container.Viewport',
    requires:[
        'Gloss.view.layout.Center',
        'Gloss.view.layout.West',
        'Ext.layout.container.Border',
        'Ext.button.Split'
    ],
    layout: {
        type: 'border'
    },
    items: [
        {
            xtype: 'panel',
            region: 'north',
            height:30,
            width: 900,
            items: [
                {
                    xtype: 'panel',
                    id: 'user',
                    height:30,
                    width: 900
                }
            ]
        },
        {   
            xtype: 'layout.west'
        },
        {   
            xtype: 'layout.center'
        }
    ]
});
