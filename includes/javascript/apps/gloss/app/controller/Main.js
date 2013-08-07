Ext.define('Gloss.controller.Main', {
    extend: 'Ext.app.Controller',
    views: [
        'menu.Tree'
    ],
    stores: [
        'resource.Railo',
        'resource.Adobe',
        'resource.CFLib'
    ],
    init: function() {
        this.listen({
            controller: {},
            component: {},
            global: {},
            store: {}
        });
    }
});
