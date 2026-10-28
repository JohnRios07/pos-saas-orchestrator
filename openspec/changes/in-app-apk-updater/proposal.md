# Proposal: In-App APK Updater for Private POS Deployment

## Change ID
`in-app-apk-updater`

## Intent
Enable private POS Android terminals to detect, download, and trigger installation of newer application releases directly from the UI without manual USB debugging or external MDM tools. Because the application is distributed privately (sideloaded on dedicated merchant tablets/terminals) and hosted in a private GitHub repository, the update flow must be secure, resilient to network drops, and strictly respect Android's security boundaries.

## Scope

### In Scope
1. **Backend (`pos-backend` - Spring Boot):**
   - New bounded context / package: `com.company.pos.distribution`.
   - Controller & Service exposing public endpoints for app version check and authenticated/secure APK download proxy:
     - `GET /api/system/app-version`: Queries and caches latest release metadata from GitHub Releases API without exposing GitHub Personal Access Tokens (PAT) to the mobile client.
     - `GET /api/system/app-download`: Streams or securely redirects to the latest signed `.apk` asset.
   - Configuration for GitHub token (`GITHUB_RELEASE_TOKEN`) and caching policy (e.g., 5-minute TTL to respect GitHub rate limits).
   - SecurityConfig updates to allow unauthenticated access to system update checks.

2. **Android Native (`pos-frontend/android` - Capacitor 8):**
   - `AndroidManifest.xml`: Add permission `android.permission.REQUEST_INSTALL_PACKAGES`.
   - `file_paths.xml`: Verify/add cache path mapping for downloaded APKs.
   - Built-in Native Capacitor Plugin `ApkUpdaterPlugin.java`:
     - `getAppVersion()`: Returns current native `versionCode` and `versionName`.
     - `canRequestPackageInstalls()`: Checks Android OS permission for unknown sources (`packageManager.canRequestPackageInstalls()`).
     - `openInstallPermissionSettings()`: Dispatches OS intent to enable unknown sources for this app package.
     - `installApk(path)`: Converts local file path to `FileProvider` URI and fires `ACTION_VIEW` intent with `application/vnd.android.package-archive` and `FLAG_GRANT_READ_URI_PERMISSION`.

3. **Frontend UI & State (`pos-frontend` - React 19 + Vite):**
   - New hook: `src/hooks/useAppUpdate.ts` orchestrating check, download progress, checksum verification, and install trigger.
   - UI Card in `SettingsHub.tsx`: "Actualización del Sistema" showing current version, latest version badge, and "Buscar actualizaciones" button.
   - Update Dialog/Modal: Displays release notes, APK download progress bar (percentage & MBs), and "Instalar" action button.

### Out of Scope
- Google Play In-App Updates API (Distribution is 100% private/sideloaded).
- Silent background installation via Root or Device Owner MDM (Android OS standard PackageInstaller prompt is preserved).
- Database migrations (No persistent database entities required; GitHub API + memory cache is sufficient).

---

## Problem Statement

### Current State Analysis
- Releases are automatically compiled, signed, and uploaded to GitHub Releases via `.github/workflows/build-android-release.yml`.
- To update physical POS terminals, merchants or technicians currently must manually download the APK via browser or ADB, requiring manual token entry or manual file transfer.
- The GitHub repository `JohnRios07/pos-frontend` is **private**, meaning client devices cannot directly fetch `api.github.com/repos/...` without leaking a GitHub PAT.
- `pos-frontend/android/app/build.gradle` defines `versionCode 20900` and `versionName "2.9.0"`, while `package.json` is at `2.14.0`, requiring alignment between frontend build and native version reporting.

### Core Architectural Decision
- **Zero-Secret Client:** The mobile app holds NO GitHub credentials. All GitHub communication is brokered by `pos-backend`.
- **Zero-Dependency Native Bridge:** Instead of relying on unmaintained third-party Capacitor plugins that break across Android/Capacitor major versions, implement a lean, native `ApkUpdaterPlugin` directly in the Android project.
- **Strict Integrity Verification:** Client computes SHA-256 (or backend provides checksum) before invoking Android's PackageInstaller.

---

## Proposed Solution

### 1. Backend Distribution Layer (`pos-backend`)
- Exposes:
  - `GET /api/system/app-version` -> `{ latestVersionName, latestVersionCode, downloadUrl, releaseNotes, mandatory, publishedAt, checksumSha256 }`
  - `GET /api/system/app-download` -> Binary stream (`application/vnd.android.package-archive`) from GitHub Releases asset.
- Uses Spring `RestClient` or `WebClient` with server-side `GITHUB_RELEASE_TOKEN`.
- Caches the release metadata in memory (Caffeine or ConcurrentHashMap with 5-minute expiration) to avoid exhausting GitHub API rate limits (60/hr unauthenticated, 5000/hr authenticated).

### 2. Android Native Bridge (`pos-frontend/android`)
- Custom plugin `ApkUpdaterPlugin` registered in `MainActivity.java`:
  ```java
  @CapacitorPlugin(name = "ApkUpdater")
  public class ApkUpdaterPlugin extends Plugin { ... }
  ```
- Uses `androidx.core.content.FileProvider` to generate secure `content://app.rvpos.pos.fileprovider/cache/update.apk` URIs.
- Dispatches Android Intent:
  ```java
  Intent intent = new Intent(Intent.ACTION_VIEW);
  intent.setDataAndType(apkUri, "application/vnd.android.package-archive");
  intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION | Intent.FLAG_ACTIVITY_NEW_TASK);
  getContext().startActivity(intent);
  ```

### 3. Frontend Experience (`pos-frontend`)
- `useAppUpdate()` hook managing states: `IDLE | CHECKING | UPDATE_AVAILABLE | DOWNLOADING | READY_TO_INSTALL | ERROR`.
- Progress tracking via `XMLHttpRequest` / `fetch` with `ReadableStream` to display real-time MB and percentage.
- Graceful error messaging if network drops during download.

---

## Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| GitHub API rate limiting | Medium | High | Backend caches release metadata for 5 minutes; proxies binary stream directly. |
| User denies "Install Unknown Apps" permission | High | Medium | App detects permission via `canRequestPackageInstalls()` and shows guided prompt redirecting to Android Settings. |
| Corrupt APK download due to unstable POS Wi-Fi | Medium | High | Verify Content-Length and SHA-256 checksum before triggering package installer; delete corrupt file. |
| Keystore signature mismatch | Low | Critical | CI/CD signs all production APKs with the same secret `ANDROID_KEYSTORE_BASE64`. Document strictly in release checklist. |
| Version code lower than installed | Low | High | Android will reject downgrade. Ensure CI/CD or build process increments `versionCode` strictly. |

---

## Acceptance Criteria
1. Terminal can query `/api/system/app-version` without authentication token.
2. If remote `versionCode > localVersionCode`, SettingsHub displays "Actualización disponible: vX.X.X".
3. Clicking "Actualizar" downloads the APK showing an accurate progress bar (0% - 100%).
4. On download completion, if `REQUEST_INSTALL_PACKAGES` is missing, user is guided to Android settings. Once granted, native installer dialog appears.
5. On non-Android platforms (e.g. Chrome/Web dev mode), the update button informs the user that updates are managed in mobile APK mode only.
6. No sensitive GitHub tokens exist in the mobile bundle or network traffic from the client.

---

## Rollback Plan
- Changes are isolated to a new controller/service in `pos-backend` and a new plugin + settings card in `pos-frontend`.
- Reverting the commits will have zero impact on sales, cash drawer, or catalog functionalities.
