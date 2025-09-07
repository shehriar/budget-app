import { useState } from "react"
import { api } from "../api/client"

export default function BudgetNavigator() {
    const [result, setResult] = useState<string>("")
    const [error, setError] = useState<string>("")
    const [loading, setLoading] = useState<boolean>(false)

    const callBudget = async () => {
        setLoading(true); setError(""); setResult("")
        try {
            const data = await api.get("/budget/budgetform")
            setResult(typeof data === "string" ? data : JSON.stringify(data, null, 2))
        } catch (e: unknown) {
            const msg = e instanceof Error ? e.message : String(e)
            setError(msg || "Request failed")
        } finally {
            setLoading(false)
        }
    }

    return (
        <div>
            <button onClick={callBudget}>
                Budget
            </button>
            {error && <pre className="error">{error}</pre>}
            {result && <pre className="box">{result}</pre>}
        </div>
    )
}