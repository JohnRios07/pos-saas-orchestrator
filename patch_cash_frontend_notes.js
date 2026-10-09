const fs = require('fs');
let code = fs.readFileSync('pos-frontend/src/pages/CashManagement.tsx', 'utf8');

code = code.replace(
    'const [actualBalance, setActualBalance] = useState<number | \'\'>(\'\');',
    'const [actualBalance, setActualBalance] = useState<number | \'\'>(\'\');\n  const [closingNotes, setClosingNotes] = useState(\'\');\n  const [requireNotes, setRequireNotes] = useState(false);'
);

code = code.replace(
    'actualBalance: Number(actualBalance)',
    'actualBalance: Number(actualBalance),\n          closingNotes'
);

// Modify the catch block
code = code.replace(
    /    \} catch \(err\) \{\n      setError\('Error al cerrar el turno\.'\);\n    \}/,
    `    } catch (err: any) {
      if (err.message && err.message.includes('DIFERENCIA:')) {
        setError(err.message);
        setRequireNotes(true);
      } else {
        setError(err.message || 'Error al cerrar el turno.');
      }
    }`
);

// Add the notes textarea in the UI
const notesJsx = `
              {requireNotes && (
                <div>
                  <label className="block text-sm font-medium text-gray-700">Observaciones (Obligatorio por diferencia de saldo)</label>
                  <textarea
                    value={closingNotes}
                    onChange={e => setClosingNotes(e.target.value)}
                    className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 border p-2"
                    rows={3}
                    required
                  />
                </div>
              )}
`;

code = code.replace(
    '              <button',
    notesJsx + '\n              <button'
);

fs.writeFileSync('pos-frontend/src/pages/CashManagement.tsx', code);
