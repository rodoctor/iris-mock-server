Class ativacao.InserirRegistros
{

ClassMethod Executar()
{
	Do ##Class(shift.util.Padrao).InserePathResponse("s01.util.b2b.shiftLis.automacaov2.LIS.ValidaUsuario",##class(framework.testes.util.XData).GerarStringFromXData($CLASSNAME(),"ValidaUsuario"), "text/xml")
	Do ##Class(shift.util.Padrao).InserePathResponse("s01.util.b2b.shiftLis.ensemblev2.Resultado.ExportarResultadoGeral",##class(framework.testes.util.XData).GerarStringFromXData($CLASSNAME(),"ExportarResultadoGeral"), "text/xml")
	Do ##Class(shift.util.Padrao).InserePathResponse("/apresentacao",##class(framework.testes.util.XData).GerarStringFromXData($CLASSNAME(),"Apresentacao"), "application/json")
   Do ##Class(shift.util.Padrao).InserePathResponse("/teste", ##class(framework.testes.util.XData).GerarStringFromXData($CLASSNAME(),"TesteRest"), "application/json")
}

XData ValidaUsuario
{
<?xml version="1.0" encoding="UTF-8" ?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV='http://schemas.xmlsoap.org/soap/envelope/' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:s='http://www.w3.org/2001/XMLSchema'>
    <SOAP-ENV:Body>
        <ValidaUsuarioResponse xmlns="http://www.e-lis.com.br">
            <ValidaUsuarioResult xmlns:s01="http://www.e-lis.com.br" xsi:type="s01:TblUsuario">
                <ID>1</ID>
                <Nome>Shift Consultoria e sistema</Nome>
                <Senha>AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA</Senha>
                <UserId>USUARIOTESTE</UserId>
                <DataNascimento>12/11/1988</DataNascimento>
                <RG>44444444</RG>
                <Sexo>M</Sexo>
                <Email>usuario@shift.com.br</Email>
                <ResultadoAlterado>1</ResultadoAlterado>
                <Perfil>00001</Perfil>
                <LoginStatus>OK</LoginStatus>
            </ValidaUsuarioResult>
        </ValidaUsuarioResponse>
    </SOAP-ENV:Body>
</SOAP-ENV:Envelope>
}

XData ExportarResultadoGeral
{
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:s="http://www.w3.org/2001/XMLSchema">
   <SOAP-ENV:Body>
      <ExportarResultadoGeralResponse xmlns="http://www.e-lis.com.br">
         <s01:ExportarResultadoGeralResult xmlns="http://www.shift.com.br" xmlns:s01="http://www.e-lis.com.br">
            <resultadoLab>
               <pedido>
                  <codigo/>
                  <posto>2</posto>
                  <postoDescricao>UTI Unimed</postoDescricao>
                  <convenio>2</convenio>
                  <ordemServico/>
                  <ordemServicoApoio>002-67191-4</ordemServicoApoio>
                  <dadosCadastrais>
                     <dadoCadastral>
                        <codigo>1</codigo>
                        <valor/>
                     </dadoCadastral>
                     <dadoCadastral>
                        <codigo>8</codigo>
                        <valor/>
                     </dadoCadastral>
                     <dadoCadastral>
                        <codigo>3</codigo>
                        <valor/>
                     </dadoCadastral>
                     <dadoCadastral>
                        <codigo>368</codigo>
                        <valor/>
                     </dadoCadastral>
                     <dadoCadastral>
                        <codigo>369</codigo>
                        <valor/>
                     </dadoCadastral>
                     <dadoCadastral>
                        <codigo>370</codigo>
                        <valor/>
                     </dadoCadastral>
                  </dadosCadastrais>
               </pedido>
               <paciente>
                  <codigo/>
                  <codigoApoio>56326</codigoApoio>
                  <nome>ANA ALKIMIM ELIS</nome>
                  <sexo>F</sexo>
                  <dtNascimento>1987-07-29</dtNascimento>
                  <cpf/>
                  <usuarioWeb/>
                  <email>anapaulacalkimim@hotmail.com.br</email>
                  <telefone/>
                  <celular/>
                  <nomeSocial/>
                  <filiacao/>
               </paciente>
               <exames>
                  <exame>
                     <codigo>1413</codigo>
                     <mnemonico>GLICO</mnemonico>
                     <descricao>GLICOSE [SORO]</descricao>
                     <mascara>
                        <data>2017-02-10</data>
                        <hora>16:57:15</hora>
                        <versaoMascara>1</versaoMascara>
                     </mascara>
                     <amostras>
                        <amostra>
                           <codigoBarra>240000466500</codigoBarra>
                           <tipo>A</tipo>
                        </amostra>
                     </amostras>
                     <guia/>
                     <observacao/>
                     <solicitacao>
                        <data>2024-12-17</data>
                        <hora>09:48:49</hora>
                     </solicitacao>
                     <coleta>
                        <data>2024-12-17</data>
                        <hora>09:48</hora>
                        <codResponsavel/>
                        <nomeResponsavel/>
                     </coleta>
                     <liberacao>
                        <data>2024-12-17</data>
                        <hora>09:49:24</hora>
                        <codResponsavel>1</codResponsavel>
                        <nomeResponsavel>Shift Consultoria e sistema</nomeResponsavel>
                     </liberacao>
                     <assinado/>
                     <resultados>
                        <resultado>
                           <descricao>GLICOSE JEJUM:</descricao>
                           <apelido>GLITESTE</apelido>
                           <valorId/>
                           <valor>70</valor>
                           <tipo>N</tipo>
                           <unMedida>mg/dl</unMedida>
                           <vlReferencia>60 a 99 mg/dL</vlReferencia>
                           <limiteSuperior/>
                           <limiteInferior/>
                           <processo>GLI</processo>
                           <metodologia>ENZIMÁTICO AUTOMATIZADO</metodologia>
                           <culturaPositiva>0</culturaPositiva>
                           <classificacao>-1</classificacao>
                           <sequenciaMascara>1</sequenciaMascara>
                           <resultadoParcial>0</resultadoParcial>
                           <antibiogramaNaoRealizado>0</antibiogramaNaoRealizado>
                           <notasLaudo><![CDATA[Nota:&nbsp;AC-XX e BAC-XX: C&oacute;digo alfanum&eacute;rico do Consenso Brasileiro de Autoanticorpos (CBA) e International Consensus on ANA Patterns (ICAP).
&nbsp;
A categoriza&ccedil;&atilde;o precisa do padr&atilde;o nuclear pontilhado fino ou grosso em testes de autoanticorpos pode ser complexa devido &agrave;
variabilidade na fluoresc&ecirc;ncia e &agrave; presen&ccedil;a de subtipos de anticorpos. Em tais casos, os resultados s&atilde;o interpretados conforme as
normas consensuais nacionais e internacionais, assegurando o devido tratamento e acompanhamento cl&iacute;nico.
(www.hep-2.com.br e www.anapatterns.org).
&nbsp;
Triagem realizada na dilui&ccedil;&atilde;o 1:80&nbsp;
Resultados reagentes na titula&ccedil;&atilde;o 1:80 possuem pouca relev&acirc;ncia cl&iacute;nica conforme a literatura.&nbsp;
Titula&ccedil;&otilde;es de 1:160 ou superiores s&atilde;o relevantes na avalia&ccedil;&atilde;o e investiga&ccedil;&atilde;o de doen&ccedil;as reum&aacute;ticas autoimunes.
&nbsp;
Nenhum resultado de FAN deve ser avaliado isoladamente, j&aacute; que resultados reagentes s&atilde;o frequentes em indiv&iacute;duos saud&aacute;veis mas n&atilde;o
indica um diagn&oacute;stico de doen&ccedil;a reum&aacute;tica autoimune. Devido a isso, &eacute; necess&aacute;ria a correla&ccedil;&atilde;o com quadro cl&iacute;nico e a solicita&ccedil;&atilde;o
dos autoanticorpos espec&iacute;ficos associados ao padr&atilde;o de fluoresc&ecirc;ncia do paciente para adequada interpreta&ccedil;&atilde;o do exame.]]></notasLaudo>
                        </resultado>
                     </resultados>
                     <resultadoURLExame><![CDATA[https://cst-qa01.shiftcloud.com.br/shift/lis/lisdevqa/elis/s01.relatorio.atendimento.LaudoAplicativo.cls?CodOs=002-67191-4&Medico=1&Hash=EF7877BFCCE951E6E0ED7B7F942C65A77BCDE2B&UsuarioWebTipo=&UsuarioWebId=&ListaProcedimentos=76712&ValidarMobile=0&Integracao=NAODEFINIDO]]></resultadoURLExame>
                     <medicos>
                        <medico>
                           <nome>Sem solicitação Médica</nome>
                           <crm>0</crm>
                           <conselho>OUT</conselho>
                           <uf>NA</uf>
                           <email/>
                           <telefone/>
                           <celular/>
                        </medico>
                     </medicos>
                  </exame>
               </exames>
               <resultadoURLPedido><![CDATA[https://cst-qa01.shiftcloud.com.br/shift/lis/lisdevqa/elis/s01.relatorio.atendimento.LaudoAplicativo.cls?CodOs=002-67191-4&Medico=1&Hash=EF7877BFCCE951E6E0ED7B7F942C65A77BCDE2B&UsuarioWebTipo=&UsuarioWebId=&ListaProcedimentos=76712&ValidarMobile=0&Integracao=NAODEFINIDO]]></resultadoURLPedido>
            </resultadoLab>
            <resultadoLab>
               <pedido>
                  <codigo/>
                  <posto>2</posto>
                  <postoDescricao>UTI Unimed</postoDescricao>
                  <convenio>2</convenio>
                  <ordemServico/>
                  <ordemServicoApoio>002-67191-6</ordemServicoApoio>
                  <dadosCadastrais>
                     <dadoCadastral>
                        <codigo>1</codigo>
                        <valor/>
                     </dadoCadastral>
                     <dadoCadastral>
                        <codigo>8</codigo>
                        <valor/>
                     </dadoCadastral>
                     <dadoCadastral>
                        <codigo>3</codigo>
                        <valor/>
                     </dadoCadastral>
                     <dadoCadastral>
                        <codigo>368</codigo>
                        <valor/>
                     </dadoCadastral>
                     <dadoCadastral>
                        <codigo>369</codigo>
                        <valor/>
                     </dadoCadastral>
                     <dadoCadastral>
                        <codigo>370</codigo>
                        <valor/>
                     </dadoCadastral>
                  </dadosCadastrais>
               </pedido>
               <paciente>
                  <codigo/>
                  <codigoApoio>35766</codigoApoio>
                  <nome>TESTE ANA PAULA C ALKIMIM</nome>
                  <sexo>F</sexo>
                  <dtNascimento>1987-07-29</dtNascimento>
                  <cpf>07661424690</cpf>
                  <usuarioWeb>P35766</usuarioWeb>
                  <email>anapaula.alkimim@shift.com.br</email>
                  <telefone>()</telefone>
                  <celular/>
                  <enderecos>
                     <endereco>
                        <logradouro>Rua Seringueira</logradouro>
                        <complemento/>
                        <numero>1169</numero>
                        <bairro>Planalto</bairro>
                        <cep>39404665</cep>
                        <cidade>Montes Claros</cidade>
                        <estado>MG</estado>
                     </endereco>
                  </enderecos>
                  <nomeSocial/>
                  <filiacao/>
               </paciente>
               <exames>
                  <exame>
                     <codigo>1413</codigo>
                     <mnemonico>GLICO</mnemonico>
                     <descricao>GLICOSE [SORO]</descricao>
                     <mascara>
                        <data>2017-02-10</data>
                        <hora>16:57:15</hora>
                        <versaoMascara>1</versaoMascara>
                     </mascara>
                     <amostras>
                        <amostra>
                           <codigoBarra>240000466700</codigoBarra>
                           <tipo>A</tipo>
                        </amostra>
                     </amostras>
                     <guia/>
                     <observacao/>
                     <solicitacao>
                        <data>2024-12-17</data>
                        <hora>12:24:29</hora>
                     </solicitacao>
                     <coleta>
                        <data>2024-12-17</data>
                        <hora>12:24</hora>
                        <codResponsavel/>
                        <nomeResponsavel/>
                     </coleta>
                     <liberacao>
                        <data>2024-12-17</data>
                        <hora>12:25:00</hora>
                        <codResponsavel>1</codResponsavel>
                        <nomeResponsavel>Shift Consultoria e sistema</nomeResponsavel>
                     </liberacao>
                     <assinado/>
                     <resultados>
                        <resultado>
                           <descricao>GLICOSE JEJUM:</descricao>
                           <apelido>GLITESTE</apelido>
                           <valorId/>
                           <valor>88</valor>
                           <tipo>N</tipo>
                           <unMedida>mg/dl</unMedida>
                           <vlReferencia>60 a 99 mg/dL</vlReferencia>
                           <limiteSuperior/>
                           <limiteInferior/>
                           <processo>GLI</processo>
                           <metodologia>ENZIMÁTICO AUTOMATIZADO</metodologia>
                           <culturaPositiva>0</culturaPositiva>
                           <classificacao>-1</classificacao>
                           <sequenciaMascara>1</sequenciaMascara>
                           <resultadoParcial>0</resultadoParcial>
                           <antibiogramaNaoRealizado>0</antibiogramaNaoRealizado>
                           <notasLaudo><![CDATA[Nota:&nbsp;AC-XX e BAC-XX: C&oacute;digo alfanum&eacute;rico do Consenso Brasileiro de Autoanticorpos (CBA) e International Consensus on ANA Patterns (ICAP).
&nbsp;
A categoriza&ccedil;&atilde;o precisa do padr&atilde;o nuclear pontilhado fino ou grosso em testes de autoanticorpos pode ser complexa devido &agrave;
variabilidade na fluoresc&ecirc;ncia e &agrave; presen&ccedil;a de subtipos de anticorpos. Em tais casos, os resultados s&atilde;o interpretados conforme as
normas consensuais nacionais e internacionais, assegurando o devido tratamento e acompanhamento cl&iacute;nico.
(www.hep-2.com.br e www.anapatterns.org).
&nbsp;
Triagem realizada na dilui&ccedil;&atilde;o 1:80&nbsp;
Resultados reagentes na titula&ccedil;&atilde;o 1:80 possuem pouca relev&acirc;ncia cl&iacute;nica conforme a literatura.&nbsp;
Titula&ccedil;&otilde;es de 1:160 ou superiores s&atilde;o relevantes na avalia&ccedil;&atilde;o e investiga&ccedil;&atilde;o de doen&ccedil;as reum&aacute;ticas autoimunes.
&nbsp;
Nenhum resultado de FAN deve ser avaliado isoladamente, j&aacute; que resultados reagentes s&atilde;o frequentes em indiv&iacute;duos saud&aacute;veis mas n&atilde;o
indica um diagn&oacute;stico de doen&ccedil;a reum&aacute;tica autoimune. Devido a isso, &eacute; necess&aacute;ria a correla&ccedil;&atilde;o com quadro cl&iacute;nico e a solicita&ccedil;&atilde;o
dos autoanticorpos espec&iacute;ficos associados ao padr&atilde;o de fluoresc&ecirc;ncia do paciente para adequada interpreta&ccedil;&atilde;o do exame.]]></notasLaudo>
                        </resultado>
                     </resultados>
                     <resultadoURLExame><![CDATA[https://cst-qa01.shiftcloud.com.br/shift/lis/lisdevqa/elis/s01.relatorio.atendimento.LaudoAplicativo.cls?CodOs=002-67191-6&Medico=1&Hash=89AF23461D79E2A1988CC6FAE197DD5E73B3AD&UsuarioWebTipo=&UsuarioWebId=&ListaProcedimentos=76715&ValidarMobile=0&Integracao=NAODEFINIDO]]></resultadoURLExame>
                     <medicos>
                        <medico>
                           <nome>Sem solicitação Médica</nome>
                           <crm>0</crm>
                           <conselho>OUT</conselho>
                           <uf>NA</uf>
                           <email/>
                           <telefone/>
                           <celular/>
                        </medico>
                     </medicos>
                  </exame>
               </exames>
               <resultadoURLPedido><![CDATA[https://cst-qa01.shiftcloud.com.br/shift/lis/lisdevqa/elis/s01.relatorio.atendimento.LaudoAplicativo.cls?CodOs=002-67191-6&Medico=1&Hash=89AF23461D79E2A1988CC6FAE197DD5E73B3AD&UsuarioWebTipo=&UsuarioWebId=&ListaProcedimentos=76715&ValidarMobile=0&Integracao=NAODEFINIDO]]></resultadoURLPedido>
            </resultadoLab>
         </s01:ExportarResultadoGeralResult>
      </ExportarResultadoGeralResponse>
   </SOAP-ENV:Body>
</SOAP-ENV:Envelope>
}

XData Apresentacao [ MimeType = text ]
{
{
        "status": "OK"
    }
}

XData TesteRest [ MimeType = text ]
{
{
        "teste": "teste"
    }
}

}
