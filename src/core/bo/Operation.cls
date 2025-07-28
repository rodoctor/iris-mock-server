Class core.bo.Operation Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Property IsolatedPath As %String(MAXLEN = "");

Property SoapAction As %String(MAXLEN = "");

Property Action As %String;

Property Operation As %String(MAXLEN = "");

Property Protocol As %String(MAXLEN = "") [ InitialExpression = "REST" ];

Property System As %String(MAXLEN = "");

Property IntegrationId As %String;

ClassMethod TestREST()
{
	Set request = ##class(core.msg.bo.ReturnMockMessageRequest).%OpenId(51)
	Set bo = ..%New("Mock Operation")
	Do bo.ReturnMockMessage(request,.response)
}

ClassMethod TestSOAP()
{
	Set request = ##class(core.msg.bo.ReturnMockMessageRequest).%OpenId(2024)
	Set bo = ..%New("Mock Operation")
	Do bo.ReturnMockMessage(request,.response)
}

Method ReturnMockMessage(pRequest As core.msg.bo.ReturnMockMessageRequest, Output pResponse As core.msg.bo.ReturnMockMessageResponse) As %Status
{
	Do ..InitializeProperties()
	Try
	{
		Set pResponse = ##class(core.msg.bo.ReturnMockMessageResponse).%New()

		#Dim cspRequest As core.model.http.CSPRequest
		$$$THROWONERROR(Status, ##class(%ZEN.Auxiliary.jsonProvider).%ParseJSON(pRequest.HttpRequestJson,,.cspRequest,,,,1))

		Set restanteUrl = $REPLACE(cspRequest.URL, cspRequest.Application, "")
		Set ..System = $PIECE(restanteUrl,"/",1)
		Set ..IsolatedPath = $PIECE(restanteUrl,"/",2,*)
		Set ..SoapAction = cspRequest.CgiEnvs."HTTP_SOAPACTION"
		Set:(..SoapAction = "NULL") ..SoapAction = ""
		Set ..Action = cspRequest.Method

		If ($FIND($ZCONVERT(cspRequest.ContentType,"U"),"XML"))
		{
			Do:(cspRequest.Content'="") ..HasSoapMessage(cspRequest.Content)
		}

		Do ..GenerateLogInfo()

		Do $CASE(..Protocol,
              "REST":..SearchREST(),
			  "SOAP":..SearchSOAP()
			  )

		Set mockResponse = ##class(data.TblMockResponse).%OpenId(..IntegrationId)

		Do pResponse.Response.CopyFrom(mockResponse.Response)
		Set pResponse.ContentType = mockResponse.ContentType
		Set pResponse.StatusHTTP = mockResponse.StatusCode
	}
	Catch(e)
	{
		Set Status = e.AsStatus()
		Set pResponse.Return = 0
		Set pResponse.ErrorDescription = $System.Status.GetErrorText(Status)
	}

	Quit $$$OK
}

Method InitializeProperties() [ Private ]
{

	Set ..IsolatedPath = ""
	Set ..SoapAction = ""
	Set ..Action = ""
	Set ..Operation = ""
	Set ..System = ""
	Set ..IntegrationId = ""
	Set ..Protocol = "REST"
}

/// Method that checks if the message has a SOAP envelope and returns the operation
Method HasSoapMessage(pDados As %Stream.Object) [ Private ]
{
    $$$THROWONERROR(Status,##class(%XML.TextReader).ParseStream(pDados,.xmlReader))
	
	#Dim xmlReader As %XML.TextReader

	Set hasBody = 0


    Set tags = $LISTFROMSTRING("Envelope,Header,Body")
    While (xmlReader.Read())
    {
        If (xmlReader.NodeType = "element")
        {
            Set tag = $SELECT($FIND(xmlReader.Name,":"):$PIECE(xmlReader.Name,":",2),1:xmlReader.Name)
			
			If ($LISTFIND(tags,tag) > 0)
			{
				Set ..Protocol = "SOAP"			
			}
			
			If ((tag '= "Body") && (hasBody = 0))
			{
				
				Continue
			}
			
			If (tag = "Body")
			{
				Set hasBody = 1
				Continue
			}

			Set:(..Protocol = "SOAP") ..Operation = tag

			Quit
		}
    }
}

Method GenerateLogInfo() [ Private ]
{
	Set logInfo = ""
	Set:($LENGTH(..System)) logInfo = logInfo _$LISTBUILD("System: "_..System)
	Set:($LENGTH(..IsolatedPath)) logInfo = logInfo _$LISTBUILD("Isolated Path: "_..IsolatedPath)
	Set:($LENGTH(..SoapAction)) logInfo = logInfo _$LISTBUILD("SoapAction: "_..SoapAction)
	Set:($LENGTH(..Action)) logInfo = logInfo _$LISTBUILD("Action: "_..Action)
	Set:($LENGTH(..Operation)) logInfo = logInfo _$LISTBUILD("Operation: "_..Operation)
	Set:($LENGTH(..Protocol)) logInfo = logInfo _$LISTBUILD("Protocol: "_..Protocol)

	$$$LOGINFO($LISTTOSTRING(logInfo,$CHAR(13,10)))
}

Method SearchREST() [ Private ]
{
	Set integrationId = ##class(data.TblMockResponse).ReturnIdREST(..System, ..IsolatedPath, ..Action)
	If integrationId = ""
	{
		$$$THROWONERROR(Status, $System.Status.Error(5001, "Path not found"))
	}
	Set ..IntegrationId = integrationId
}

Method SearchSOAP() [ Private ]
{
	Set integrationId = ##class(data.TblMockResponse).ReturnIdResponseSOAP(..System, ..IsolatedPath, ..SoapAction, ..Operation)
	If integrationId = ""
	{
		$$$THROWONERROR(Status, $System.Status.Error(5001, "Path not found"))
	}
	Set ..IntegrationId = integrationId
}

XData MessageMap
{
<MapItems>
    <MapItem MessageType="core.msg.bo.ReturnMockMessageRequest">
        <Method>ReturnMockMessage</Method>
    </MapItem>
</MapItems>
}

}
