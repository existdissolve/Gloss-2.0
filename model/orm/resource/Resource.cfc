component entityName="Resource" table="Resource" persistent=true {
    // primary key
    property name="ResourceID" column="ResourceID" fieldtype="id" generator="identity";
    // non-relational columns
    property name="Slug" column="Slug" ormtype="string" notnull="true";
    property name="Link" column="Link" ormtype="string" notnull="true";
    property name="Title" column="Title" ormtype="string" notnull="true";
    // one-to-one

    // one-to-many

    // many-to-one

    // many-to-many

    // calculated properties

    // methods
    public Resource function init() {
        return this;
    }
}