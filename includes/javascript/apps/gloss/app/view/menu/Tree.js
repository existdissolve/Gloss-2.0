Ext.define('Gloss.view.menu.Tree', {
    extend: 'Ext.tree.Panel',
    alias: 'widget.menu.tree',
    height: 600,
    width: 400,
    rootVisible: false,
    singleExpand: true,
    viewConfig: {
        loadingText: 'Loading...',
        deferEmptyText: false
    }
});