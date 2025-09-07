# setup-frontend-ts.ps1
# Scaffolds a React + Vite + TypeScript app in the CURRENT folder.

param(
  [string]$Root = "."
)

$ErrorActionPreference = "Stop"

function Write-NoBom {
  param([string]$Path,[string]$Content)
  $enc = New-Object System.Text.UTF8Encoding($false)
  [IO.File]::WriteAllText($Path, $Content, $enc)
}

Write-Host "==> Creating folders..."
$dirs = @(
  "$Root",
  "$Root/src",
  "$Root/src/components",
  "$Root/src/api",
  "$Root/src/styles"
)
foreach ($d in $dirs) { New-Item -ItemType Directory -Force -Path $d | Out-Null }

Write-Host "==> package.json"
$pkg = @'
{
  "name": "frontend",
  "private": true,
  "version": "0.0.1",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview --port 4173"
  },
  "dependencies": {
    "react": "^18.3.1",
    "react-dom": "^18.3.1"
  },
  "devDependencies": {
    "@types/react": "^18.3.3",
    "@types/react-dom": "^18.3.0",
    "@vitejs/plugin-react": "^4.3.1",
    "typescript": "^5.4.0",
    "vite": "^5.4.0"
  }
}
'@
Write-NoBom -Path "$Root/package.json" -Content $pkg

Write-Host "==> tsconfig.json"
$tsc = @'
{
  "compilerOptions": {
    "target": "ESNext",
    "useDefineForClassFields": true,
    "lib": ["DOM", "DOM.Iterable", "ESNext"],
    "allowJs": false,
    "skipLibCheck": true,
    "esModuleInterop": false,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "module": "ESNext",
    "moduleResolution": "Node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx"
  },
  "include": ["src"]
}
'@
Write-NoBom -Path "$Root/tsconfig.json" -Content $tsc

Write-Host "==> env files"
Write-NoBom -Path "$Root/.env.development" -Content "VITE_API_BASE=/api`n"
Write-NoBom -Path "$Root/.env.production"  -Content "# Set to your API in prod, e.g. https://api.example.com`nVITE_API_BASE=/api`n"

Write-Host "==> vite.config.ts"
$vite = @'
import { defineConfig } from "vite"
import react from "@vitejs/plugin-react"

export default defineConfig({
  plugins: [react()],
  server: {
    port: 5173,
    proxy: { "/api": "http://localhost:8080" }
  }
})
'@
Write-NoBom -Path "$Root/vite.config.ts" -Content $vite

Write-Host "==> index.html"
$html = @'
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>TSX Starter App</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
'@
Write-NoBom -Path "$Root/index.html" -Content $html

Write-Host "==> src/main.tsx"
$main = @'
import { createRoot } from "react-dom/client"
import App from "./App"
import "./styles/global.css"

createRoot(document.getElementById("root")!).render(<App />)
'@
Write-NoBom -Path "$Root/src/main.tsx" -Content $main

Write-Host "==> src/App.tsx"
$app = @'
import { useState } from "react"
import { api } from "./api/client"

export default function App() {
  const [result, setResult] = useState<string>("")
  const [error, setError] = useState<string>("")
  const [loading, setLoading] = useState<boolean>(false)

  const callApi = async () => {
    setLoading(true); setError(""); setResult("")
    try {
      // Change "/health" to any endpoint your backend exposes
      const data = await api.get("/health")
      setResult(typeof data === "string" ? data : JSON.stringify(data, null, 2))
    } catch (e: unknown) {
      const msg = e instanceof Error ? e.message : String(e)
      setError(msg || "Request failed")
    } finally {
      setLoading(false)
    }
  }

  return (
    <main className="container">
      <h1>TSX Starter Frontend</h1>
      <p className="muted">
        Edit <code>src/App.tsx</code> and <code>src/api/client.ts</code> to suit your app.
      </p>
      <div className="row">
        <button onClick={callApi} disabled={loading}>
          {loading ? "Calling…" : "Test API (/api/health)"}
        </button>
      </div>
      {error && <pre className="error">{error}</pre>}
      {result && <pre className="box">{result}</pre>}
    </main>
  )
}
'@
Write-NoBom -Path "$Root/src/App.tsx" -Content $app

Write-Host "==> src/api/client.ts"
$client = @'
const API_BASE = import.meta.env.VITE_API_BASE || "/api"

async function request<T = unknown>(path: string, options: RequestInit = {}): Promise<T> {
  const res = await fetch(`${API_BASE}${path}`, {
    headers: { "Content-Type": "application/json", ...(options.headers || {}) },
    ...options
  })
  const ct = res.headers.get("content-type") || ""
  const payload = ct.includes("application/json") ? await res.json() : await res.text()
  if (!res.ok) {
    const msg = typeof payload === "string" ? payload : JSON.stringify(payload)
    throw new Error(`${res.status} ${res.statusText}: ${msg}`)
  }
  return payload as T
}

export const api = {
  get:  <T = unknown>(path: string)              => request<T>(path),
  post: <T = unknown>(path: string, body: any)   => request<T>(path, { method: "POST", body: JSON.stringify(body) }),
  put:  <T = unknown>(path: string, body: any)   => request<T>(path, { method: "PUT", body: JSON.stringify(body) }),
  del:  <T = unknown>(path: string)              => request<T>(path, { method: "DELETE" })
}
'@
Write-NoBom -Path "$Root/src/api/client.ts" -Content $client

Write-Host "==> src/styles/global.css"
$css = @'
:root { font-family: system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial, sans-serif; }
* { box-sizing: border-box; }
body { margin: 0; background: #f7f7f8; }
.container { max-width: 720px; margin: 48px auto; padding: 0 16px; }
h1 { margin: 0 0 16px; }
.row { display: flex; gap: 8px; margin: 16px 0; }
button { padding: 10px 14px; border: 0; border-radius: 8px; cursor: pointer; background: #222; color: #fff; }
button:disabled { opacity: 0.7; cursor: default; }
.error { color: #b00020; white-space: pre-wrap; }
.box { background: #fff; border: 1px solid #eee; padding: 12px; border-radius: 8px; white-space: pre-wrap; }
.muted { color: #666; }
'@
Write-NoBom -Path "$Root/src/styles/global.css" -Content $css

Write-Host ""
Write-Host "✅ TSX frontend scaffolded in $((Resolve-Path $Root).Path)"
Write-Host "Next steps:"
Write-Host "  npm install"
Write-Host "  npm run dev    # http://localhost:5173  (proxies /api -> http://localhost:8080)"
