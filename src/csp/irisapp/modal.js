let allMocks = [];
let filteredMocks = [];

async function searchForm() {
    const modal = document.getElementById('searchModal');
    modal.classList.add('show');
    
    await refreshSearchResults();
}

function closeSearchModal() {
    const modal = document.getElementById('searchModal');
    modal.classList.remove('show');
}

async function refreshSearchResults() {
    showLoading(true);
    
    try {
        await listAllMockResponses();
        filterMocks();
    } catch (error) {
        console.error('Error refreshing search results:', error);
    } finally {
        showLoading(false);
    }
}

function showLoading(show) {
    const loading = document.getElementById('loadingIndicator');
    const noResults = document.getElementById('noResults');
    const table = document.querySelector('.results-table-container');
    
    if (show) {
        loading.classList.add('show');
        noResults.classList.remove('show');
        table.style.display = 'none';
    } else {
        loading.classList.remove('show');
        table.style.display = 'block';
    }
}

async function listAllMockResponses() {
    try {
        const response = await fetch('/mock/api/mock/getAllMockResponses');
        const result = await response.json();

        if (result.status == 'success' && result.data) {
            allMocks = result.data;
            return allMocks;
        } else {
            allMocks = [];
            console.error('Error loading mocks:', result);
            throw new Error('Failed to load mocks');
        }
    } catch (error) {
        allMocks = [];
        console.error('Error fetching mocks:', error);
        throw error;
    }
}

// Função para filtrar mocks
function filterMocks() {
    const systemFilter = document.getElementById('filterSystem').value.toLowerCase();
    const protocolFilter = document.getElementById('filterProtocol').value;
    const actionFilter = document.getElementById('filterAction').value;
    const situationFilter = document.getElementById('filterSituation').value;
    
    filteredMocks = allMocks.filter(mock => {
        const matchSystem = !systemFilter || mock.system.toLowerCase().includes(systemFilter);
        const matchProtocol = !protocolFilter || mock.protocol === protocolFilter;
        const matchAction = !actionFilter || mock.action === actionFilter;
        const matchSituation = !situationFilter || mock.situation.toString() === situationFilter;
        
        return matchSystem && matchProtocol && matchAction && matchSituation;
    });
    
    renderMocksTable();
    updateResultsCount();
}

function renderMocksTable() {
    const tbody = document.getElementById('mocksTableBody');
    const noResults = document.getElementById('noResults');
    
    if (filteredMocks.length === 0) {
        tbody.innerHTML = '';
        noResults.classList.add('show');
        return;
    }
    
    noResults.classList.remove('show');
    
    tbody.innerHTML = filteredMocks.map(mock => `
        <tr>
            <td>${mock.id || '-'}</td>
            <td><strong>${mock.system || '-'}</strong></td>
            <td>
                <span class="protocol-badge protocol-${mock.protocol.toLowerCase()}">
                    ${mock.protocol}
                </span>
            </td>
            <td>
                <code>${mock.path || '-'}</code>
            </td>
            <td>
                <code>${mock.action || '-'}</code>
            </td>
            <td>
                <code>${mock.soapAction || '-'}</code>
            </td>
            <td title="${mock.description}">
                ${truncateText(mock.description, 50)}
            </td>
            <td>
                <span class="status-badge status-${mock.situation == 1 ? 'active' : 'inactive'}">
                    ${mock.situation == 1 ? 'Active' : 'Inactive'}
                </span>
            </td>
            <td>
                <div class="action-buttons">
                    <button class="action-btn btn-edit" onclick="editMock(${mock.id})" title="Edit">
                       &#9998
                    </button>
                    <button class="action-btn btn-delete" onclick="deleteMock(${mock.id})" title="Delete">
                        &#10007;
                    </button>
                </div>
            </td>
        </tr>
    `).join('');
}

// Função para atualizar contador de resultados
function updateResultsCount() {
    const count = document.getElementById('resultsCount');
    const total = allMocks.length;
    const filtered = filteredMocks.length;
    
    if (total === filtered) {
        count.textContent = `${total} mocks found.`;
    } else {
        count.textContent = `${filtered} of ${total} mocks found.`;
    }
}

function truncateText(text, maxLength) {
    if (!text) return '-';
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength) + '...';
}

function editMock(id) {
    debugger
    const mock = allMocks.find(m => m.id == id);
    if (mock) {
        closeSearchModal();
        
        populateFormWithMock(mock);

        showToast('Mock Loaded', `Mock #${id} loaded for editing`, 3000);
    }
}

function populateFormWithMock(mock) {
    document.getElementById('newButton').hidden = true;
    document.getElementById('clearButton').hidden = false;
    document.getElementById('saveButton').hidden = false;
    document.getElementById('searchButton').hidden = false;
    document.getElementById('protocol').disabled = false;

    if (mock.protocol === 'REST') {
        selectedREST();
        document.getElementById('action').value = mock.action || '';
    } else if (mock.protocol === 'SOAP') {
        selectedSOAP();
        document.getElementById('soapAction').value = mock.soapAction || '';
        document.getElementById('operation').value = mock.operation || '';
    }
    debugger
    document.getElementById('code').value = mock.id || '';
    setMockActiveStatus(mock.situation);
    document.getElementById('protocol').value = mock.protocol || '';
    document.getElementById('system').value = mock.system || '';
    document.getElementById('description').value = mock.description || '';
    document.getElementById('statusHttp').value = mock.statusCode || '';
    document.getElementById('path').value = mock.path || '';
    document.getElementById('contentType').value = mock.contentType || '';
    document.getElementById('response').value = mock.response || '';

    
    updatePartOfPathId();
}

function deleteMock(id) {
    if (confirm(`Are you sure you want to delete mock #${id}?`)) {
        fetch(`/mock/api/mock/deleteMockResponse/${id}`, {
            method: 'DELETE'
        })
        .then(response => response.json())
        .then(result => {   
            if (result.status === 'success') {
                showToast('Mock Deleted', `Mock #${id} deleted successfully`, 3000);
                refreshSearchResults();
            } else {
                showToast('Error', `Error deleting mock: ${result.message}`, 3000);
            }
        })
        .catch(error => {
            console.error('Error deleting mock:', error);
            showToast('Error', 'Failed to delete mock', 3000);
        });

        setTimeout(() => {
            refreshSearchResults();
        }, 1000);
    }
}

document.addEventListener('click', function(event) {
    const modal = document.getElementById('searchModal');
    if (event.target === modal) {
        closeSearchModal();
    }
});

// Fechar modal com ESC
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        closeSearchModal();
    }
});