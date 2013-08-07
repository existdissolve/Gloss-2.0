Ext.define('Gloss.view.Main', {
    extend: 'Ext.container.Container',
    requires:[
        'Ext.tab.Panel',
        'Ext.layout.container.Border',
        'Ext.layout.container.Accordion',
        'Gloss.view.menu.Tree'
    ],
    
    xtype: 'app-main',

    layout: {
        type: 'border'
    },

    items: [{
        region: 'west',
        xtype: 'panel',
        width: 350,
        height: 700,
        layout: 'accordion',
        border: true,
        items: [
            {
                xtype: 'menu.tree',
                title: 'Adobe ColdFusion',
                store: Ext.create( 'Gloss.store.resource.Adobe' ),
                width: 350,
                border: true
            },
            {
                xtype: 'menu.tree',
                title: 'Railo',
                store: Ext.create( 'Gloss.store.resource.Railo' ),
                width: 350,
                height: 350,
                border: true
            },
            {
                xtype: 'menu.tree',
                title: 'CFLib.org',
                store: Ext.create( 'Gloss.store.resource.CFLib' ),
                width: 350,
                height: 350,
                border: true
            }
        ]
    },{
        region: 'center',
        xtype: 'tabpanel',
        items:[{
            title: 'Center Tab 1'
        }]
    }]
});