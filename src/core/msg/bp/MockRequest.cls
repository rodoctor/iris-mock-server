Class core.msg.bp.MockRequest Extends Ens.Request
{

Property HttpRequestJson As %Stream.GlobalCharacter;

Property DumpRequest As %Stream.GlobalCharacter;

Storage Default
{
<Data name="MockRequestDefaultData">
<Subscript>"MockRequest"</Subscript>
<Value name="1">
<Value>HttpRequestJson</Value>
</Value>
<Value name="2">
<Value>DumpRequest</Value>
</Value>
</Data>
<DefaultData>MockRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
