Ext.define('Gloss.view.Navigation', {
    extend: 'Ext.container.Container',
    xtype: 'navigation',
    requires:[
        'Ext.tab.Panel',
        'Ext.layout.container.Border',
        'Ext.layout.container.Accordion',
        'Gloss.view.menu.Tree',
        'Gloss.view.Content'
    ],
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
                itemId: 'AdobeNav',
                title: 'Adobe ColdFusion',
                store: Ext.create( 'Gloss.store.resource.Adobe' ),
                width: 350,
                border: true
            },
            {
                xtype: 'menu.tree',
                itemId: 'RailoNav',
                title: 'Railo',
                store: Ext.create( 'Gloss.store.resource.Railo' ),
                width: 350,
                height: 350,
                border: true
            },
            {
                xtype: 'menu.tree',
                itemId: 'CFLibNav',
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
            xtype: 'content',
            title: 'Center Tab 1'
        }]
    }]
});