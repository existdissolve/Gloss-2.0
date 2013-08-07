component entityName="CFBug" table="CFBug" extends="Resource" persistent="true" joinColumn="ResourceID" {
    // non-relational columns
    property name="DefectID" column="DefectID" ormtype="integer" notnull="true";
    property name="Status" column="Status" ormtype="string" notnull="true";
    property name="Reason" column="Reason" ormtype="string";
    property name="CreatedDate" column="CreatedDate" ormtype="timestamp";
    // one-to-one

    // one-to-many

    // many-to-one

    // many-to-many

    // calculated properties

    // methods
    public CFBug function init() {
        return this;
    }
}