Ext.define('Gloss.view.content.View', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.content.view',
    initComponent: function() {
        var me = this;
        Ext.applyIf(me, {
            dockedItems: [
                {
                    xtype: 'toolbar',
                    ui: 'footer',
                    items: [
                        {
                            xtype: 'splitbutton',
                            glyph:'118@sencha-tools',
                            text: 'Share It',
                            menu: [
                                {
                                    text: 'Google+',
                                    iconCls: 'icon-google-plus',
                                    itemId: 'googleplus'
                                },
                                {
                                    text: 'Facebook',
                                    iconCls: 'icon-facebook-sign',
                                    itemId: 'facebook'
                                },
                                {
                                    text: 'Twitter',
                                    iconCls: 'icon-twitter',
                                    itemId: 'twitter'
                                }
                            ]
                        },
                        {
                            xtype: 'button',
                            itemId: 'bookmark',
                            iconCls: 'icon-bookmark',
                            text: 'Bookmark It'
                        },
                        ,
                        {
                            xtype: 'button',
                            itemId: 'note',
                            iconCls: 'icon-pencil',
                            text: 'Note It'
                        }
                    ]
                }
            ]
        });
        me.callParent( arguments );
    }
});