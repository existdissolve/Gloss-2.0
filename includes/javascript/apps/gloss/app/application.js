Ext.define('Gloss.Application', {
    name: 'Gloss',
    requires: [
        'Ext.util.History'
    ],
    extend: 'Ext.app.Application',
    controllers: [
        'App',
        'Navigation'
    ],
    stores: [
        'resource.Adobe',
        'resource.Railo',
        'resource.CFLib'
    ]
});
