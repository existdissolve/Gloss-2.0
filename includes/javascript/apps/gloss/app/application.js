Ext.define('Gloss.Application', {
    name: 'Gloss',
    requires: [
        'Ext.util.History',
        'Gloss.ux.form.field.plugin.ClearTrigger'
    ],
    extend: 'Ext.app.Application',
    controllers: [
        'App',
        'Navigation'
    ]
});
