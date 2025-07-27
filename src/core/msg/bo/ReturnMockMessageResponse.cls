Class core.msg.bo.ReturnMockMessageResponse Extends Ens.Response
{

Property Return As %Boolean [ InitialExpression = 1 ];

Property ErrorDescription As %VarString;

Property Response As %Stream.GlobalCharacter;

Property ContentType As %VarString;

Property StatusHTTP As %String;

Storage Default
{
<Data name="ReturnMockMessageResponseDefaultData">
<Subscript>"ReturnMockMessageResponse"</Subscript>
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
<DefaultData>ReturnMockMessageResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
