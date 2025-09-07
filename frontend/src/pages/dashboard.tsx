import { useState } from "react"
import { api } from "../api/client"
import BudgetNavigator from "../components/budget-navigator";

export default function Dashboard() {
    return (
        <div>
            <p>This is the dashboard</p>
            <BudgetNavigator></BudgetNavigator>
        </div>
    )
}