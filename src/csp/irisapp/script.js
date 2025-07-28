//Quero passar meus métodos todos para ingles
let enumsData = {};

document.addEventListener('DOMContentLoaded', function() {
    initializeForm();
    loadEnums();
    setupEventListeners();
    //configurarPath();
    //configurarTextareas();
});

function setupEventListeners() {
    const protocolSelect = document.getElementById('protocol');
    
    if (protocolSelect) {
        protocolSelect.addEventListener('change', function() {
            const selectedProtocol = this.value;
            handleProtocolChange(selectedProtocol);
        });
    } 

    const system = document.getElementById('system');
    if (system) {
        system.addEventListener('keyup', function() {
            updatePartOfPathId();
        });
    }
}

function copyPath() {
		const partOfPathId = document.getElementById('partOfPathId');
		const path = document.getElementById('path');

		const input = document.createElement("textarea");
        const fullPath = partOfPathId.textContent + path.value; 
		input.value = fullPath;
		document.body.appendChild(input);
		input.select();

		const sucess = document.execCommand("copy");
		document.body.removeChild(input);
		
		var message = 'Erro ao copiar path para a área de transferência'
		if (sucess == 1) {
			message = 'Path copiado para a área de transferência'
		}

        showToast('Path Copied!!!', fullPath, 4000);
}

function handleProtocolChange(selectedProtocol) {
    switch (selectedProtocol) {
        case 'SOAP':
            selectedSOAP();
            break;
        case 'REST':
            selectedREST();
            break;
        default:
            hideGroup('actionGroup');
            hideGroup('pathGroup');
            hideGroup('systemGroup');
            hideGroup('descriptionGroup');
            hideGroup('statusGroup');
            hideGroup('contentTypeGroup');
            hideGroup('responseGroup');
            break;
    }
}

function selectedREST() {
    hideGroup('soapActionGroup');
    hideGroup('operationGroup');
    showGroup('actionGroup');
    showGroup('pathGroup');
    showGroup('systemGroup');
    showGroup('descriptionGroup');
    showGroup('statusHttpGroup');
    showGroup('contentTypeGroup');
    showGroup('responseGroup');

    document.getElementById('action').value = '';
    document.getElementById('statusHttp').value = '200';
    document.getElementById('system').value = '';
    document.getElementById('description').value = '';
    document.getElementById('path').value = '';
    document.getElementById('contentType').value = 'application/json';
    document.getElementById('response').value = '';
    document.getElementById('soapAction').value = '';
    document.getElementById('operation').value = '';
}

function selectedSOAP() {
    hideGroup('actionGroup');
    showGroup('soapActionGroup');
    showGroup('operationGroup');
    showGroup('pathGroup');
    showGroup('systemGroup');
    showGroup('descriptionGroup');
    showGroup('statusHttpGroup');
    showGroup('contentTypeGroup');
    showGroup('responseGroup');

    document.getElementById('action').value = '';
    document.getElementById('statusHttp').value = '200';
    document.getElementById('system').value = '';
    document.getElementById('description').value = '';
    document.getElementById('path').value = '';
    document.getElementById('contentType').value = 'text/xml';
    document.getElementById('response').value = '';
    document.getElementById('soapAction').value = '';
    document.getElementById('operation').value = '';
}

async function loadEnums() {
    try {
        const response = await fetch('/mock/api/enums/getAllEnums');
        const result = await response.json();

        if (result && result.data) {
            enumsData = result.data;
            populateEnumSelects();
        } else {
            console.error('Error loading enums:', result);
        }
    } catch (error) {
        console.error('Error fetching enums:', error);
    }
}

