import { useState } from "react"
import { api } from "../../api/client"
import NewSpend from "../../pages/new-spend/new-spend";
import { useNavigate } from 'react-router-dom';

export default function Loading() {

    return (
        <div>
            <p>Loading...</p>
        </div>
    )
}