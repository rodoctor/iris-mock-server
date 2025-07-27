Class core.msg.bo.ReturnMockMessageRequest Extends Ens.Request
{

Property HttpRequestJson As %Stream.GlobalCharacter;

Property DumpRequest As %Stream.GlobalCharacter;

Storage Default
{
<Data name="ReturnMockMessageRequestDefaultData">
<Subscript>"ReturnMockMessageRequest"</Subscript>
<Value name="1">
<Value>HttpRequestJson</Value>
</Value>
<Value name="2">
<Value>DumpRequest</Value>
</Value>
</Data>
<DefaultData>ReturnMockMessageRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
