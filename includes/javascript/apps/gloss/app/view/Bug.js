Ext.define('Gloss.view.Bug', {
    extend: 'Ext.container.Container',
    alias: 'widget.bug',
    layout: 'border',
    initComponent: function(){
        var me = this;
        Ext.applyIf(me, {
            items: [
                {
                    xtype: 'panel',
                    itemId: 'Details',
                    region: 'south',
                    title: 'Details',
                    minHeight:250,
                    maxHeight:400,
                    autoScroll: true,
                    collapsed: true,
                    collapsible: true,
                    split: true
                },
                {
                    xtype: 'panel',
                    region: 'east',
                    title: 'Comments',
                    minWidth:200,
                    collapsed: true,
                    collapsible: true,
                    split: true
                }
            ]
        });
        me.callParent( arguments );
    }
})