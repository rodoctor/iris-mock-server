Class core.util.Padrao Extends %RegisteredObject
{

/// Do ##Class(core.util.Padrao).InserePathResponse("/teste", "{""teste"":""teste""}", "application/json")
ClassMethod InserePathResponse(pPath As %String, pResposta As %String, pContentType As %String) As %Status
{
	Set Status = $$$OK

	Set objResponse = ##Class(data.mock.Response).%New()
	Set objResponse.Resposta = pResposta
	Set objResponse.ContentType = pContentType

	$$$THROWONERROR(Status, objResponse.%Save())

	Set objPath = ##Class(data.mock.Path).idxPathOpen(pPath)
	If ('$ISOBJECT(objPath))
	{
		Set objPath = ##Class(data.mock.Path).%New()
		Set objPath.Path = pPath
	}

	$$$THROWONERROR(Status,objPath.Responses.Clear())
	$$$THROWONERROR(Status,objPath.Responses.Insert(objResponse))

	$$$THROWONERROR(Status, objPath.%Save())

	Quit Status
}

ClassMethod RetornaPathResponse(path As %String, ByRef pResposta As %String = "", ByRef pContentType As %String = "") As %Status
{
	Set Status = $$$OK

	Set objPath = ##Class(data.mock.Path).idxPathOpen(path)
	If ('$ISOBJECT(objPath))
	{
		Set Status = $System.Status.Error(5001, "Path não encontrado")
	}
	Else
	{
		Set pResposta = objPath.Responses.GetAt(1).Resposta
		Set pContentType = objPath.Responses.GetAt(1).ContentType
	}

	Quit Status
}

}
