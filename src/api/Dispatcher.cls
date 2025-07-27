Class api.Dispatcher Extends %CSP.REST
{

Parameter HandleCorsRequest = 1;

Parameter CONTENTTYPEJSON = "application/json";

Parameter CHARSET = "UTF-8";

// <Map Prefix="/docserver" Forward="%Api.v1.DocServer"/>

XData UrlMap
{
<Routes>
  <Route Url="/ping" Method="GET" Call="Ping"/>
  <Map Prefix="/enums" Forward="api.rest.EnumController"/>
</Routes>
}

ClassMethod Ping() As %Boolean
{
  Write "{""status"":""ok""}"
  Quit 1
}

ClassMethod Teste()
{
    Set a = "http://localhost:52773/mock/api/ping/"
    Set http = ##class(%Net.HttpRequest).%New()
    Set Status = http.Get(a)

    zw Status
    w http.HttpResponse.Data.Read()
}

}
