// Toast System
function showToast(title, message, duration = 3000) {
    const container = document.getElementById('toastContainer');
    const toastId = `toast_${Date.now()}`;

    const toast = document.createElement('div');
    toast.id = toastId;

    toast.innerHTML = `
        <div class="toast-content">
            <div class="toast-title">${title}</div>
            <div class="toast-message">${message}</div>
        </div>
        <div class="toast-progress"></div>
    `;

    container.appendChild(toast);

    setTimeout(() => {
        toast.classList.add('show');
    }, 100);

    setTimeout(() => {
        hideToast(toastId);
    }, duration);

    return toastId;
}

function hideToast(toastId) {
    const toast = document.getElementById(toastId);
    if (toast) {
        toast.classList.add('hide');
        setTimeout(() => {
            toast.remove();
        }, 400);
    }
}