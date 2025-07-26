Class core.modelo.http.CSPRequest Extends core.modelo.Base
{

Property URL As %String(MAXLEN = "");

Property store As %ArrayOfDataTypes [ InitialExpression = {##class(%ArrayOfDataTypes).%New()} ];

Property PageName As %String(MAXLEN = "");

Property URLPrefix As %String(MAXLEN = "");

Property UserAgent As %String(MAXLEN = "");

Property RequestId As %String(MAXLEN = "");

Property WebSocketStatus As %Integer [ InitialExpression = 0 ];

Property ContentType As %String(MAXLEN = "");

Property CharSet As %String(MAXLEN = "");

Property ConvertCharSet As %String(MAXLEN = "");

Property Content As %Stream.Object;

Property Method As %String(MAXLEN = "");

Property Protocol As %String(MAXLEN = "") [ InitialExpression = "HTTP/1.1" ];

Property Secure As %Boolean [ InitialExpression = 0 ];

Property GatewayApplication As %String(MAXLEN = "");

Property GatewayConnectionName As %String(MAXLEN = "");

Property GatewaySessionIdSource As %Integer;

Property GatewayNewId As %Boolean [ InitialExpression = 0 ];

Property GatewayBuild As %String(MAXLEN = "");

Property GatewayFunctions As %String(MAXLEN = "");

Property GatewaySessionCookie As %String(MAXLEN = "");

Property GatewayInstanceName As %String(MAXLEN = "");

Property GatewayError As %Status;

Property Application As %String(MAXLEN = "");

Property CSPGatewayRequest As %Boolean [ InitialExpression = 0 ];

Property GatewayTimeout As %Integer [ InitialExpression = 60 ];

Property Data As %ArrayOfDataTypes;

Property Cookies As %ArrayOfObjects;

Property MimeData As %ArrayOfObjects;

Property CgiEnvs As %ArrayOfDataTypes;

Property AppData As %String(MAXLEN = "");

Property AppMatch As %String(MAXLEN = "");

Property ProcessedRequestType As %Boolean [ InitialExpression = 0 ];

Property SoapAction As %ArrayOfDataTypes;

Method PopulaObjeto(request As %CSP.Request)
{
	Set stream = ##class(%Stream.GlobalCharacter).%New()

	Set sql = ..PropertyDefinition()

	Set resultSet = ##class(%SQL.Statement).%ExecDirect(,sql)
	While resultSet.%Next()
	{
		Set propertyName = resultSet.Name
		Set multidimensional = resultSet.Multidimensional
		Set privado = (resultSet.Private || resultSet.Internal)

		If (privado)
		{
			Do:(multidimensional) @("$THIS."_propertyName_"NewObject()")
			Continue
		}
		ElseIf(multidimensional)
		{		
			Do @("$THIS."_propertyName_"NewObject()")
			Do ..PropertyMultidimensional(request,propertyName)
		}
		Else
		{
			Set $PROPERTY($THIS,propertyName) = $PROPERTY(request,propertyName)
		}
	}
		
	Quit $$$OK
}

ClassMethod PropertyDefinition() As %String
{
	Return "SELECT "_$$$NL_
				"	Name, "_$$$NL_
				"	Multidimensional, "_$$$NL_
				"	Private, "_$$$NL_
				"	Internal "_$$$NL_
				"FROM "_
				"	%Dictionary.PropertyDefinition "_$$$NL_
				"WHERE "_$$$NL_
				"	parent = '%CSP.Request' "_$$$NL_
				"ORDER BY SequenceNumber "
}

Method PropertyMultidimensional(pRequest, pPropertyName)
{
	Set contemDescendentes = 0
	
	Set key = ""
	Set prop = "pRequest."_pPropertyName_"("""_key_""")"

	Set key = $ORDER(@(prop))

	Set arrayString = ##class(%ArrayOfDataTypes).%New()
	Set arrayString.ElementType = "%VarString"
	While (key '= "")
	{
		Set prop = "pRequest."_pPropertyName_"("""_key_""")"
		
		Set contemDescendentes = $DATA(@(prop))
		If (contemDescendentes = 10)
		{
			Set keySub = ""
			Set propSub = "pRequest."_pPropertyName_"("""_key_""","""_keySub_""")"		
			
			Set keySub = $ORDER(@(propSub))
			
			Set listaItens = ##class(%ListOfObjects).%New()	
			While (keySub '= "")
			{
				Set propSub = "pRequest."_pPropertyName_"("""_key_""","""_keySub_""")"		
				Set valueSub = @("pRequest."_pPropertyName_"("""_key_""","_keySub_")")
				Set streamObject = ##class(%Stream.GlobalCharacter).%New()
				
				If ($ISOBJECT(valueSub) = 0)
				{
					$$$THROWONERROR(Status,streamObject.Write(valueSub))
				}
				Else
				{
					$$$THROWONERROR(Status, streamObject.CopyFrom(valueSub))
				}
				
				$$$THROWONERROR(Status,listaItens.Insert(streamObject))				
				Set keySub = $ORDER(@(propSub))
			}
			Set Status = $PROPERTY($THIS,pPropertyName).SetAt(listaItens,key)
		}
		Else
		{
			Set value = $PROPERTY(pRequest,pPropertyName,key)
			Set:(value = "") value = "NULL"
			
			Set $PROPERTY($THIS,pPropertyName).ElementType = "%VarString"
			Set Status = $PROPERTY($THIS,pPropertyName).SetAt(value,key)
		}
		Set key = $ORDER(@(prop))
	}
}

Storage Default
{
<Data name="CSPRequestState">
<Subscript>"CSPRequest"</Subscript>
<Value name="1">
<Value>URL</Value>
</Value>
<Value name="2">
<Value>store</Value>
</Value>
<Value name="3">
<Value>PageName</Value>
</Value>
<Value name="4">
<Value>URLPrefix</Value>
</Value>
<Value name="5">
<Value>UserAgent</Value>
</Value>
<Value name="6">
<Value>RequestId</Value>
</Value>
<Value name="7">
<Value>WebSocketStatus</Value>
</Value>
<Value name="8">
<Value>ContentType</Value>
</Value>
<Value name="9">
<Value>CharSet</Value>
</Value>
<Value name="10">
<Value>ConvertCharSet</Value>
</Value>
<Value name="11">
<Value>Content</Value>
</Value>
<Value name="12">
<Value>Method</Value>
</Value>
<Value name="13">
<Value>Protocol</Value>
</Value>
<Value name="14">
<Value>Secure</Value>
</Value>
<Value name="15">
<Value>GatewayApplication</Value>
</Value>
<Value name="16">
<Value>GatewayConnectionName</Value>
</Value>
<Value name="17">
<Value>GatewaySessionIdSource</Value>
</Value>
<Value name="18">
<Value>GatewayNewId</Value>
</Value>
<Value name="19">
<Value>GatewayBuild</Value>
</Value>
<Value name="20">
<Value>GatewayFunctions</Value>
</Value>
<Value name="21">
<Value>GatewaySessionCookie</Value>
</Value>
<Value name="22">
<Value>GatewayInstanceName</Value>
</Value>
<Value name="23">
<Value>GatewayError</Value>
</Value>
<Value name="24">
<Value>Application</Value>
</Value>
<Value name="25">
<Value>CSPGatewayRequest</Value>
</Value>
<Value name="26">
<Value>GatewayTimeout</Value>
</Value>
<Value name="27">
<Value>Data</Value>
</Value>
<Value name="28">
<Value>Cookies</Value>
</Value>
<Value name="29">
<Value>CgiEnvs</Value>
</Value>
<Value name="30">
<Value>AppData</Value>
</Value>
<Value name="31">
<Value>AppMatch</Value>
</Value>
<Value name="32">
<Value>ProcessedRequestType</Value>
</Value>
<Value name="33">
<Value>SoapAction</Value>
</Value>
<Value name="34">
<Value>MimeData</Value>
</Value>
</Data>
<State>CSPRequestState</State>
<Type>%Storage.Serial</Type>
}

}
