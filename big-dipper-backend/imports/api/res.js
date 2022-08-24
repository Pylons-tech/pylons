import {
    Codec
} from './codec.js'



function Success(data) {
    return {
        Code: Codec.StatusOk,
        Message: Codec.SuccessMessage,
        Data: data
    }
}


function InValidInput(message, data) {
    return {
        Code: Codec.StatusInvalidInput,
        Message: message,
        Data: data
    }
}

function Failed(message, data) {
    return {
        Code: Codec.StatusInvalidInput,
        Message: message,
        Data: data
    }
}

export const Res = {
    Success,
    InValidInput,
    Failed
}