Ext.define('Gloss.view.user.Widget', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.user.widget',
    layout: 'hbox',
    floating: true,
    bodyPadding: 24,
    width: 250,
    frame: true,
    initComponent: function() {
        var me = this;
        Ext.applyIf(me, {
            items: [
                {
                    xtype: 'image',
                    cls: 'avatar',
                    src: Gloss.app.user.imageURL50
                },
                {
                    xtype: 'panel',
                    flex: 1,
                    margins: '0 0 0 20',
                    layout: {
                        type:'vbox',
                        align: 'stretch'
                    },
                    items: [
                        {
                            xtype: 'button',
                            text: 'Bookmarks',
                            itemId: 'bookmarks'
                        },
                        {
                            xtype: 'button',
                            text: 'Notes',
                            itemId: 'notes'
                        }
                    ]
                }
            ],
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'bottom',
                    ui: 'footer',
                    items: [
                        '->',
                        {
                            xtype: 'button',
                            text: 'Logout',
                            itemId: 'logout'
                        }
                    ]
                }
            ]
        });
        me.callParent( arguments );
    }
})