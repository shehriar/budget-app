import { useState } from "react"
import { api } from "../api/client"
import NewSpendForm from "../pages/new-spend-form";
import { useNavigate } from 'react-router-dom';

export default function NewSpendNavigator() {
    const [result, setResult] = useState<string>("")
    const [error, setError] = useState<string>("")
    const [loading, setLoading] = useState<boolean>(false)
    const navigate = useNavigate();

    const navigateToForm = async () => {
        navigate('/new-spend/new-spend-form')
    }

    return (
        <div>
            <button onClick={navigateToForm}>
                Navigate to Form
            </button>
            {result && <pre className="box">{result}</pre>}
        </div>
    )
}