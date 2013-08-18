component extends="coldbox.system.orm.hibernate.VirtualEntityService" {
    property name="cachebox" inject="cachebox";
    /**
     * Constructor
     */
    public UserService function init() {
        super.init( entityName="User" );        
        return this;
    }
}