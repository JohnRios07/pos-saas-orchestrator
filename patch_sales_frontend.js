const fs = require('fs');
let code = fs.readFileSync('pos-frontend/src/pages/Sales.tsx', 'utf8');

const modalJsx = `
      {showPaymentModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4">
          <div className="bg-white p-6 rounded-lg w-full max-w-md">
            <h3 className="text-xl font-bold mb-4">Métodos de Pago</h3>
            <p className="text-gray-600 mb-4">Gran Total a pagar: <span className="font-bold text-black">\${cartTotal.toFixed(2)}</span></p>
            
            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700">Efectivo</label>
                <input
                  type="number"
                  min="0"
                  step="0.01"
                  value={cashAmount}
                  onChange={e => setCashAmount(e.target.value ? Number(e.target.value) : '')}
                  className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700">Transferencia</label>
                <input
                  type="number"
                  min="0"
                  step="0.01"
                  value={transferAmount}
                  onChange={e => setTransferAmount(e.target.value ? Number(e.target.value) : '')}
                  className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2"
                />
              </div>
            </div>
            
            <div className="mt-6 flex space-x-3">
              <button
                onClick={() => setShowPaymentModal(false)}
                className="flex-1 bg-gray-200 text-gray-800 px-4 py-2 rounded-md hover:bg-gray-300"
              >
                Cancelar
              </button>
              <button
                onClick={handleCharge}
                disabled={loading || Math.abs((Number(cashAmount) || 0) + (Number(transferAmount) || 0) - cartTotal) > 0.01}
                className="flex-1 bg-indigo-600 text-white px-4 py-2 rounded-md hover:bg-indigo-700 disabled:opacity-50"
              >
                {loading ? 'Procesando...' : 'Confirmar Pago'}
              </button>
            </div>
            {Math.abs((Number(cashAmount) || 0) + (Number(transferAmount) || 0) - cartTotal) > 0.01 && (
              <p className="text-red-500 text-sm mt-2">La suma de los pagos debe coincidir con el total.</p>
            )}
          </div>
        </div>
      )}
`;

code = code.replace(
    '    </div>\n  );\n};\n',
    modalJsx + '\n    </div>\n  );\n};\n'
);

fs.writeFileSync('pos-frontend/src/pages/Sales.tsx', code);
