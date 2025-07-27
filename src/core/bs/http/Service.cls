Class core.bs.http.Service Extends (Ens.BusinessService, %CSP.REST)
{

Parameter UseSession As Integer = 1;

Parameter NOCHARSETCONVERT = 1;

Parameter CONTENTTYPEJSON As %String = "application/json";

Parameter CHARSET As %String = "UTF-8";

Parameter HandleCorsRequest = 1;

ClassMethod OnPreDispatch(pUrl As %String, pMethod As %String, ByRef pContinue As %Boolean) As %Status
{
	Do ..Service()
    Quit $$$OK
}

ClassMethod Service() As %Boolean
{
	Try
	{
		kill ^ROLES
		Set ^ROLES($NAMESPACE,$USERNAME,"ROLES")=$ROLES
		Set oldRoles = $ROLES

		New $ROLES
		Set $ROLES = "%All"

		Set request = ##class(core.msg.bp.MockRequest).%New()
		#Dim %request As %CSP.Request

		$$$THROWONERROR(Status, ##class(IORedirect.Redirect).ToStream())
		$$$THROWONERROR(Status, $System.OBJ.Dump(%request))
		Set outputRedirect = ##class(IORedirect.Redirect).Get()
		$$$THROWONERROR(Status, ##class(IORedirect.Redirect).RestoreIO())

		Set cspRequest = ##class(core.model.http.CSPRequest).%New()
		$$$THROWONERROR(Status, cspRequest.HydrateFromCSPRequest(%request))

		Set httpRequestJson = ##class(%Stream.GlobalCharacter).%New()
		$$$THROWONERROR(Status, ##class(%ZEN.Auxiliary.jsonProvider).%WriteJSONStreamFromObject(.httpRequestJson,cspRequest,,,,"aelo"))
		$$$THROWONERROR(Status, request.HttpRequestJson.CopyFrom(httpRequestJson))
		$$$THROWONERROR(Status, request.DumpRequest.CopyFrom(outputRedirect))
		
		#Dim response As core.msg.bp.MockResponse
		$$$THROWONERROR(Status,..Execute(request,.response,"Send"))

		If (response.Return = 0)
		{
			$$$THROWONERROR(Status, ..GenerateMessageService(500,response.ErrorDescription))
		}
		Else
		{
			#DIM %response As %CSP.Response
			Set %response.ContentType = response.ContentType
			Set %response.Status = response.StatusHTTP
			Set %response.Expires = 0
			If (response.Response.Size > 0)
			{
				While 'response.Response.AtEnd
				{
					Write response.Response.Read(32767)
				}
			}
			Else
			{
				Write ""
			}
		}
	}
	Catch e
	{
		Set Status = e.AsStatus()
		Set msgErro = $System.Status.GetErrorText(Status)
		Do ..GenerateMessageService(500,msgErro)
	}
	New $ROLES
	Set $ROLES = oldRoles
	Return 1
}

ClassMethod GenerateMessageService(pHttpStatus As %String, pMensagem As %String) As %Status [ Private ]
{
	Set %response.ContentType = "application/json"
	Set %response.Status = pHttpStatus

	Set horolog = $HOROLOG
	Set timestamp = $ZDATETIME(horolog,3)
	Set dateCreated = $REPLACE(timestamp," ","T")_"Z"

	Set proxy = ##class(%ZEN.proxyObject).%New()
	Set proxy.status = pHttpStatus
	Set proxy.dateCreated = dateCreated
	Set proxy.message = pMensagem

	$$$THROWONERROR(Status, ##class(%ZEN.Auxiliary.jsonProvider).%ObjectToJSON(proxy,.json))

	Quit $$$OK
}

ClassMethod Execute(pInput As %RegisteredObject, Output pOutput As %RegisteredObject, ByRef pHint As %String) As %Status [ Private ]
{
	#Dim bs As core.bs.http.Service
	$$$THROWONERROR(Status, ##class(Ens.Director).CreateBusinessService("Service HTTP",.bs))

	Set Status = bs.OnProcessInput(pInput,.pOutput, pHint)

	Quit Status
}

/// Override this method to process incoming data. Do not call SendRequestSync/Async() from outside this method (e.g. in a SOAP Service or a CSP page).
Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject, ByRef pHint As %String) As %Status
{
	Set:(pHint = "Send") Status = ..SendRequestSync("Mock Process",pInput,.pOutput)
	Quit Status
}

}
