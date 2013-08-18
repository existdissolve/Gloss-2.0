component entityName="Note" table="Note" persistent=true {
    // primary key
    property name="NoteID" column="NoteID" fieldtype="id" generator="identity";
    // non-relational columns
    property name="Note" column="Note" ormtype="string";
    // one-to-one

    // one-to-many

    // many-to-one
    property name="Resource" column="ResourceID" fieldtype="many-to-one" cfc="cfgloss.model.orm.resource.Resource" fkcolumn="ResourceID";
    property name="User" column="UserID" fieldtype="many-to-one" cfc="cfgloss.model.orm.User" fkcolumn="UserID";
    // many-to-many

    // calculated properties

    // methods
    public Note function init() {
        return this;
    }
}