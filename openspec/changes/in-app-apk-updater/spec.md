# Specification: In-App APK Updater for Private POS Deployment

## Change ID
`in-app-apk-updater`

---

## Functional Requirements

### FR-01: Backend App Version Endpoint
**FR-01.1** The backend SHALL expose `GET /api/system/app-version` as a public (unauthenticated) endpoint in `SecurityConfig`.
**FR-01.2** The response SHALL be JSON conforming to:
```json
{
  "latestVersionName": "2.14.0",
  "latestVersionCode": 21400,
  "downloadUrl": "/api/system/app-download",
  "releaseNotes": "Summary of release notes",
  "mandatory": false,
  "publishedAt": "2026-10-25T13:49:08Z",
  "fileSizeBytes": 3905223,
  "checksumSha256": null
}
```
**FR-01.3** The backend SHALL query GitHub Releases API (`https://api.github.com/repos/JohnRios07/pos-frontend/releases/latest`) using the configured `GITHUB_RELEASE_TOKEN`.
**FR-01.4** The backend SHALL cache the GitHub Release response for at least 300 seconds (5 minutes) to prevent rate limit exhaustion.
**FR-01.5** If GitHub API returns 404, 500, or times out, the backend SHALL return HTTP 503 with a structured error payload: `{ "error": "UPDATE_CHECK_FAILED", "message": "No fue posible verificar actualizaciones en este momento." }`.

---

### FR-02: Backend APK Download Proxy
**FR-02.1** The backend SHALL expose `GET /api/system/app-download` as an endpoint supporting byte streaming of the APK asset.
**FR-02.2** The backend SHALL set response headers:
- `Content-Type: application/vnd.android.package-archive`
- `Content-Disposition: attachment; filename="rvpos-update.apk"`
- `Content-Length: <size>`
**FR-02.3** The backend SHALL stream the raw bytes from the GitHub Release asset URL using the `GITHUB_RELEASE_TOKEN` authorization header with `Accept: application/octet-stream`.

---

### FR-03: Android Native Plugin (`ApkUpdaterPlugin`)
**FR-03.1** The native plugin SHALL register with name `ApkUpdater` in Capacitor.
**FR-03.2** `getAppInfo()` SHALL return `{ versionCode: number, versionName: string, packageName: string }` read from `android.content.pm.PackageInfo`.
**FR-03.3** `canRequestPackageInstalls()` SHALL return `{ canInstall: boolean }` querying `context.getPackageManager().canRequestPackageInstalls()`.
**FR-03.4** `openInstallPermissionSettings()` SHALL launch an `Intent` with action `Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES` targeting `package:<packageName>`.
**FR-03.5** `installApk({ filePath: string })` SHALL:
1. Verify the file exists at `filePath`.
2. Generate a secure `content://` URI using `androidx.core.content.FileProvider`.
3. Dispatch an `Intent` with action `ACTION_VIEW`, type `application/vnd.android.package-archive`, and flag `FLAG_GRANT_READ_URI_PERMISSION`.
4. Resolve the call once the system installer intent has started successfully.
5. Reject with `{ code: "INSTALL_FAILED", message: string }` if the intent cannot be resolved or file is missing.

---

### FR-04: Frontend State & Hook (`useAppUpdate`)
**FR-04.1** The hook SHALL detect whether the current environment is Android native via `Capacitor.isNativePlatform() && Capacitor.getPlatform() === 'android'`.
**FR-04.2** `checkForUpdates()` SHALL:
1. Obtain current native `versionCode` via `ApkUpdater.getAppInfo()`.
2. Fetch `/api/system/app-version`.
3. Compare `latestVersionCode > currentVersionCode`.
4. Set state to `AVAILABLE` with release metadata if newer, or `UP_TO_DATE` if equal or lower.
**FR-04.3** `downloadAndInstall()` SHALL:
1. Download the APK file via `XMLHttpRequest` or `fetch` with `ReadableStream` to monitor progress.
2. Store the downloaded blob in the Android app cache directory via Capacitor Filesystem or native bridge.
3. Verify if `canRequestPackageInstalls()` is true:
   - If false: prompt the user and call `openInstallPermissionSettings()`.
   - If true: call `installApk({ filePath })`.
**FR-04.4** If download fails due to network loss, the hook SHALL transition to `ERROR` state with a retry option and delete any partial/corrupt temporary file.

---

### FR-05: SettingsHub UI & Update Modal
**FR-05.1** In `SettingsHub.tsx`, a new card or section SHALL display:
- Title: "Actualización de la App"
- Subtitle: Current version (`v2.14.0 (build 21400)`)
- Status badge: "Al día" (green) or "Actualización disponible" (amber).
- Action button: "Buscar actualización".
**FR-05.2** When an update is available, clicking "Actualizar" SHALL open a modal showing:
- Target version tag and publication date.
- Release notes / changelog.
- Progress bar displaying percentage and downloaded MB / total MB during download.
- "Instalar ahora" button enabled when download completes.
**FR-05.3** On web/desktop platforms, the card SHALL indicate: "Las actualizaciones automáticas de APK están disponibles únicamente en dispositivos Android POS".

---

## Scenarios & Use Cases

### Scenario 1: Device is already running the latest version
- **Given** the app has `versionCode: 21400`
- **When** the cashier clicks "Buscar actualización"
- **Then** the app queries `/api/system/app-version` returning `latestVersionCode: 21400`
- **And** a toast notification displays: "La aplicación está actualizada (v2.14.0)".

### Scenario 2: New version is available and installed
- **Given** the app has `versionCode: 20900`
- **And** the server reports `latestVersionCode: 21400` with asset `rvpos-update.apk`
- **When** the cashier clicks "Buscar actualización"
- **Then** the modal opens with release notes and button "Descargar e Instalar"
- **When** the cashier clicks "Descargar e Instalar"
- **Then** the download progress bar moves from 0% to 100%
- **And** the native Android package installer dialog opens: "¿Desea instalar una actualización de esta aplicación?"
- **When** the cashier taps "Instalar"
- **Then** Android updates the application.

### Scenario 3: Unknown sources permission not yet granted
- **Given** the device has just finished downloading `rvpos-update.apk`
- **And** `canRequestPackageInstalls()` returns `false`
- **When** installation is triggered
- **Then** the app displays an alert: "Para instalar la actualización, active el permiso 'Permitir desde esta fuente' en la configuración de Android."
- **And** tapping "Ir a Configuración" opens Android's `ACTION_MANAGE_UNKNOWN_APP_SOURCES` screen for the app package.
