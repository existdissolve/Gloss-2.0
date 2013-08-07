component entityName="CFLib" table="CFLib" extends="Resource" persistent="true" joinColumn="ResourceID" {
    // non-relational columns
    property name="Library" column="Library" ormtype="string" notnull="true";
    property name="PageID" column="PageID" ormtype="integer" notnull="true";
    property name="Description" column="Description" ormtype="string";
    // one-to-one

    // one-to-many

    // many-to-one

    // many-to-many

    // calculated properties

    // methods
    public CFLib function init() {
        return this;
    }
}