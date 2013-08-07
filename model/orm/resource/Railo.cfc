component entityName="Railo" table="Railo" extends="Resource" persistent="true" joinColumn="ResourceID" {
    // non-relational columns
    property name="Category" column="Category" ormtype="string" notnull="true";
    property name="Class" column="Class" ormtype="string";
    // one-to-one

    // one-to-many

    // many-to-one

    // many-to-many

    // calculated properties

    // methods
    public Railo function init() {
        return this;
    }
}