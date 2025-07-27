Class pages.index Extends %CSP.Page
{

Parameter CONTENTTYPE = "text/html";

Parameter CHARSET = "UTF-8";

ClassMethod OnPage() As %Status
{
    // Obter a lista de protocolos do enum
    Set displayList = ##class(data.integracao.enum.Protocolo).#VALUELIST
    
    &html<
    <!DOCTYPE html>
    <html lang="pt-br">
        <head>
        <meta charset="UTF-8">
        <title>Tela de Mock - Simulação de Serviço</title>
        <link rel="stylesheet" href="/csp/irisapp/style.css">
        <script src="/csp/irisapp/script.js"></script>
        </head>
        <body>
            <h1>Mock de Serviço - Simulação</h1>
            <div class="container">
                <div class="buttons">
                <button>Limpar</button>
                <button>Novo</button>
                <button>Pesquisar</button>
                </div>

                <label for="codigo">Código:</label>
                <input type="text" id="codigo" name="codigo">

                <label for="protocolo">Protocolo:</label>
                <select id="protocolo" placeholder="Selecione um protocolo">
                    <option value="" disabled selected>Selecione um protocolo</option>
    >
    
    Set displayList = ##class(data.integracao.enum.Protocolo).#VALUELIST
    For indiceDisplay=1:1:$Length(displayList,",") {
        Set protocoloValue = $Piece(displayList,",",indiceDisplay)
        If protocoloValue'="" {
            &html<<option value="#(protocoloValue)#">#(protocoloValue)#</option>>
        }
    }
    
    &html<
                </select>

                <label for="acao">Ação:</label>
                <select id="acao" placeholder="Selecione uma ação">
    >
   
    Set displayList = ##class(data.integracao.enum.Acao).#VALUELIST
    For indiceDisplay=1:1:$Length(displayList,",") {
        Set acaoValue = $Piece(displayList,",",indiceDisplay)
        If acaoValue'="" {
            &html<<option value="#(acaoValue)#">#(acaoValue)#</option>>
        }
    }

    &html<    
                </select>

                <label for="sistema">Sistema:</label>
                <input type="text" id="sistema" placeholder="Nome do sistema que será simulado.">

                <label for="descricao">Descrição:</label>
                <input type="text" id="descricao" placeholder="Descrição do serviço.">

                <label for="status">Status HTTP:</label>
                <select id="status">
    >

    Set displayList = ##class(data.integracao.enum.StatusHTTP).#DISPLAYLIST
    Set valueList = ##class(data.integracao.enum.StatusHTTP).#VALUELIST
    For indiceDisplay=1:1:$Length(displayList,",") {
        Set statusValue = $Piece(valueList,",",indiceDisplay)
        Set statusDisplay = $Piece(displayList,",",indiceDisplay)
        If statusValue'="" {
            &html<<option value="#(statusValue)#">#(statusValue_" - "_statusDisplay)#</option>>
        }
    }

    &html<
                </select>

                <label for="path">Path:</label>
                <div class="path-wrapper">
                <input type="text" id="path" value="http://localhost:9092/shift/integracao/shift/mock/servico/">
                <button type="button">Copiar</button>
                </div>

                <label for="contentType">ContentType:</label>
                <input type="text" id="contentType">

                <label for="resposta">Resposta:</label>
                <textarea id="resposta" placeholder="Corpo da resposta simulada em JSON, XML etc."></textarea>

                <div class="radio-group">
                <label><input type="radio" name="ativo" value="1" checked> Ativo</label>
                <label><input type="radio" name="ativo" value="0"> Inativo</label>
                </div>
            </div>
        </body>
    </html>
    >
    Quit $$$OK
}

}
