const fs = require('fs');
let code = fs.readFileSync('pos-frontend/src/lib/api.ts', 'utf8');

const throwLogic = `  if (!response.ok) {
    if (response.status === 401) {
      useAuthStore.getState().logout();
      window.location.href = '/login';
    }
    
    let backendMsg = '';
    try {
      const errorData = await response.json();
      backendMsg = errorData.message || errorData.error || '';
    } catch(e) {}
    
    throw new Error(backendMsg || \`API error: \${response.status} \${response.statusText}\`);
  }`;

code = code.replace(/  if \(\!response\.ok\) \{\n    if \(response\.status === 401\) \{\n      \/\/ Auto logout if 401 response returned from api\n      useAuthStore\.getState\(\)\.logout\(\);\n      window\.location\.href = '\/login';\n    \}\n    throw new Error\(`API error: \$\{response\.status\} \$\{response\.statusText\}`\);\n  \}/g, throwLogic);

fs.writeFileSync('pos-frontend/src/lib/api.ts', code);
