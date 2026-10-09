#!/bin/bash
cd pos-backend/src/main/java/com/company/pos

find . -name "*.java" -exec sed -i "s/UUID.fromString(\"00000000-0000-0000-0000-000000000000\")/com.company.pos.auth.application.UserContext.getUserId() != null ? com.company.pos.auth.application.UserContext.getUserId() : UUID.fromString(\"33333333-3333-3333-3333-333333333333\")/g" {} +

