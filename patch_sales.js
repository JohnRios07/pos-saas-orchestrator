const fs = require('fs');
const file = 'pos-frontend/src/pages/Sales.tsx';
let content = fs.readFileSync(file, 'utf8');

const popupCode = `
      {showCashErrorPopup && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
          <div className="bg-white p-6 rounded-lg w-full max-w-md text-center">
            <div className="mb-4">
              <svg className="mx-auto h-12 w-12 text-red-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
              </svg>
            </div>
            <h3 className="text-xl font-bold mb-2">Caja Cerrada</h3>
            <p className="text-gray-600 mb-6">No puedes procesar pagos porque no hay una sesi&oacute;n de caja abierta. Por favor, abre la caja primero.</p>
            <div className="flex space-x-3">
              <button
                onClick={() => setShowCashErrorPopup(false)}
                className="flex-1 bg-gray-200 text-gray-800 px-4 py-2 rounded-md hover:bg-gray-300"
              >
                Cancelar
              </button>
              <button
                onClick={() => navigate('/cash-management')}
                className="flex-1 bg-indigo-600 text-white px-4 py-2 rounded-md hover:bg-indigo-700"
              >
                Ir a Caja
              </button>
            </div>
          </div>
        </div>
      )}
`;

content = content.replace('      {showPaymentModal && (', popupCode + '\n      {showPaymentModal && (');
fs.writeFileSync(file, content);
