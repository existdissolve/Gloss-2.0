Ext.define('Gloss.model.Resource', {
    extend: 'Ext.data.Model',
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
            name: 'target',
            type: 'string'
        },
        {
            name: 'Description', 
            type: 'string'
        },
        {
            name: 'Type', 
            type: 'string'
        },
        {
            name: 'text', 
            type: 'string'
        },
        {
            name: 'cls', 
            type: 'string'
        },
        {
            name: 'iconCls',
            type: 'string'
        },
        {
            name: 'leaf',
            type: 'boolean'
        }
    ]
});