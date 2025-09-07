import { useState } from "react"
import { api } from "../../api/client"
import NewSpend from "../../pages/new-spend/new-spend";
import { useNavigate } from 'react-router-dom';

export default function LoginValidation() {
    const navigate = useNavigate();
    const navigateToDashboard = async () => {
        navigate('/')
    }

    return (
        <div>
            <p>Please Log In</p>
            <button onClick={navigateToDashboard}>
                Return To Dashboard
            </button>
        </div>
    )
}