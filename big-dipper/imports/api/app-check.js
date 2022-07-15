

import {admin} from "./admin"


export async function appCheckVerification(appCheckToken){
    
    try {
        const appCheckClaims = await firebaseAdmin.appCheck().verifyToken(appCheckToken);
        return 1
    } catch (err) {
        console.log("App Check Failed : ",err)
        return 0
    }
}
