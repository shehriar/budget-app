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