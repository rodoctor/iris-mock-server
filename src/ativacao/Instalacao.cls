Class ativacao.Instalacao Extends %Projection.AbstractProjection
{

ClassMethod CreateProjection(classname As %String) As %Status [ CodeMode = generator, ForceGenerate ]
{
	Set namespace = $NAMESPACE
	Set classe = "shift.bs.http.Service"
	Set caminhoNamespace = $ZCONVERT($TRANSLATE($NAMESPACE,"_","/"),"l")
	Set caminhoAplicacao = $$$FormatText("/shift/integracao/%1/service",caminhoNamespace)

	Set aplicacao = ##class(%File).NormalizeDirectory(caminhoAplicacao)

    Set spec("AutheEnabled") = $$$AutheUnauthenticated
    Set spec("NameSpace") = namespace
    Set spec("Description") = "Api REST "_$ZCONVERT($TRANSLATE(namespace,"_"," "),"W")
    Set spec("IsNameSpaceDefault") = $$$NO
    Set spec("DispatchClass") = classe
    Set spec("MatchRoles")=":%All"

	Set namespace = $NAMESPACE
	zn "%SYS"
    If ('##class(Security.Applications).Exists(aplicacao))
    {
        Set ret = ##class(Security.Applications).Create(aplicacao, .spec)
    }
    Else
    {
        Set ret = ##class(Security.Applications).Modify(aplicacao, .spec)
    }
    
    Write !,"Alterando permissão da DATABASE para RW",!
    Set resource = "%DB_"_namespace_"-CODE"
    Set Properties("Description") = "The "_namespace_" Database"
    Set Properties("PublicPermission") = "RW"
    
    Set Status = ##Class(Security.Resources).Modify(resource,.Properties)
    If $$$ISERR(Status) throw ##Class(%Exception.StatusException).CreateFromStatus(Status)
    
    Write "Alteração finalizada da permissão da DATABASE para RW",!
    
    zn namespace

	Return $$$OK
}

}
