Ext.define("Gloss.model.Resource", {
    extend: "Ext.data.Model",
    fields: [
        {name: "contentid", type: "int"},
        {name: "title", type: "string"},
        {name: "target",type:"string"},
        {name: "description", type: "string"},
        {name: "type", type: "string"},
        {name: "text", type: "string"},
        {name: "cls", type:"string"},
        {name: "iconCls",type:"string"},
        {name: "leaf",type:"boolean"}
    ]
});