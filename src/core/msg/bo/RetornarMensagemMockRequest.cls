Class core.msg.bo.RetornarMensagemMockRequest Extends Ens.Request
{

Property HttpRequestJson As %Stream.GlobalCharacter;

Property DumpRequest As %Stream.GlobalCharacter;

Storage Default
{
<Data name="RetornarMensagemMockRequestDefaultData">
<Subscript>"RetornarMensagemMockRequest"</Subscript>
<Value name="1">
<Value>HttpRequestJson</Value>
</Value>
<Value name="2">
<Value>DumpRequest</Value>
</Value>
</Data>
<DefaultData>RetornarMensagemMockRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
