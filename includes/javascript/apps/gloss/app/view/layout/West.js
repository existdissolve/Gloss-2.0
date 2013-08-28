/**
 * West (sidebar) region for use within application
 */
Ext.define('Gloss.view.layout.West', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.layout.west',
    requires: [
        'Ext.layout.container.Accordion',
        'Gloss.view.menu.Tree',
        'Gloss.view.Content'
    ],
    region: 'west',
    split: true,
    bodyPadding: 5,
    minWidth: 200,
    width: 300,
    layout: 'accordion',
    border: true,
    initComponent: function(){
        var me = this;
        Ext.applyIf(me,{
            items: [
                {
                    xtype: 'menu.tree',
                    collapsed: true,
                    itemId: 'Adobe',
                    title: 'Adobe ColdFusion',
                    store: Ext.create( 'Gloss.store.resource.Adobe' )
                },
                {
                    xtype: 'menu.tree',
                    itemId: 'Railo',
                    title: 'Railo',
                    store: Ext.create( 'Gloss.store.resource.Railo' )
                },
                {
                    xtype: 'menu.tree',
                    itemId: 'CFLib',
                    title: 'CFLib.org',
                    store: Ext.create( 'Gloss.store.resource.CFLib' )
                },
                {
                    xtype: 'menu.tree',
                    itemId: 'BugNav',
                    title: 'Bug Trackers',
                    store: Ext.create( 'Ext.data.TreeStore', {
                        root: {
                            expanded: true,
                            children: [
                                { text: 'Adobe ColdFusion Bug Tracker', leaf: true, itemId: 'Adobe' },
                                { text: 'Railo Issue Tracker', leaf: true, itemId: 'Railo' }
                            ]
                        }
                    })
                }
            ]
        });
        me.callParent( arguments );
    } 
});