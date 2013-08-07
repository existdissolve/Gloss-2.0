component entityName="_Member" table="Member" extends="_Base" persistent="true" {
    property name="MemberID" column="MemberID" fieldtype="id" generator="identity";
    property name="Name" column="Name";
    property name="SystemUser" fieldtype="one-to-one" cfc="SystemUser" mappedby="_Member";
}