import { useState } from "react"
import { api } from "../api/client"
import NewSpendNavigator from "../components/new-spend-navigator";

export default function Dashboard() {
    return (
        <div>
            <p>This is the dashboard</p>
            <NewSpendNavigator></NewSpendNavigator>
        </div>
    )
}