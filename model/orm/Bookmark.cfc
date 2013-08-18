component entityName="Bookmark" table="Bookmark" persistent=true {
    // primary key
    property name="BookmarkID" column="BookmarkID" fieldtype="id" generator="identity";
    // non-relational columns

    // one-to-one

    // one-to-many

    // many-to-one
    property name="Resource" column="ResourceID" fieldtype="many-to-one" cfc="cfgloss.model.orm.resource.Resource" fkcolumn="ResourceID";
    property name="User" column="UserID" fieldtype="many-to-one" cfc="cfgloss.model.orm.User" fkcolumn="UserID";
    // many-to-many

    // calculated properties

    // methods
    public Bookmark function init() {
        return this;
    }
}