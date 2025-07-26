Class core.msg.bo.RetornarMensagemMockResponse Extends Ens.Response
{

Property Retorno As %Boolean [ InitialExpression = 1 ];

Property DescricaoErro As %VarString;

Property Resposta As %Stream.GlobalCharacter;

Property ContentType As %VarString;

Property StatusHTTP As %String;

Storage Default
{
<Data name="RetornarMensagemMockResponseDefaultData">
<Subscript>"RetornarMensagemMockResponse"</Subscript>
<Value name="1">
<Value>Retorno</Value>
</Value>
<Value name="2">
<Value>DescricaoErro</Value>
</Value>
<Value name="3">
<Value>Resposta</Value>
</Value>
<Value name="4">
<Value>ContentType</Value>
</Value>
<Value name="5">
<Value>StatusHTTP</Value>
</Value>
</Data>
<DefaultData>RetornarMensagemMockResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
