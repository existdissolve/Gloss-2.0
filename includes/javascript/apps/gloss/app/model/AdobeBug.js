Ext.define('Gloss.model.AdobeBug', {
    extend: 'Ext.data.Model',
    idProperty: 'ResourceID',
    fields: [
        {
            name: 'ResourceID',
            type: 'int'
        },
        {
            name: 'DefectID',
            type: 'int'
        },
        {
            name: 'Title',
            type: 'string'
        },
        {
            name: 'Slug',
            type: 'string'
        },
        {
            name: 'Link',
            type: 'string'
        },
        {
            name: 'Status',
            type: 'string'
        },
        {
            name: 'Reason',
            type: 'string'
        },
        {
            name: 'Version',
            type: 'string'
        },
        {
            name: 'CreatedDate',
            type: 'date'
        }
    ]
});