import { useState } from "react"
import { api } from "./api/client"
import Dashboard from "./pages/dashboard";

export default function App() {
  return (
    <main className="container">
        <Dashboard></Dashboard>
    </main>
  )
}