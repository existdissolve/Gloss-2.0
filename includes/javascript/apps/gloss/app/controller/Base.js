/**
 * Base controller for all controllers in the Gloss application
 */
Ext.define('Gloss.controller.Base', {
    extend: 'Ext.app.Controller',
    views: [],
    stores: [],
    init: function() {
        this.listen({
            controller: {},
            component: {},
            global: {},
            store: {}
        });
    }
});
