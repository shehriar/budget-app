import { useState, useEffect } from "react"
import { api } from "../../api/client"
import LoginValidation from "../../components/common/login-validation";
import NewSpendForm from "../../components/new-spend/new-spend-form";
import Loading from "../../components/common/loading";

export default function NewSpend() {
    const [result, setResult] = useState("")
    const [permission, setPermissions] = useState(false)
    const [loading, setLoading] = useState(true)

    useEffect(() => {
        const validatePermissions = async() : Promise<void> => {
            const data = await api.get("/new-spend/validate-permission")
            setPermissions(typeof data === 'boolean' ? data : false);
            setLoading(false);
        }
        validatePermissions()
    }, [])

    if (loading) {
        return (
            <Loading></Loading>
        )
    }
    if (permission) {
        return(
            <NewSpendForm></NewSpendForm>
        )
    } else {
        return (
            <LoginValidation></LoginValidation>
        )
    }
}