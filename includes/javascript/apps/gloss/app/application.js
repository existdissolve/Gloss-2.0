Ext.define('Gloss.Application', {
    name: 'Gloss',
    requires: [
        'Ext.util.History',
        'Ext.data.JsonP',
        'Gloss.ux.form.field.plugin.ClearTrigger',
        'overrides.data.JsonP',
        'overrides.util.History'
    ],
    extend: 'Ext.app.Application',
    controllers: [
        'App',
        'Navigation',
        'Content'
    ]
});
