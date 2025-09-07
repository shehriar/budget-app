import { useState, useEffect } from "react"
import { api } from "../../api/client"
import LoginValidation from "../../components/common/login-validation";

export default function NewSpendForm() {
    const [result, setResult] = useState("")
    const [permission, setPermissions] = useState(false)
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

    useEffect(() => {
        const validatePermissions = async()=> {
            const data = await api.get("/new-spend/validate-permission")
            setPermissions(typeof data === 'boolean' ? data : false)
        }

        validatePermissions()
    }, []);

    return (
        <main>
            { !permission ? (
                <LoginValidation></LoginValidation>
            ) : (
                <div>
                    <p>This is the new spend dashboard</p>
                    <button onClick={submitForm}>Submit</button>
                    {result}
                </div>
            )
            }
        </main>
    )
}