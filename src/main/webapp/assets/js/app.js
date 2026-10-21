// Filtro local para encontrar registros sin recargar la página.
const search = document.querySelector('[data-search]');
if (search) {
    const rows = [...document.querySelectorAll('[data-row]')];
    const normalize = text => text.toLocaleLowerCase('es').normalize('NFD').replace(/[\u0300-\u036f]/g, '');
    search.addEventListener('input', () => {
        const term = normalize(search.value.trim());
        let visible = 0;
        rows.forEach(row => {
            row.hidden = !normalize(row.textContent).includes(term);
            if (!row.hidden) visible++;
        });
        document.querySelector('[data-no-results]').hidden = visible !== 0;
        document.querySelector('[data-count]').textContent = `${visible} resultado${visible === 1 ? '' : 's'}`;
    });
}

const loanDate = document.querySelector('[name="fechaPrestamo"]');
const returnDate = document.querySelector('[name="fechaDevolucion"]');
if (loanDate && returnDate) {
    const updateDateLimits = () => {
        returnDate.min = loanDate.value;
        if (loanDate.value) {
            const maximum = new Date(`${loanDate.value}T00:00:00`);
            maximum.setDate(maximum.getDate() + 14);
            returnDate.max = maximum.toISOString().slice(0, 10);
        } else {
            returnDate.removeAttribute('max');
        }
    };
    loanDate.addEventListener('change', updateDateLimits);
    updateDateLimits();
}

document.querySelectorAll('[data-return-form]').forEach(form => {
    form.addEventListener('submit', event => {
        if (!window.confirm('¿Confirmas que el libro fue devuelto a la biblioteca?')) event.preventDefault();
    });
});
const error = document.querySelector('[data-error]');
if (error) error.focus();
