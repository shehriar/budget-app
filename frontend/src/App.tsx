import { useState } from "react"
import { api } from "./api/client"
import { Routes, Route } from 'react-router-dom';
import Dashboard from "./pages/dashboard/dashboard";
import NewSpend from "./pages/new-spend/new-spend";

export default function App() {
  return (
    <main className="container">
        <Routes>
            <Route path="/" element={<Dashboard/>} />
            <Route path="/new-spend/new-spend-form" element={<NewSpend/>} />
        </Routes>
    </main>
  )
}