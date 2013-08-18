component extends="coldbox.system.orm.hibernate.VirtualEntityService" {
    property name="cachebox" inject="cachebox";
    /**
     * Constructor
     */
    public BookmarkService function init() {
        super.init( entityName="Bookmark" );        
        return this;
    }
}