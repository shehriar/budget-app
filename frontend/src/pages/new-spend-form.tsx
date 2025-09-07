import { useState } from "react"
import { api } from "../api/client"

export default function NewSpendForm() {
    const [result, setResult] = useState("")
    const [error, setError] = useState("")
    const [loading, setLoading] = useState(false)

    const submitForm = async()=> {
        try {
            const data = await api.get("/new-spend/submit-form")
            setResult(typeof data === "string" ? data : JSON.stringify(data, null, 2))
        } finally {
            setLoading(false)
        }
    }

    return (
        <main>
            <div>
                <p>This is the new spend dashboard</p>
                <button onClick={submitForm}>Submit</button>
            </div>
            {result && <pre className="box">{result}</pre>}
        </main>
    )
}