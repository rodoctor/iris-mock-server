Class core.bo.Operation Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Property PathIsolado As %String(MAXLEN = "");

Property SoapAction As %String(MAXLEN = "");

Property Acao As %String;

Property Operacao As %String(MAXLEN = "");

Property Protocolo As %String(MAXLEN = "") [ InitialExpression = "REST" ];

Property Sistema As %String(MAXLEN = "");

Property IdIntegracao As %String;

ClassMethod TesteREST()
{
	Set request = ##class(core.msg.bo.RetornarMensagemMockRequest).%OpenId(470)
	Set bo = ..%New("Mock Operation")
	Do bo.RetornarMensagemMock(request,.response)
}

ClassMethod TesteSOAP()
{
	Set request = ##class(core.msg.bo.RetornarMensagemMockRequest).%OpenId(2024)
	Set bo = ..%New("Mock Operation")
	Do bo.RetornarMensagemMock(request,.response)
}

Method RetornarMensagemMock(pRequest As core.msg.bo.RetornarMensagemMockRequest, Output pResponse As core.msg.bo.RetornarMensagemMockResponse) As %Status
{
	Do ..InicializarPropriedades()
	Try
	{
		Set pResponse = ##class(core.msg.bo.RetornarMensagemMockResponse).%New()

		#Dim cspRequest As core.modelo.http.CSPRequest
		$$$THROWONERROR(Status, ##class(%ZEN.Auxiliary.jsonProvider).%ParseJSON(pRequest.HttpRequestJson,,.cspRequest,,,,1))

		Set restanteUrl = $REPLACE(cspRequest.URL, cspRequest.Application, "")
		Set ..Sistema = $PIECE(restanteUrl,"/",1)
		Set ..PathIsolado = $PIECE(restanteUrl,"/",2,*)
		Set ..SoapAction = cspRequest.CgiEnvs."HTTP_SOAPACTION"
		Set:(..SoapAction = "NULL") ..SoapAction = ""
		Set ..Acao = cspRequest.Method

		If ($FIND($ZCONVERT(cspRequest.ContentType,"U"),"XML"))
		{
			Do:(cspRequest.Content'="") ..PossuiMensagemSoap(cspRequest.Content)
		}

		Do ..GerarLogInfo()

		Do $CASE(..Protocolo,
              "REST":..BuscarREST(),
			  "SOAP":..BuscarSOAP()
			  )

		Set objIntegracao = ##class(data.integracao.TblIntegracao).%OpenId(..IdIntegracao)

		Do pResponse.Resposta.CopyFrom(objIntegracao.Resposta)
		Set pResponse.ContentType = objIntegracao.ContentType
		Set pResponse.StatusHTTP = objIntegracao.StatusCode
	}
	Catch(e)
	{
		Set Status = e.AsStatus()
		Set pResponse.Retorno = 0
		Set pResponse.DescricaoErro = $System.Status.GetErrorText(Status)
	}

	Quit $$$OK
}

Method InicializarPropriedades() [ Private ]
{
	
	Set ..PathIsolado = ""
	Set ..SoapAction = ""
	Set ..Acao = ""
	Set ..Operacao = ""
	Set ..Sistema = ""
	Set ..IdIntegracao = ""
	Set ..Protocolo = "REST"
}

/// Método que verifica se a mensagem possui um envelope SOAP e retorna a operação
Method PossuiMensagemSoap(pDados As %Stream.Object) [ Private ]
{
    $$$THROWONERROR(Status,##class(%XML.TextReader).ParseStream(pDados,.xmlReader))
	
	#Dim xmlReader As %XML.TextReader

	Set encontrouBody = 0


    Set tags = $LISTFROMSTRING("Envelope,Header,Body")
    While (xmlReader.Read())
    {
        If (xmlReader.NodeType = "element")
        {
            Set tag = $SELECT($FIND(xmlReader.Name,":"):$PIECE(xmlReader.Name,":",2),1:xmlReader.Name)
			
			If ($LISTFIND(tags,tag) > 0)
			{
				Set ..Protocolo = "SOAP"			
			}
			
			If ((tag '= "Body") && (encontrouBody = 0))
			{
				
				Continue
			}
			
			If (tag = "Body")
			{
				Set encontrouBody = 1
				Continue
			}

			Set:(..Protocolo = "SOAP") ..Operacao = tag

			Quit
		}
    }
}

Method GerarLogInfo() [ Private ]
{
	Set logInfo = ""
	Set:($LENGTH(..Sistema)) logInfo = logInfo _$LISTBUILD("Sistema: "_..Sistema)
	Set:($LENGTH(..PathIsolado)) logInfo = logInfo _$LISTBUILD("Path Isolado: "_..PathIsolado)
	Set:($LENGTH(..SoapAction)) logInfo = logInfo _$LISTBUILD("SoapAction: "_..SoapAction)
	Set:($LENGTH(..Acao)) logInfo = logInfo _$LISTBUILD("Ação: "_..Acao)
	Set:($LENGTH(..Operacao)) logInfo = logInfo _$LISTBUILD("Operation: "_..Operacao)
	Set:($LENGTH(..Protocolo)) logInfo = logInfo _$LISTBUILD("Protocolo: "_..Protocolo)

	$$$LOGINFO($LISTTOSTRING(logInfo,$CHAR(13,10)))
}

Method BuscarREST() [ Private ]
{
	Set idIntegracao = ##class(data.integracao.TblIntegracao).RetornarIdRegistroREST(..Sistema, ..PathIsolado, ..Acao)
	If idIntegracao = ""
	{
		$$$THROWONERROR(Status, $System.Status.Error(5001, "Path não encontrado"))
	}
	Set ..IdIntegracao = idIntegracao
}

Method BuscarSOAP() [ Private ]
{
	Set idIntegracao = ##class(data.integracao.TblIntegracao).RetornarIdRegistroSOAP(..Sistema, ..PathIsolado, ..SoapAction, ..Operacao)
	If idIntegracao = ""
	{
		$$$THROWONERROR(Status, $System.Status.Error(5001, "Path não encontrado"))
	}
	Set ..IdIntegracao = idIntegracao
}

XData MessageMap
{
<MapItems>
    <MapItem MessageType="core.msg.bo.RetornarMensagemMockRequest">
        <Method>RetornarMensagemMock</Method>
    </MapItem>
</MapItems>
}

}
