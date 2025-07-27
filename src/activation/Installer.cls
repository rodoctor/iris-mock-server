Class activation.Installer Extends %Projection.AbstractProjection
{

ClassMethod CreateProjection(classname As %String) As %Status [ CodeMode = generator, ForceGenerate ]
{
	Set namespace = $NAMESPACE
	Set classe = "core.bs.http.Service"
	Set pathNamespace = $ZCONVERT($TRANSLATE($NAMESPACE,"_","/"),"l")
	Set pathApplication = $$$FormatText("/mock/%1/service",pathNamespace)

	Set application = ##class(%File).NormalizeDirectory(pathApplication)

    Set spec("AutheEnabled") = $$$AutheUnauthenticated
    Set spec("NameSpace") = namespace
    Set spec("Description") = "Api REST "_$ZCONVERT($TRANSLATE(namespace,"_"," "),"W")
    Set spec("IsNameSpaceDefault") = $$$NO
    Set spec("DispatchClass") = classe
    Set spec("MatchRoles")=":%All"

	Set namespace = $NAMESPACE
	zn "%SYS"
    If ('##class(Security.Applications).Exists(application))
    {
        Set ret = ##class(Security.Applications).Create(application, .spec)
    }
    Else
    {
        Set ret = ##class(Security.Applications).Modify(application, .spec)
    }

    Write !,"Change the permission of the DATABASE to RW",!
    Set resource = "%DB_"_namespace_"-CODE"
    Set Properties("Description") = "The "_namespace_" Database"
    Set Properties("PublicPermission") = "RW"
    
    Set Status = ##Class(Security.Resources).Modify(resource,.Properties)
    If $$$ISERR(Status) throw ##Class(%Exception.StatusException).CreateFromStatus(Status)

    Write "Change the permission of the DATABASE to RW finished",!

    zn namespace

	Return $$$OK
}

}
