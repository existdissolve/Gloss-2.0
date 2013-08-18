component entityName="User" table="User" persistent=true {
    // primary key
    property name="UserID" column="UserID" fieldtype="id" generator="identity";
    // non-relational columns
    property name="AppID" column="AppID" ormtype="string" notnull="true";
    property name="DisplayName" column="DisplayName" ormtype="string" notnull="true";
    property name="ImageURL" column="ImageURL" ormtype="string" notnull="true";
    property name="UserType" column="UserType" ormtype="string" notnull="true";
    // one-to-one

    // one-to-many

    // many-to-one

    // many-to-many

    // calculated properties

    // methods
    public User function init() {
        return this;
    }
}