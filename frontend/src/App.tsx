import { useState } from "react"
import { api } from "./api/client"
import { Routes, Route } from 'react-router-dom';
import Dashboard from "./pages/dashboard";
import NewSpendForm from "./pages/new-spend-form";

export default function App() {
  return (
    <main className="container">
        <Routes>
            <Route path="/" element={<Dashboard/>} />
            <Route path="/new-spend/new-spend-form" element={<NewSpendForm/>} />
        </Routes>
    </main>
  )
}