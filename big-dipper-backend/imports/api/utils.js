import {
    isString
} from 'lodash'


function ValidateAddress(parameter) {
    if (!isString(parameter)) {
        return false
    }
    if (parameter.length === 0) {
        return false
    }
    return true
}

function ValidateToken(parameter) {
    if (!isString(parameter)) {
        return false
    }
    if (parameter.length === 0) {
        return false
    }
    return true
}

export const Utils = {
    ValidateAddress,
    ValidateToken
}