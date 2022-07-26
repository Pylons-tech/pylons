package types

import (
	"bytes"
	"crypto/rsa"
	"encoding/base64"
	"encoding/json"
	"errors"
	fmt "fmt"
	"io/ioutil"
	"math/big"
	"net/http"
	"strings"

	"github.com/golang-jwt/jwt/v4"
)

type JSONWebKeys struct {
	Key map[string]interface{}
}

type JWKRES struct {
	Key []*JWK `json:"keys"`
}

// ErrKID indicates that the JWT had an invalid kid.
var ErrKID = errors.New("the JWT has an invalid kid")

// Keyfunc matches the signature of github.com/golang-jwt/jwt/v4's jwt.Keyfunc function.
func (jwk JSONWebKeys) Keyfunc(token *jwt.Token) (interface{}, error) {
	kidInter, ok := token.Header["kid"]
	if !ok {
		return nil, fmt.Errorf("%w: could not find kid in JWT header", ErrKID)
	}
	kid, ok := kidInter.(string)
	if !ok {
		return nil, fmt.Errorf("%w: could not convert kid in JWT header to string", ErrKID)
	}

	return jwk.Key[kid], nil
}

func VerifyAppCheckToken(token string) error {
	keys, err := requestJWK()
	if err != nil {
		return err
	}
	// Verify the signature on the App Check token
	// Ensure the token is not expired
	payload, err := jwt.Parse(token, keys.Keyfunc)
	if err != nil {
		return errors.New("failed to parse token. " + err.Error())
	}

	if !payload.Valid {
		return errors.New("invalid token")
	}
	if payload.Header["alg"] != "RS256" {
		// Ensure the token's header uses the algorithm RS256
		return errors.New("invalid algorithm")
	}
	if payload.Header["typ"] != "JWT" {
		// Ensure the token's header has type JWT
		return errors.New("invalid type")
	}
	if !verifyAudClaim(payload.Claims.(jwt.MapClaims)["aud"].([]interface{})) {
		// Ensure the token's audience matches your project
		return errors.New("invalid audience")
	}
	if !strings.Contains(payload.Claims.(jwt.MapClaims)["iss"].(string),
		(firebaseURL + projectID)) {
		// Ensure the token is issued by App Check
		return errors.New("invalid issuer")
	}
	return nil
}

func verifyAudClaim(auds []interface{}) bool {
	for _, aud := range auds {
		if aud == "projects/"+projectID {
			return true
		}
	}
	return false
}

/*
* function to request JWK from firebase upon new App-Check Verification Request
* Returns @JSONWebKeys -> Map of JWK with KID as Key, Public Key as a value
* Returns @Error in case of any error
 */
func requestJWK() (*JSONWebKeys, error) {
	keys := JWKRES{}
	req, err := http.NewRequest(http.MethodGet, jwkURL, bytes.NewReader(nil))
	if err != nil {
		return nil, err
	}

	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return nil, err
	}

	defer resp.Body.Close()

	jwkBytes, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}
	if len(jwkBytes) == 0 {
		return nil, err
	}

	err = json.Unmarshal(jwkBytes, &keys)
	if err != nil {
		return nil, err
	}
	keysMap := make(map[string]interface{}, len(keys.Key))
	// iterate over the json web keys and extract the public key
	for _, key := range keys.Key {
		var keyInter interface{}
		if key.Kty == ktyRSA {
			keyInter, err = getRSAKey(key)
			if err != nil {
				continue
			}

		}
		// add public keys to map
		keysMap[key.Kid] = keyInter
	}
	// return the keysMap will be used for decoding
	return &JSONWebKeys{
		Key: keysMap,
	}, nil
}

/*
* Helper function to extract RSA key from JWK
 */

func getRSAKey(key *JWK) (publicKey *rsa.PublicKey, err error) {
	if key.E == "" || key.N == "" {
		return nil, fmt.Errorf("%w: %s", errors.New("required assets are missing to create a public key"), ktyRSA)
	}
	exponent, err := base64urlTrailingPadding(key.E)
	if err != nil {
		return nil, err
	}
	modulus, err := base64urlTrailingPadding(key.N)
	if err != nil {
		return nil, err
	}
	publicKey = &rsa.PublicKey{}

	/*
	* Turn the exponent into an integer.
	* According to RFC 7517, these numbers are in big-endian format.
	*  https://tools.ietf.org/html/rfc7517#appendix-A.1
	 */
	publicKey.E = int(big.NewInt(0).SetBytes(exponent).Uint64())
	publicKey.N = big.NewInt(0).SetBytes(modulus)

	return publicKey, nil
}

/*
* base64urlTrailingPadding removes trailing padding before decoding a string from base64url. Some non-RFC compliant
* JWK contain padding at the end values for base64url encoded public keys.
* Trailing padding is required to be removed from base64url encoded keys.
* RFC 7517 defines base64url the same as RFC 7515 Section 2:
* https://datatracker.ietf.org/doc/html/rfc7517#section-1.1
* https://datatracker.ietf.org/doc/html/rfc7515#section-2
 */

func base64urlTrailingPadding(s string) ([]byte, error) {
	s = strings.TrimRight(s, "=")
	return base64.RawURLEncoding.DecodeString(s)
}
