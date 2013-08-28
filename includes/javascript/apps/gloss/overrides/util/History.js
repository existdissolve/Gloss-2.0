Ext.define('overrides.util.History', {
    override: 'Ext.util.History',
    suppressChange : false,
    add: function ( token, preventDup, suppressChange ) {
        var me = this;
        this.suppressChange = suppressChange ? true : false;
        if (preventDup !== false) {
            if (me.getToken() === token) {
                return true;
            }
        }
        if (me.oldIEMode) {
            return me.updateIFrame(token);
        } else {
            me.setHash(token);
            return true;
        }
    },
    handleStateChange: function(token) {
        this.currentToken = token;
        // only fire "change" event if suppressChange is false
        if (!this.suppressChange) { 
            this.fireEvent('change', token); 
        }
        // now just reset the suppressChange flag 
        this.suppressChange = false;
    }
});