component extends="coldbox.system.orm.hibernate.VirtualEntityService" {
    property name="cachebox" inject="cachebox";
    /**
     * Constructor
     */
    public NoteService function init() {
        super.init( entityName="Note" );        
        return this;
    }
}