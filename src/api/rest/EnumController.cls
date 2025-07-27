Class api.rest.EnumController Extends %CSP.REST
{

XData UrlMap
{
<Routes>
    <Route Url="/getAllEnums" Method="GET" Call="GetAllEnums"/>
</Routes>
}

ClassMethod GetAllEnums() As %Boolean
{
    Set sql = "SELECT ID FROM %Dictionary.ClassDefinition WHERE ID LIKE 'data.enum%'"
    
    Set statement = ##class(%SQL.Statement).%New()
    
    Set Status = statement.%Prepare(sql)
    Set resultSet = statement.%Execute()

    Set json = ##class(%DynamicObject).%New()

    Set arrayClass = ##class(%DynamicObject).%New()
    While resultSet.%Next()
    {
        Set values = ##class(%DynamicObject).%New()
        
        Set classPath = resultSet.%Get("ID")

        Set className = $PIECE(classPath, ".", *)

        Set valueList = $PARAMETER(classPath, "VALUELIST")
        Set displayList = $PARAMETER(classPath, "DISPLAYLIST")

        If (displayList '= "") {
            Do values.%Set("displayList", displayList)
        }
        If (valueList '= "") {
            Do values.%Set("valueList", valueList)
        }
       
        Do arrayClass.%Set(className, values)

    }

    Set %response.ContentType = "application/json"
    Set %response.Status = 200
    
    Do json.%Set("data", arrayClass)    
    Do json.%ToJSON()
    
    Quit $$$OK
}

}
