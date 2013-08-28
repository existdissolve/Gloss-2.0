/**
 * Primary controller for content management and interactions with the Gloss application
 */
Ext.define('Gloss.controller.Content', {
    extend: 'Gloss.controller.Base',
    views: [
        'content.View'
    ],
    stores: [],
    refs: [
        { ref:'CenterRegion', selector:'[xtype=layout.center]' },
        { ref:'ContentView', selector:'[xtype=content.view]' }
    ],
    init: function() {
        this.listen({
            controller: {},
            component: {
                'toolbar menuitem#googleplus': {
                    click: this.onShareClick
                }
            },
            global: {},
            store: {}
        });
        this.callParent();
    },
    /**
     * Handles share clicks
     * @private
     * @param {Ext.menu.Item} item
     * @param {Ext.EventObject} e
     * @param {Object} eOpts
     */
    onShareClick: function( item, e, eOpts ) {
        switch( item.itemId ) {
            case 'googleplus':
                var meta = Ext.select( 'meta[property*=og]' );
                meta.each(function( el, c, index ) {
                    var attribute = el.getAttribute( 'property' );
                    switch( attribute ) {
                        case 'og:title':
                            el.set({
                                content: 'Some new title'
                            });
                            break;
                        case 'og:description':
                            el.set({
                                content: 'Some new description'
                            });
                            break;
                    }
                });
                break;
            case 'facebook':
                break;
            case 'twitter':
                break;
        }
        window.open("https://plus.google.com/share?url=http://cfgloss.com/cartracker/includes/javascript/apps/cartracker/#inventory","","menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=600,width=600")
    }
});
