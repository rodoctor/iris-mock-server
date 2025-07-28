Class core.msg.bp.MockResponse Extends Ens.Response
{

Property Return As %Boolean [ InitialExpression = 1 ];

Property ErrorDescription As %String(MAXLEN = "");

Property Response As %Stream.GlobalCharacter;

Property ContentType As %String(MAXLEN = "");

Property StatusHTTP As %String;

Storage Default
{
<Data name="MockResponseDefaultData">
<Subscript>"MockResponse"</Subscript>
<Value name="1">
<Value>Return</Value>
</Value>
<Value name="2">
<Value>ErrorDescription</Value>
</Value>
<Value name="3">
<Value>Response</Value>
</Value>
<Value name="4">
<Value>ContentType</Value>
</Value>
<Value name="5">
<Value>StatusHTTP</Value>
</Value>
</Data>
<DefaultData>MockResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
