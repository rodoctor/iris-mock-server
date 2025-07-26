Class core.bp.MockProcess Extends Ens.BusinessProcess [ ClassType = persistent ]
{

Method OnRequest(pRequest As core.msg.bp.MockRequest, Output pResponse As core.msg.bp.MockResponse) As %Status
{
	Try
	{
		#DIM response As core.msg.bo.RetornarMensagemMockResponse
		Set pResponse = ##class(core.msg.bp.MockResponse).%New()

		Set request = ##class(core.msg.bo.RetornarMensagemMockRequest).%New()
		Set request.DumpRequest = pRequest.DumpRequest
		Set request.HttpRequestJson = pRequest.HttpRequestJson
		$$$THROWONERROR(Status,..SendRequestSync("Mock Operation",request,.response))

		Set pResponse.Resposta = response.Resposta
		Set pResponse.ContentType = response.ContentType
		Set pResponse.Retorno = response.Retorno
		Set pResponse.DescricaoErro = response.DescricaoErro
		Set pResponse.StatusHTTP = response.StatusHTTP
	}
	Catch(e)
	{
		Set Status = e.AsStatus()
		Set pResponse.Retorno =0
		Set pResponse.DescricaoErro = $System.Status.GetErrorText(Status)
	}

	Quit $$$OK
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
