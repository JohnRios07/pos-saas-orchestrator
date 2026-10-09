#!/bin/bash
for file in pos-frontend/src/pages/Sales.tsx pos-frontend/src/pages/Customers.tsx; do
  sed -i "s/document_type: 'DNI'/document_type: 'CC'/g" $file
  
  sed -i 's/<option value="DNI">DNI<\/option>/<option value="CC">CC (Cédula de Ciudadanía)<\/option>/g' $file
  
  sed -i 's/<option value="RUC">RUC<\/option>/<option value="NIT">NIT<\/option>\n                    <option value="TI">TI (Tarjeta de Identidad)<\/option>/g' $file
  
  sed -i 's/<option value="CE">CE<\/option>/<option value="CE">CE (Cédula de Extranjería)<\/option>/g' $file
done
