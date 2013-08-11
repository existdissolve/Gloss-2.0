Ext.define("Gloss.model.RailoBug", {
    extend: "Ext.data.Model",
    fields: [
        {
            name: 'ResourceID',
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
            name: 'Summary',
            type: 'string'
        },
        {
            name: 'CreatedDate',
            type: 'date'
        }
    ]
});