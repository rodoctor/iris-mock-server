Class testes.HTTPRequest
{

ClassMethod TesteRequest()
{
	#Dim %request As %CSP.Request = ##class(%CSP.Request).%New()

	//Set %request.AppData = $lb("",64,1,"","/core/integracao/core/mock/","",1,"","",0,1,"",$lb(":%All"),"/core/integracao/core/mock","core_MOCKS","","",1,"","",1,"",900,2,2,"",3600,0,1,1,"",0,"","core.bs.http.Service",0,0)
	//Set %request.AppMatch = "/core/integracao/core/mock/"
	//Set %request.Application = "/core/integracao/core/mock/"
	//Set %request.CSPGatewayRequest = 1
	Set %request.CgiEnvs("CONTENT_LENGTH") = 0
	Set %request.CgiEnvs("CONTENT_TYPE") = ""
	Set %request.CgiEnvs("CONTEXT_DOCUMENT_ROOT") = "/binario/ensemble/csp"
	Set %request.CgiEnvs("CONTEXT_PREFIX") = ""
	Set %request.CgiEnvs("CSP_ORIGINAL_FILE") = ""
	Set %request.CgiEnvs("DOCUMENT_ROOT") = "/binario/ensemble/csp"
	Set %request.CgiEnvs("GATEWAY_INTERFACE") = "CGI/1.1"
	Set %request.CgiEnvs("HTTP_ACCEPT") = "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7"
	Set %request.CgiEnvs("HTTP_ACCEPT_ENCODING") = "gzip, deflate, br"
	Set %request.CgiEnvs("HTTP_ACCEPT_LANGUAGE") = "en-US,en;q=0.9,pt-BR;q=0.8,pt;q=0.7"
	Set %request.CgiEnvs("HTTP_CACHE_CONTROL") = "max-age=0"
	Set %request.CgiEnvs("HTTP_CONNECTION") = "keep-alive"
	Set %request.CgiEnvs("HTTP_COOKIE") = "CSPSESSIONID-SP-9092-UP-core-integracao-core-mock-=002000000000M42OHCLA4L00KkBABgRf89mrm2n04gmplXgJou; _ga=GA1.1.3566407A-2CB5-11EE-91C0-0242AC120002; _ga_0XC9Y1K6K9=GS1.1.1715340910.9.0.1715340910.0.0.0; CacheBrowserId=0gu5$nsQKzsv6JQGLQLa6g--; CSPSMTOKEN=209072414913090986496263087845; CSPWSERVERID=hzWBYxPC"
	Set %request.CgiEnvs("HTTP_DNT") = 1
	Set %request.CgiEnvs("HTTP_HOST") = "localhost:9092"
	Set %request.CgiEnvs("HTTP_SEC_CH_UA") = """Not)A;Brand"";v=""99"", ""Google Chrome"";v=""127"", ""Chromium"";v=""127"""
	Set %request.CgiEnvs("HTTP_SEC_CH_UA_MOBILE") = "?0"
	Set %request.CgiEnvs("HTTP_SEC_CH_UA_PLATFORM") = """Windows"""
	Set %request.CgiEnvs("HTTP_SEC_FETCH_DEST") = "document"
	Set %request.CgiEnvs("HTTP_SEC_FETCH_MODE") = "navigate"
	Set %request.CgiEnvs("HTTP_SEC_FETCH_SITE") = "none"
	Set %request.CgiEnvs("HTTP_SEC_FETCH_USER") = "?1"
	Set %request.CgiEnvs("HTTP_UPGRADE_INSECURE_%requestS") = 1
	Set %request.CgiEnvs("HTTP_USER_AGENT") = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36"
	Set %request.CgiEnvs("LD_LIBRARY_PATH") = "/binario/ensemble/bin:"
	Set %request.CgiEnvs("PATH") = "/usr/bin:/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:"
	Set %request.CgiEnvs("PATH_INFO") = ""
	Set %request.CgiEnvs("PATH_TRANSLATED") = "/binario/ensemble/csp/integracao/core/mock/"
	Set %request.CgiEnvs("QUERY_STRING") = ""
	Set %request.CgiEnvs("REMOTE_ADDR") = "172.18.0.1"
	Set %request.CgiEnvs("REMOTE_PORT") = 50312
	Set %request.CgiEnvs("Request_METHOD") = "GET"
	Set %request.CgiEnvs("Request_SCHEME") = "http"
	Set %request.CgiEnvs("Request_URI") = "/core/integracao/core/mock/"
	Set %request.CgiEnvs("SCRIPT_FILENAME") = "/binario/ensemble/csp/core"
	Set %request.CgiEnvs("SCRIPT_NAME") = "/core/integracao/core/mock/"
	Set %request.CgiEnvs("SERVER_ADDR") = "172.18.0.2"
	Set %request.CgiEnvs("SERVER_ADMIN") = "[no address given]"
	Set %request.CgiEnvs("SERVER_NAME") = "localhost"
	Set %request.CgiEnvs("SERVER_PORT") = 9092
	Set %request.CgiEnvs("SERVER_PORT_SECURE") = 0
	Set %request.CgiEnvs("SERVER_PROTOCOL") = "HTTP/1.1"
	Set %request.CgiEnvs("SERVER_SIGNATURE") = ""
	Set %request.CgiEnvs("SERVER_SOFTWARE") = "Apache/2.4.20 (linux) Cache_Server_Pages-Apache_Module/2017.2.1.801.0-1702.1631b"
	//Set %request.CharSet = ""
	//Set %request.Class = "core.bs.http.Service"
	//Set %request.ContentType = ""
	Set %request.Cookies("CSPSMTOKEN",1) = "209072414913090986496263087845"
	Set %request.Cookies("CSPWSERVERID",1) = "hzWBYxPC"
	Set %request.Cookies("CacheBrowserId",1) = "0gu5$nsQKzsv6JQGLQLa6g--"
	Set %request.Cookies("_ga",1) = "GA1.1.3566407A-2CB5-11EE-91C0-0242AC120002"
	Set %request.Cookies("_ga_0XC9Y1K6K9",1) = "GS1.1.1715340910.9.0.1715340910.0.0.0"
#;	Set %request.GatewayApplication = "/"
#;	Set %request.GatewayBuild = "661.1702.1631b"
#;	Set %request.GatewayConnectionName = "LOCAL"
#;	Set %request.GatewayError = ""
#;	Set %request.GatewayFunctions = 7
#;	Set %request.GatewayInstanceName = "ensemble:57772"
#;	Set %request.GatewayNewId = 0
#;	Set %request.GatewaySessionCookie = "CSPSESSIONID-SP-9092-UP-core-integracao-core-mock-"
#;	Set %request.GatewaySessionIdSource = 3
#;	Set %request.GatewayTimeout = 60
#;	Set %request.Method = "GET"
#;	Set %request.PageName = ""
#;	Set %request.ProcessedRequestType = 1
#;	Set %request.Protocol = "HTTP/1.1"
#;	Set %request.RequestId = 292
#;	Set %request.Secure = 0
#;	Set %request.Service = "REST"
#;	Set %request.URL = "/core/integracao/core/mock/"
#;	Set %request.URLPrefix = ""
#;	Set %request.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36"
#;	Set %request.WebSocketStatus = 0

	Do ##class(core.bs.http.Service).Service()
}

}
