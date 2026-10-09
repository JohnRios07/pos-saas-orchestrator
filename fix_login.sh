#!/bin/bash
sed -i '/useAuthStore.getState().setSession(data.token, data.userId, data.tenantId);/a \
      // Fetch initial config for MVP (single store & register)\n      const configRes = await fetch(`${API_URL}/api/config/initial`, {\n        headers: { Authorization: `Bearer ${data.token}` }\n      });\n      if (configRes.ok) {\n        const configData = await configRes.json();\n        useAuthStore.getState().setConfig(configData.storeId, configData.registerId);\n      }' pos-frontend/src/pages/Login.tsx
