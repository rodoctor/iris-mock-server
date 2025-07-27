document.addEventListener('DOMContentLoaded', function() {
    // Verificar se o elemento com id 'partOfPathId' já existe
    if (!document.getElementById('partOfPathId')) {
        // Recuperar o path base da URL atual
        const url = new URL(window.location.href);
        const basePath = url.href.substring(0, url.href.lastIndexOf('/')) + '/service/';

    // Criar span com o path base
    const span = document.createElement('span');
    span.id = 'partOfPathId';
    span.textContent = basePath;
    span.style = 'font-weight: lighter; font-size: 9px; border: 1px solid #ccc; padding: 3px; margin-right: 5px;';

    // Atualizar o botão de copiar existente
    const copyButton = document.querySelector('.path-wrapper button');
    if (copyButton) {
        copyButton.onclick = function() {
            const pathInput = document.getElementById('path');
            const fullPath = basePath + (pathInput.value || '');

            // Usar a API moderna de clipboard se disponível
            if (navigator.clipboard) {
                navigator.clipboard.writeText(fullPath).then(function() {
                    alert('Path copiado para a área de transferência');
                }).catch(function() {
                    copyToClipboardFallback(fullPath);
                });
            } else {
                copyToClipboardFallback(fullPath);
            }
        };
    }

    // Função fallback para copiar
    function copyToClipboardFallback(text) {
        const textarea = document.createElement("textarea");
        textarea.value = text;
        document.body.appendChild(textarea);
        textarea.select();
        
        try {
            const success = document.execCommand("copy");
            const message = success ? 'Path copiado para a área de transferência' : 'Erro ao copiar path para a área de transferência';
            alert(message);
        } catch (err) {
            alert('Erro ao copiar path para a área de transferência');
        }
        
        document.body.removeChild(textarea);
    }

    // Inserir o span antes do input de path
    const pathWrapper = document.querySelector('.path-wrapper');
    const pathInput = document.getElementById('path');
    if (pathWrapper && pathInput) {
        pathWrapper.insertBefore(span, pathInput);
        pathInput.value = '';
        pathInput.placeholder = 'Digite o restante do path...';
    }
});