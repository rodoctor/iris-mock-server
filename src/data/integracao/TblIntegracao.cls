Class data.integracao.TblIntegracao Extends %Persistent
{

// Index IdxPathAcaoSituacao On (Path, Acao, Situacao) [ Condition = {Situacao = "1"}, Unique ];

/// Somente posso ter uma resposta ativa
Property Path As %String(MAXLEN = "");

Property Acao As %String(VALUELIST = ",GET,POST,PUT,DELETE,PATCH");

Property Resposta As %Stream.GlobalCharacter;

Property ContentType As %String(MAXLEN = "");

Property Protocolo As %String(VALUELIST = ",REST,SOAP") [ Required ];

Property Situacao As %Boolean(DISPLAYLIST = ",Ativa,Inativa", VALUELIST = ",1,0") [ Required ];

Property VersaoCheck As %String(MAXLEN = "");

Property Sistema As %String(MAXLEN = "") [ Required ];

Property Descricao As %String(MAXLEN = "") [ Required ];

Property StatusCode As %String(MAXLEN = "") [ Required ];

Property SoapAction As %String(MAXLEN = "");

Property Operacao As %String(MAXLEN = "");

ClassMethod ExisteRegistroSituacaoAtivoREST(Output pID As %String = "", pSistema As %String(MAXLEN="") = "", pPath As %String(MAXLEN="") = "", pAcao As %String(MAXLEN="") = "") As %Boolean
{
    Set situacao = 1
    Set protocolo = "REST"

    Set params = ""
    Set params($INCREMENT(params)) = pSistema
    Set params($INCREMENT(params)) = pPath
    Set params($INCREMENT(params)) = pAcao
    Set params($INCREMENT(params)) = situacao
    Set params($INCREMENT(params)) = protocolo

    Set sql = "SELECT ID, COUNT(ID) As Total "_
                "FROM data_integracao.TblIntegracao "_
                "WHERE Sistema = ? "_
                "AND Path = ? "_
                "AND Acao = ? "_
                "AND Situacao = ? "_
                "AND Protocolo = ?"

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

ClassMethod ExisteRegistroSituacaoAtivoSOAP(Output pID As %String = "", pSistema As %String(MAXLEN="") = "", pPath As %String(MAXLEN="") = "", pSoapAction As %String(MAXLEN="") = "", pOperacao As %String(MAXLEN="") = "") As %Boolean
{
    Set situacao = 1
    Set protocolo = "SOAP"
    Set Acao = "POST"

    Set params = ""
    Set params($INCREMENT(params)) = situacao
    Set params($INCREMENT(params)) = pSistema
    Set params($INCREMENT(params)) = protocolo


    Set sql = "SELECT ID, COUNT(ID) As Total "_
                "FROM data_integracao.TblIntegracao "_
                "WHERE Situacao = ? "_
                "AND Sistema = ? "_
                "AND Protocolo = ?"

    Set validacaoSoapAction = ((pSoapAction '= "") && (pSoapAction '= "NULL"))
    Set validacaoOperacao = ((pOperacao '= "") && (pOperacao '= "NULL"))
    Set validaPath = ((pPath '= "") && (pPath '= "NULL"))
    
    If (validaPath '= 0)
    {
	   Set sql = sql_" AND Path = ? "
	   Set params($INCREMENT(params)) = pPath
    }

    If ((validacaoSoapAction = 0) && (validacaoOperacao = 0))
    {
        $$$THROWONERROR(Status, $System.Status.Error(5001, "Ao menos um dos campos SoapAction ou Operacao deve ser preenchido"))
    }

    If (validacaoSoapAction = 1)
    {
        Set sql = sql_" AND SoapAction = ?"
        Set params($INCREMENT(params)) = pSoapAction
    }

    If (validacaoOperacao = 1)
    {
        Set sql = sql_" AND Operacao = ?"
        Set params($INCREMENT(params)) = pOperacao
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

ClassMethod RetornarIdRegistroREST(pSistema As %String(MAXLEN="") = "", pPath As %String(MAXLEN="") = "", pAcao As %String(MAXLEN="") = "") As %String
{
    Set idRegistro = ..RetornarIdPorParametrosCompletoREST(pSistema, pPath, pAcao)
	Set:(idRegistro = "") idRegistro =..RetornarIdPorPathDinamicoREST(pSistema, pPath)
	
	Return idRegistro
}

ClassMethod RetornarIdPorParametrosCompletoREST(pSistema, pPath, pAcao) As %Integer
{
	Set situacao = 1
    Set protocolo = "REST"

    Set params = ""
    Set params($INCREMENT(params)) = pSistema
    Set params($INCREMENT(params)) = pPath
    Set params($INCREMENT(params)) = pAcao
    Set params($INCREMENT(params)) = situacao
    Set params($INCREMENT(params)) = protocolo

    Set sql = "SELECT ID "_
                "FROM data_integracao.TblIntegracao "_
                "WHERE Sistema = ? "_
                "AND Path = ? "_
                "AND Acao = ? "_
                "AND Situacao = ? "_
                "AND Protocolo = ?"

    Set statement = ##class(%SQL.Statement).%New()
    $$$THROWONERROR(Status, statement.%Prepare(sql))
    Set resultSet = statement.%Execute(params...)

    If (resultSet.%Next())
    {
        Return resultSet.ID
    }
    
    Return ""
}

ClassMethod RetornarIdPorPathDinamicoREST(pSistema, pPath) As %Integer
{
	Set situacao = 1
    Set protocolo = "REST"

	Set params = ""
    Set params($INCREMENT(params)) = pSistema
    Set params($INCREMENT(params)) = situacao
    Set params($INCREMENT(params)) = protocolo
    
    Set sql = "SELECT ID, "_
    			"Path "_
    			"FROM data_integracao.TblIntegracao "_
    			"WHERE Path LIKE '%<<Parametro>>%' "_
    			"AND Sistema = ? "_
    			"AND Situacao = ? "_
    			"AND Protocolo = ? "
    			
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
	        
	        If (t '= "<<Parametro>>") 
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

ClassMethod RetornarIdRegistroSOAP(pSistema As %String(MAXLEN="") = "", pPath As %String(MAXLEN="") = "", pSoapAction As %String(MAXLEN="") = "", pOperacao As %String(MAXLEN="") = "") As %String
{
    Set situacao = 1
    Set protocolo = "SOAP"
    Set Acao = "POST"

    Set params = ""
    Set params($INCREMENT(params)) = situacao
    Set params($INCREMENT(params)) = pSistema
    Set params($INCREMENT(params)) = protocolo


    Set sql = "SELECT ID "_
                "FROM data_integracao.TblIntegracao "_
                "WHERE Situacao = ? "_
                "AND Sistema = ? "_
                "AND Protocolo = ?"

    Set validacaoSoapAction = ((pSoapAction '= "") && (pSoapAction '= "NULL"))
    Set validacaoOperacao = ((pOperacao '= "") && (pOperacao '= "NULL"))
    Set validaPath = ((pPath '= "") && (pPath '= "NULL"))
    
    If (validaPath '= 0)
    {
	   Set sql = sql_" AND Path = ? "
	   Set params($INCREMENT(params)) = pPath
    }

    If ((validacaoSoapAction = 0) && (validacaoOperacao = 0))
    {
        $$$THROWONERROR(Status, $System.Status.Error(5001, "Ao menos um dos campos SoapAction ou Operacao deve ser preenchido"))
    }
	
	
    Set sql = sql_" AND (SoapAction = ? OR Operacao = ?)"
    Set params($INCREMENT(params)) = pSoapAction
    Set params($INCREMENT(params)) = pOperacao

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
<Data name="TblIntegracaoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Path</Value>
</Value>
<Value name="3">
<Value>Acao</Value>
</Value>
<Value name="4">
<Value>Resposta</Value>
</Value>
<Value name="5">
<Value>ContentType</Value>
</Value>
<Value name="6">
<Value>Protocolo</Value>
</Value>
<Value name="7">
<Value>Situacao</Value>
</Value>
<Value name="8">
<Value>VersaoCheck</Value>
</Value>
<Value name="9">
<Value>Sistema</Value>
</Value>
<Value name="10">
<Value>Descricao</Value>
</Value>
<Value name="11">
<Value>StatusCode</Value>
</Value>
<Value name="12">
<Value>SoapAction</Value>
</Value>
<Value name="13">
<Value>Operacao</Value>
</Value>
</Data>
<DataLocation>^data.integracao.TblIntegracaoD</DataLocation>
<DefaultData>TblIntegracaoDefaultData</DefaultData>
<IdLocation>^data.integracao.TblIntegracaoD</IdLocation>
<IndexLocation>^data.integracao.TblIntegracaoI</IndexLocation>
<StreamLocation>^data.integracao.TblIntegracaoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