function populateEnumSelects() {

    const protocolSelect = document.getElementById('protocol');
    const actionSelect = document.getElementById('action');
    const statusSelect = document.getElementById('statusHttp');

    if (enumsData.Protocol) {
        const protocolValues = enumsData.Protocol.valueList.split(',').filter(v => v.trim() !== '');
        protocolValues.forEach(value => {
            const option = document.createElement('option');
            option.value = value;
            option.textContent = value;
            protocolSelect.appendChild(option);
        });
    }

    if (enumsData.Action) {
        const actionValues = enumsData.Action.valueList.split(',').filter(v => v.trim() !== '');
        actionValues.forEach(value => {
            const option = document.createElement('option');
            option.value = value;
            option.textContent = value;
            actionSelect.appendChild(option);
        });
    }

    if (enumsData.StatusHTTP) {
        if (enumsData.StatusHTTP.valueList && enumsData.StatusHTTP.displayList) {
            const statusValues = enumsData.StatusHTTP.valueList.split(',').filter(v => v.trim() !== '');
            const statusDisplays = enumsData.StatusHTTP.displayList.split(',').filter(d => d.trim() !== '');
            
            statusValues.forEach((value, index) => {
                const option = document.createElement('option');
                option.value = value;
                const display = statusDisplays[index] || value;
                option.textContent = `${value} - ${display}`;
                statusSelect.appendChild(option);
            });
        } 
    }


}

function hideGroup(idElementGroup) {
    document.getElementById(idElementGroup).hidden = true;
}

function showGroup(idElement) {
    document.getElementById(idElement).hidden = false;
}

function clearForm() {
    document.getElementById('newButton').hidden = false;
    document.getElementById('clearButton').hidden = true;
    document.getElementById('saveButton').hidden = true;
    document.getElementById('searchButton').hidden = false;

    initializeForm();
}

function newForm() {
    document.getElementById('newButton').hidden = true;
    document.getElementById('clearButton').hidden = false;
    document.getElementById('saveButton').hidden = false;
    document.getElementById('searchButton').hidden = false;

    document.getElementById('protocol').disabled = false;
    setMockActiveStatus(true)
}

async function initializeForm() {

    document.getElementById('protocol').disabled = true;

    hideGroup('codeGroup');
    hideGroup('actionGroup');
    hideGroup('soapActionGroup');
    hideGroup('operationGroup');
    hideGroup('systemGroup');
    hideGroup('descriptionGroup');
    hideGroup('statusHttpGroup');
    hideGroup('pathGroup');
    hideGroup('contentTypeGroup');
    hideGroup('responseGroup');

    document.getElementById('code').value = '';
    document.getElementById('protocol').disabled = true;
    document.getElementById('protocol').value = '';
    document.getElementById('action').value = '';
    document.getElementById('system').value = '';
    document.getElementById('description').value = '';
    document.getElementById('statusHttp').value = '';

    document.getElementById('path').value = '';
    document.getElementById('contentType').value = '';

    document.getElementById('response').value = '';

    setMockActiveStatus(true)
    updatePartOfPathId();
}

function updatePartOfPathId() {
    const partOfPathId = document.getElementById('partOfPathId');
    const system = document.getElementById('system').value.toLowerCase()

    if (system === '') {
        partOfPathId.textContent = `${window.location.host}/mock/api/`
        return;
    }
    partOfPathId.textContent = `${window.location.host}/mock/api/${system}/`
}

function setMockActiveStatus(isActive) {
    const activeRadio = document.querySelector('input[name="active"][value="1"]');
    const inactiveRadio = document.querySelector('input[name="active"][value="0"]');
    
    if (isActive === true || isActive === 1 || isActive === "1") {
        activeRadio.checked = true;
        inactiveRadio.checked = false;
    } else {
        activeRadio.checked = false;
        inactiveRadio.checked = true;
    }
}

// Função para obter o status atual
function getMockActiveStatus() {
    const checkedRadio = document.querySelector('input[name="active"]:checked');
    return checkedRadio ? checkedRadio.value : "1"; // Default para ativo
}

//Quero implementar a chamara para listar todos os mocks 
async function listAllMockResponses() {
    try {
        const response = await fetch('/mock/api/mock/getAllMockResponses');
        const result = await response.json();

        if (result.status == 'success' && result.data.length > 0) {
            console.log(result)
        } else {
            console.error('Error loading mocks:', result);
        }
    } catch (error) {
        console.error('Error fetching mocks:', error);
    }
}
