component entityName="SystemUser" table="SystemUser" extends="_Base" persistent="true" {
    property name="SystemUserID" column="SystemUserID" fieldtype="id" generator="identity";
    property name="_Member" fieldtype="one-to-one" cfc="_Member" fkcolumn="MemberID";
}