component entityName="RailoBug" table="RailoBug" extends="Resource" persistent="true" joinColumn="ResourceID" {
    // non-relational columns
    property name="Summary" column="Summary" ormtype="string" notnull="true";
    property name="Description" column="Description" ormtype="string";
    property name="CreatedDate" column="CreatedDate" ormtype="timestamp";
    // one-to-one

    // one-to-many

    // many-to-one

    // many-to-many

    // calculated properties

    // methods
    public RailoBug function init() {
        return this;
    }

    public String function buildContentCacheKey() {
        return "railobug-" & this.getSlug();
    }
}