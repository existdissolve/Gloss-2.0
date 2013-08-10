component entityName="Adobe" table="Adobe" extends="Resource" persistent="true" joinColumn="ResourceID" {
    // non-relational columns
    property name="PageID" column="PageID" ormtype="integer" notnull="true";
    // one-to-one

    // one-to-many
    property name="Children" singularname="Child" fieldtype="one-to-many" cfc="Adobe" fkcolumn="ParentResourceID";
    // many-to-one
    property name="Parent" column="ParentResourceID" fieldtype="many-to-one" cfc="Resource" fkcolumn="ParentResourceID";
    // many-to-many

    // calculated properties

    // methods
    public Adobe function init() {
        return this;
    }

    public String function buildContentCacheKey() {
        return "adobe-" & this.getSlug();
    }
}