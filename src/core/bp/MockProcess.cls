Class core.bp.MockProcess Extends Ens.BusinessProcess [ ClassType = persistent ]
{

Method OnRequest(pRequest As core.msg.bp.MockRequest, Output pResponse As core.msg.bp.MockResponse) As %Status
{
	Try
	{
		#DIM response As core.msg.bo.ReturnMockMessageResponse
		Set pResponse = ##class(core.msg.bp.MockResponse).%New()

		Set request = ##class(core.msg.bo.ReturnMockMessageRequest).%New()
		Set request.DumpRequest = pRequest.DumpRequest
		Set request.HttpRequestJson = pRequest.HttpRequestJson
		$$$THROWONERROR(Status,..SendRequestSync("Mock Operation",request,.response))

		Set pResponse.Resposta = response.Response
		Set pResponse.ContentType = response.ContentType
		Set pResponse.Return = response.Return
		Set pResponse.ErrorDescription = response.ErrorDescription
		Set pResponse.StatusHTTP = response.StatusHTTP
	}
	Catch(e)
	{
		Set Status = e.AsStatus()
		Set pResponse.Return = 0
		Set pResponse.ErrorDescription = $System.Status.GetErrorText(Status)
	}

	Quit $$$OK
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
