Class data.TblIntegration Extends %Persistent
{

// Index IdxPathAcaoSituacao On (Path, Acao, Situacao) [ Condition = {Situacao = "1"}, Unique ];

/// Somente posso ter uma resposta ativa
Property Path As %String(MAXLEN = "");

Property Action As %String(VALUELIST = ",GET,POST,PUT,DELETE,PATCH");

Property Response As %Stream.GlobalCharacter;

Property ContentType As %String(MAXLEN = "");

Property Protocol As %String(VALUELIST = ",REST,SOAP") [ Required ];

Property Situation As %Boolean(DISPLAYLIST = ",Ativa,Inativa", VALUELIST = ",1,0") [ Required ];

Property System As %String(MAXLEN = "") [ Required ];

Property Description As %String(MAXLEN = "") [ Required ];

Property StatusCode As %String(MAXLEN = "") [ Required ];

Property SoapAction As %String(MAXLEN = "");

Property Operation As %String(MAXLEN = "");

ClassMethod ExistsRegistrationStatusActiveREST(Output pID As %String = "", pSystem As %String(MAXLEN="") = "", pPath As %String(MAXLEN="") = "", pAction As %String(MAXLEN="") = "") As %Boolean
{
    Set situation = 1
    Set protocol = "REST"

    Set params = ""
    Set params($INCREMENT(params)) = pSystem
    Set params($INCREMENT(params)) = pPath
    Set params($INCREMENT(params)) = pAction
    Set params($INCREMENT(params)) = situation
    Set params($INCREMENT(params)) = protocol

    Set sql = "SELECT ID, COUNT(ID) As Total "_
                "FROM data.TblIntegration "_
                "WHERE System = ? "_
                "AND Path = ? "_
                "AND Action = ? "_
                "AND Situation = ? "_
                "AND Protocol = ?"

    Set statement = ##class(%SQL.Statement).%New()
    Set Status = statement.%Prepare(sql)
    Set resultSet = statement.%Execute(params...)

    If (resultSet.%Next())
    {
        Set pID = resultSet.ID
        Return (resultSet.Total > 0)
    }

    Return 0
}

ClassMethod ExistsRegistrationStatusActiveSOAP(Output pID As %String = "", pSystem As %String(MAXLEN="") = "", pPath As %String(MAXLEN="") = "", pSoapAction As %String(MAXLEN="") = "", pOperation As %String(MAXLEN="") = "") As %Boolean
{
    Set situation = 1
    Set protocol = "SOAP"
    Set Action = "POST"

    Set params = ""
    Set params($INCREMENT(params)) = situation
    Set params($INCREMENT(params)) = pSystem
    Set params($INCREMENT(params)) = protocol


    Set sql = "SELECT ID, COUNT(ID) As Total "_
                "FROM data.TblIntegration "_
                "WHERE Situation = ? "_
                "AND System = ? "_
                "AND Protocol = ?"

    Set validationSoapAction = ((pSoapAction '= "") && (pSoapAction '= "NULL"))
    Set validationOperation = ((pOperation '= "") && (pOperation '= "NULL"))
    Set validationPath = ((pPath '= "") && (pPath '= "NULL"))

    If (validationPath '= 0)
    {
	   Set sql = sql_" AND Path = ? "
	   Set params($INCREMENT(params)) = pPath
    }

    If ((validationSoapAction = 0) && (validationOperation = 0))
    {
        $$$THROWONERROR(Status, $System.Status.Error(5001, "At least one of the SoapAction or Operation fields must be filled in."))
    }

    If (validationSoapAction = 1)
    {
        Set sql = sql_" AND SoapAction = ?"
        Set params($INCREMENT(params)) = pSoapAction
    }

    If (validationOperation = 1)
    {
        Set sql = sql_" AND Operation = ?"
        Set params($INCREMENT(params)) = pOperation
    }

    Set statement = ##class(%SQL.Statement).%New()
    $$$THROWONERROR(Status, statement.%Prepare(sql))

    Set resultSet = statement.%Execute(params...)

    If (resultSet.%Next())
    {
        Set pID = resultSet.ID
        Return (resultSet.Total > 0)
    }

    Return 0
}

ClassMethod RetornarIdRegistroREST(pSystem As %String(MAXLEN="") = "", pPath As %String(MAXLEN="") = "", pAction As %String(MAXLEN="") = "") As %String
{
    Set idRegistro = ..ReturnIdByParametersCompleteREST(pSystem, pPath, pAction)
	Set:(idRegistro = "") idRegistro =..ReturnIdByDynamicPathREST(pSystem, pPath)

	Return idRegistro
}

ClassMethod ReturnIdByParametersCompleteREST(pSystem, pPath, pAction) As %Integer
{
	Set situation = 1
    Set protocol = "REST"

    Set params = ""
    Set params($INCREMENT(params)) = pSystem
    Set params($INCREMENT(params)) = pPath
    Set params($INCREMENT(params)) = pAction
    Set params($INCREMENT(params)) = situation
    Set params($INCREMENT(params)) = protocol

    Set sql = "SELECT ID "_
                "FROM data.TblIntegration "_
                "WHERE System = ? "_
                "AND Path = ? "_
                "AND Action = ? "_
                "AND Situation = ? "_
                "AND Protocol = ?"

    Set statement = ##class(%SQL.Statement).%New()
    $$$THROWONERROR(Status, statement.%Prepare(sql))
    Set resultSet = statement.%Execute(params...)

    If (resultSet.%Next())
    {
        Return resultSet.ID
    }
    
    Return ""
}

ClassMethod ReturnIdByDynamicPathREST(pSystem, pPath) As %Integer
{
	Set situation = 1
    Set protocol = "REST"

	Set params = ""
    Set params($INCREMENT(params)) = pSystem
    Set params($INCREMENT(params)) = situation
    Set params($INCREMENT(params)) = protocol
    
    Set sql = "SELECT ID, "_
    			"Path "_
    			"FROM data.TblIntegration "_
    			"WHERE Path LIKE '%<<Parameter>>%' "_
    			"AND System = ? "_
    			"AND Situation = ? "_
    			"AND Protocol = ? "
    			
	Set statement = ##class(%SQL.Statement).%New()
	$$$THROWONERROR(Status, statement.%Prepare(sql))
	Set resultSet = statement.%Execute(params...)

	While resultSet.%Next()
	{
	    Set template = resultSet.Path
	    // Remove / do início e fim de ambos
		Set cleanTemplate = $ZSTRIP(template, "><", "/")
		Set cleanPath     = $ZSTRIP(pPath, "><", "/")

		// Quebra os dois caminhos em partes
		Set templateParts = $LISTFROMSTRING(cleanTemplate, "/")
		Set pathParts     = $LISTFROMSTRING(cleanPath, "/")

	    Continue:($LISTLENGTH(templateParts) '= $LISTLENGTH(pathParts))

	    Set isMatch = 1
	    For i=1:1:$LISTLENGTH(templateParts)
	    {
	        Set t = $LISTGET(templateParts, i)
	        Set p = $LISTGET(pathParts, i)
	        
	        If (t '= "<<Parameter>>") 
	        {	
	        	If (t '= p)
	        	{
		        	Set isMatch = 0
           			Quit
		        }
	        } 
	    }

	    If (isMatch) {
	        Return resultSet.ID
	    }
	}
	
	Return ""
}

ClassMethod ReturnIdBySOAP(pSystem As %String(MAXLEN="") = "", pPath As %String(MAXLEN="") = "", pSoapAction As %String(MAXLEN="") = "", pOperation As %String(MAXLEN="") = "") As %String
{
    Set situation = 1
    Set protocol = "SOAP"
    Set action = "POST"

    Set params = ""
    Set params($INCREMENT(params)) = situation
    Set params($INCREMENT(params)) = pSystem
    Set params($INCREMENT(params)) = protocol


    Set sql = "SELECT ID "_
                "FROM data.TblIntegration "_
                "WHERE Situation = ? "_
                "AND System = ? "_
                "AND Protocol = ?"

    Set soapActionValidation = ((pSoapAction '= "") && (pSoapAction '= "NULL"))
    Set operationValidation = ((pOperation '= "") && (pOperation '= "NULL"))
    Set pathValidation = ((pPath '= "") && (pPath '= "NULL"))

    If (pathValidation '= 0)
    {
	   Set sql = sql_" AND Path = ? "
	   Set params($INCREMENT(params)) = pPath
    }

    If ((soapActionValidation = 0) && (operationValidation = 0))
    {
        $$$THROWONERROR(Status, $System.Status.Error(5001, "At least one of the SoapAction or Operation fields must be filled in."))
    }


    Set sql = sql_" AND (SoapAction = ? OR Operation = ?)"
    Set params($INCREMENT(params)) = pSoapAction
    Set params($INCREMENT(params)) = pOperation

    Set statement = ##class(%SQL.Statement).%New()
    $$$THROWONERROR(Status, statement.%Prepare(sql))

    Set resultSet = statement.%Execute(params...)

    If (resultSet.%Next())
    {
        Return resultSet.ID
    }

    Return ""
}

Storage Default
{
<Data name="TblIntegrationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Path</Value>
</Value>
<Value name="3">
<Value>Action</Value>
</Value>
<Value name="4">
<Value>Response</Value>
</Value>
<Value name="5">
<Value>ContentType</Value>
</Value>
<Value name="6">
<Value>Protocol</Value>
</Value>
<Value name="7">
<Value>Situation</Value>
</Value>
<Value name="8">
<Value>System</Value>
</Value>
<Value name="9">
<Value>Description</Value>
</Value>
<Value name="10">
<Value>StatusCode</Value>
</Value>
<Value name="11">
<Value>SoapAction</Value>
</Value>
<Value name="12">
<Value>Operation</Value>
</Value>
</Data>
<DataLocation>^data.TblIntegrationD</DataLocation>
<DefaultData>TblIntegrationDefaultData</DefaultData>
<IdLocation>^data.TblIntegrationD</IdLocation>
<IndexLocation>^data.TblIntegrationI</IndexLocation>
<StreamLocation>^data.TblIntegrationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
