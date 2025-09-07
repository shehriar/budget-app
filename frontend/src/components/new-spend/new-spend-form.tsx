import { useState } from "react"
import { api } from "../../api/client"
import { useNavigate } from 'react-router-dom';

export default function NewSpendForm() {
    const [formOne, setFormOne] = useState(""); // todo change this

    const formChange = (event : any) => {
        event.preventDefault()
        setFormOne(event.target.value)
    }

    const submitForm = ()=> {
        const payload = { form : formOne }
        api.post("/new-spend/submit-form", payload) // todo change this
    }

    return (
        <div>
            <form>
                <input id={"textType1"} type={"text"} onChange={formChange}/>
            </form>
            <button onClick={submitForm}>
                New spend form button
            </button>
        </div>
    )
}