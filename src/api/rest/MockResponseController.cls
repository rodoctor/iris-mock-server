Class api.rest.MockResponseController Extends %CSP.REST
{

XData UrlMap
{
<Routes>
    <Route Url="/getAllMockResponses" Method="GET" Call="GetAllMockResponses"/>
    <Route Url="/getMockResponse/:id" Method="GET" Call="GetMockResponseById"/>
    <Route Url="/saveMockResponse" Method="POST" Call="SaveMockResponse"/>
    <Route Url="/deleteMockResponse/:id" Method="DELETE" Call="DeleteMockResponseById"/>
</Routes>
}

ClassMethod GetAllMockResponses() As %Boolean
{
    Try
    {
        Set Status = $$$OK

        #Dim %response As %CSP.Response = ##class(%CSP.Response).%New()
        Set %response.ContentType = "application/json"

        Set sql = "SELECT ID FROM data.TblMockResponse"
        Set statement = ##class(%SQL.Statement).%New()
        $$$THROWONERROR(Status, statement.%Prepare(sql))
        Set resultSet = statement.%Execute()

        Set json = ##class(%DynamicObject).%New()
        Set array = ##class(%DynamicArray).%New()

        While resultSet.%Next()
        {
            Set mockResponse = ##class(data.TblMockResponse).%OpenId(resultSet.%Get("ID"),,.Status)

            Set values = ##class(%DynamicObject).%New()

            Do values.%Set("id", mockResponse.%Id())
            Do values.%Set("path", mockResponse.Path)
            Do values.%Set("action", mockResponse.Action)
            Do values.%Set("response", mockResponse.Response.Read(mockResponse.Response.Size))
            Do values.%Set("contentType", mockResponse.ContentType)
            Do values.%Set("protocol", mockResponse.Protocol)
            Do values.%Set("situation", mockResponse.Situation)
            Do values.%Set("system", mockResponse.System)
            Do values.%Set("description", mockResponse.Description)
            Do values.%Set("statusCode", mockResponse.StatusCode)
            Do values.%Set("soapAction", mockResponse.SoapAction) 
            Do values.%Set("operation", mockResponse.Operation)

            Do array.%Push(values)
        }

        If (array.%Size() = 0)
        {
            Set %response.Status = 204  // No Content
        }
        Else
        {
            Set %response.Status = 200
            
            Do json.%Set("data", array)
            Do json.%Set("status", "success")
            Do json.%Set("message", "Mock responses retrieved successfully")
        }
    }
    Catch ex
    {
        Set Status = ex.AsStatus()
        Set messageStatus = $System.Status.GetErrorText(Status)

        Do json.%Set("status", "error")
        Do json.%Set("message", "An error occurred while retrieving mock responses: "_messageStatus)

        Set %response.Status = 500
        Set %response.ContentType = "application/json"
    }
    
    Do json.%ToJSON()
    Quit $$$OK
}

ClassMethod GetMockResponseById(id As %String) As %Boolean
{
    Try
    {
        Set Status = $$$OK
        #Dim %response As %CSP.Response = ##class(%CSP.Response).%New()
        
        Set %response.ContentType = "application/json"
        Set json = ##class(%DynamicObject).%New()

        Set mockResponseExists = ##class(data.TblMockResponse).%ExistsId(id)
        If (mockResponseExists){
            Set mockResponse = ##class(data.TblMockResponse).%OpenId(id)

            Set data = ##class(%DynamicObject).%New()
            Do data.%Set("id", mockResponse.%Id())
            Do data.%Set("path", mockResponse.Path)
            Do data.%Set("action", mockResponse.Action)
            Do data.%Set("response", mockResponse.Response.Read(mockResponse.Response.Size))
            Do data.%Set("contentType", mockResponse.ContentType)
            Do data.%Set("protocol", mockResponse.Protocol)
            Do data.%Set("situation", mockResponse.Situation)
            Do data.%Set("system", mockResponse.System)
            Do data.%Set("description", mockResponse.Description)
            Do data.%Set("statusCode", mockResponse.StatusCode)
            Do data.%Set("soapAction", mockResponse.SoapAction)
            Do data.%Set("operation", mockResponse.Operation)
            
            Do json.%Set("status", "success")
            Do json.%Set("message", "Mock response retrieved successfully")
            Do json.%Set("data", data)

            Set %response.Status = 200
        }
        Else
        {
            Set %response.Status = 204  
        }
    }
    Catch ex
    {
        Set Status = ex.AsStatus()
        Set messageStatus = $System.Status.GetErrorText(Status)

        Do json.%Set("status", "error")
        Do json.%Set("message", "An error occurred while retrieving mock responses: "_messageStatus)

        Set %response.Status = 500
    }
    Do json.%ToJSON()
    Quit $$$OK
}

ClassMethod SaveMockResponse() As %Boolean
{
    Set Status = $$$OK
    Try
    {
        #Dim %response As %CSP.Response = ##class(%CSP.Response).%New()
        Set %response.ContentType = "application/json"

        Set json = ##class(%DynamicObject).%New()

        Set body = ##class(%DynamicObject).%FromJSON(%request.Content)

        If (body.%Get("situation") = 1)
        {
            Set return = $CASE(body.%Get("protocol"),
                "REST":##class(data.TblMockResponse).ExistsMockResponseActiveREST(.pId,body.%Get("system"), body.%Get("path"), body.%Get("action")),
                "SOAP":##class(data.TblMockResponse).ExistsMockResponseActiveSOAP(.pId,body.%Get("system"), body.%Get("path"), body.%Get("soapAction"), body.%Get("operation")),
                :0
            )

            If ((return = 1) && (body.%Get("id") '= pId))
            {
                $$$THROWONERROR(Status,$System.Status.Error(5001, "There is already a mock response with the data provided."))
            }
        }
        
        If (body.%Get("id") = "*NEW*") || (body.%Get("id") = "")
        {
            Set pSource = ##class(data.TblMockResponse).%New()
        }
        Else
        {
            Set mockResponseExists = ##class(data.TblMockResponse).%ExistsId(body.%Get("id"))
            If (mockResponseExists = 1)
            {
                Set pSource = ##class(data.TblMockResponse).%OpenId(body.%Get("id"),,.Status)
            }
        }

        Set:($LENGTH(body.%Get("path"))>0) pSource.Path = body.%Get("path")
        Set:($LENGTH(body.%Get("action"))>0) pSource.Action = body.%Get("action")
        If ($LENGTH(body.%Get("response"))>0)
        {
            Do pSource.Response.Clear()
            Do pSource.Response.Write(body.%Get("response"))
        }
        Set:($LENGTH(body.%Get("contentType"))>0) pSource.ContentType = body.%Get("contentType")
        Set:($LENGTH(body.%Get("protocol"))>0) pSource.Protocol = body.%Get("protocol")
        Set:($LENGTH(body.%Get("situation"))>0) pSource.Situation = body.%Get("situation")
        Set:($LENGTH(body.%Get("system"))>0) pSource.System = body.%Get("system")
        Set:($LENGTH(body.%Get("description"))>0) pSource.Description = body.%Get("description")
        Set:($LENGTH(body.%Get("statusCode"))>0) pSource.StatusCode = body.%Get("statusCode")
        Set:($LENGTH(body.%Get("soapAction"))>0) pSource.SoapAction = body.%Get("soapAction")
        Set:($LENGTH(body.%Get("operation"))>0) pSource.Operation = body.%Get("operation")

        $$$THROWONERROR(Status, pSource.%Save())

        Do json.%Set("id", pSource.%Id())
        Do json.%Set("status", "success")
        Do json.%Set("message", "Mock response saved successfully")
        Set %response.Status = 201  // Created
    }
    Catch ex
    {
        Set Status = ex.AsStatus()
        Set messageStatus = $System.Status.GetErrorText(Status)

        Do json.%Set("status", "error")
        Do json.%Set("message", "An error occurred while saving mock response: "_messageStatus)

        Set %response.Status = 500
    }
    Do json.%ToJSON()
    
    Quit $$$OK
}

ClassMethod DeleteMockResponseById(id As %String) As %Boolean
{
    Try
    {
        Set Status = $$$OK

        #Dim %response As %CSP.Response = ##class(%CSP.Response).%New()
        Set %response.ContentType = "application/json"
        
        Set json = ##class(%DynamicObject).%New()

        Set mockResponseExists = ##class(data.TblMockResponse).%ExistsId(id)
        If (mockResponseExists = 0)
        {
            Set %response.Status = 404  // Not Found
            Do json.%Set("status", "error")
            Do json.%Set("message", "Mock response not found")
        }
        Else
        {
            Do ##class(data.TblMockResponse).%DeleteId(id)

            Do json.%Set("status", "success")
            Do json.%Set("message", "Mock response deleted successfully")

            Set %response.Status = 200
        }
    }
    Catch ex
    {
        Set Status = ex.AsStatus()
        Set messageStatus = $System.Status.GetErrorText(Status)

        Do json.%Set("status", "error")
        Do json.%Set("message", "An error occurred while deleting mock response: "_messageStatus)

        Set %response.Status = 500
    }
    
    Do json.%ToJSON()
    Quit $$$OK
}

}
