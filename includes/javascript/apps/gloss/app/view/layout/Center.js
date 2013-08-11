/**
 * Main content region for application
 */
Ext.define('Gloss.view.layout.Center', {
    extend: 'Ext.container.Container',
    alias: 'widget.layout.center',
    region: 'center',
    layout: 'fit',
    initComponent: function(){
        var me = this;
        Ext.applyIf(me,{

        });
        me.callParent( arguments );
    } 
});