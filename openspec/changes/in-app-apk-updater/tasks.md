# Tasks: In-App APK Updater for Private POS Deployment

## Change ID
`in-app-apk-updater`

---

## Phase 1: Backend Foundation (`pos-backend`)

### TASK-001: GitHub Distribution Configuration & DTOs
**Files:**
- `src/main/java/com/company/pos/distribution/domain/AppVersion.java`
- `src/main/java/com/company/pos/distribution/application/dto/AppVersionResponse.java`
- `src/main/java/com/company/pos/distribution/infrastructure/config/GitHubDistributionProperties.java`
- `src/main/resources/application.properties`
**Priority:** P0
**Estimate:** 1h

**Subtasks:**
- [x] Define `AppVersion` domain record and `AppVersionResponse` DTO.
- [x] Define `@ConfigurationProperties(prefix = "app.distribution.github")` with fields `token`, `repository`, and `cacheTtlSeconds`.
- [x] Add default configuration and placeholder environment variables (`GITHUB_RELEASE_TOKEN`) in `application.properties`.

---

### TASK-002: AppUpdateService with Caching and Streaming
**Files:**
- `src/main/java/com/company/pos/distribution/application/AppUpdateService.java`
**Priority:** P0
**Estimate:** 2h
**Depends on:** TASK-001

**Subtasks:**
- [x] Implement GitHub Releases API client via `RestClient` with `Authorization: Bearer <token>` and `Accept: application/vnd.github+json`.
- [x] Parse latest release tag, publication timestamp, changelog body, and the `.apk` asset URL.
- [x] Implement in-memory cache with TTL (5 minutes) to protect against GitHub rate limits.
- [x] Implement `streamApkAsset()` method returning `StreamingResponseBody` that pipes the raw byte stream with `Accept: application/octet-stream`.

---

### TASK-003: AppDistributionController & SecurityConfig
**Files:**
- `src/main/java/com/company/pos/distribution/infrastructure/web/AppDistributionController.java`
- `src/main/java/com/company/pos/auth/infrastructure/security/SecurityConfig.java`
**Priority:** P0
**Estimate:** 1h
**Depends on:** TASK-002

**Subtasks:**
- [x] Create `AppDistributionController` with endpoints:
  - `GET /api/system/app-version`
  - `GET /api/system/app-download`
- [x] Add `/api/system/app-version` and `/api/system/app-download` to `SecurityConfig` `permitAll()`.
- [x] Configure appropriate HTTP headers (`Content-Type`, `Content-Disposition`, `Content-Length`).

---

### TASK-004: Backend Integration & Unit Tests
**Files:**
- `src/test/java/com/company/pos/distribution/AppDistributionControllerTest.java`
- `src/test/java/com/company/pos/distribution/AppUpdateServiceTest.java`
**Priority:** P1
**Estimate:** 1.5h
**Depends on:** TASK-003

**Subtasks:**
- [x] Write unit tests for `AppUpdateService` with mocked GitHub API responses.
- [x] Write integration test verifying `/api/system/app-version` returns 200 OK without authentication.
- [x] Verify test coverage and lint pass (`./gradlew test`).

---

## Phase 2: Android Native Bridge (`pos-frontend/android`)

### TASK-005: Android Permissions and FileProvider Configuration
**Files:**
- `android/app/src/main/AndroidManifest.xml`
- `android/app/src/main/res/xml/file_paths.xml`
**Priority:** P0
**Estimate:** 30m

**Subtasks:**
- [x] Add `<uses-permission android:name="android.permission.REQUEST_INSTALL_PACKAGES" />` to `AndroidManifest.xml`.
- [x] Ensure `file_paths.xml` exposes the cache directory for `FileProvider`.

---

### TASK-006: Native ApkUpdaterPlugin Implementation
**Files:**
- `android/app/src/main/java/app/rvpos/pos/ApkUpdaterPlugin.java`
- `android/app/src/main/java/app/rvpos/pos/MainActivity.java`
**Priority:** P0
**Estimate:** 2h
**Depends on:** TASK-005

**Subtasks:**
- [x] Create `ApkUpdaterPlugin.java` annotated with `@CapacitorPlugin(name = "ApkUpdater")`.
- [x] Implement `getAppInfo` extracting `versionCode` and `versionName`.
- [x] Implement `canRequestPackageInstalls` querying `PackageManager`.
- [x] Implement `openInstallPermissionSettings` dispatching `Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES`.
- [x] Implement `installApk` building secure `FileProvider` URI and launching `ACTION_VIEW` intent with `FLAG_GRANT_READ_URI_PERMISSION`.
- [x] Register `ApkUpdaterPlugin.class` in `MainActivity.java`.

---

### TASK-007: Capacitor Plugin TypeScript Definitions
**Files:**
- `src/plugins/apkUpdater.ts`
**Priority:** P0
**Estimate:** 30m
**Depends on:** TASK-006

**Subtasks:**
- [x] Define TypeScript interface `ApkUpdaterPlugin` and `AppInfo`.
- [x] Export `ApkUpdater` instance via `registerPlugin<ApkUpdaterPlugin>('ApkUpdater')`.

---

## Phase 3: Frontend Integration (`pos-frontend`)

### TASK-008: Implement `useAppUpdate` Hook
**Files:**
- `src/hooks/useAppUpdate.ts`
- `src/hooks/useAppUpdate.test.ts`
**Priority:** P0
**Estimate:** 2h
**Depends on:** TASK-007

**Subtasks:**
- [x] Check if platform is native Android via `Capacitor.isNativePlatform()`.
- [x] Fetch `/api/system/app-version` and compare with native `versionCode`.
- [x] Implement download via `fetch` / `ReadableStream` with progress callback.
- [x] Write bytes to internal cache and trigger `ApkUpdater.installApk`.
- [x] Handle permission redirect when `canRequestPackageInstalls` is false.
- [x] Write unit tests with Vitest mocking Capacitor and API responses.

---

### TASK-009: Implement UI in SettingsHub & Update Modal
**Files:**
- `src/components/updates/AppUpdateModal.tsx`
- `src/pages/SettingsHub.tsx`
- `src/pages/SettingsHub.test.tsx`
**Priority:** P0
**Estimate:** 2h
**Depends on:** TASK-008

**Subtasks:**
- [x] Create `AppUpdateModal.tsx` with release notes display, progress bar, and install button.
- [x] Add "Actualización del Sistema" section card to `SettingsHub.tsx` showing current app version.
- [x] Add "Buscar actualización" trigger button.
- [x] Provide clear fallback message for Web / Desktop browser testing.

---

## Phase 4: Verification & Git Flow

### TASK-010: Integration Testing & Quality Gates
**Priority:** P0
**Estimate:** 1h
**Depends on:** All previous tasks

**Subtasks:**
- [x] Run backend tests and checkstyle: `./gradlew check`.
- [x] Run frontend linter and unit tests: `npm run lint` && `npm test`.
- [x] Run `npx cap sync android` to ensure plugin and assets compile cleanly.
