package types

import (
	"crypto/x509"
	"encoding/asn1"
	"encoding/base64"
	"io"
	"net/http"
	"strings"

	"github.com/ddulesov/pkcs7"
)

func ValidateApplePay(msg *MsgAppleIap) (*AppleInAppPurchaseOrder, error) {
	receiptData, err := verifyCertificate(msg.Data)
	if err != nil {
		return nil, err
	}
	var info asn1.RawValue
	rest, err := extractMainReceipt(receiptData)
	if err != nil {
		return nil, err
	}
	rest, err = skipIndices(rest)
	if err != nil {
		return nil, err
	}
	rest, err = asn1.Unmarshal(rest, &info)
	if err != nil {
		return nil, err
	}
	transactionID, err := getValue(info.Bytes)
	if err != nil {
		return nil, err
	}
	// ignoring redundant transactionId
	rest, err = asn1.Unmarshal(rest, &info)
	if err != nil {
		return nil, err
	}
	// object for tx date
	rest, err = asn1.Unmarshal(rest, &info)
	if err != nil {
		return nil, err
	}
	txDate, err := getValue(info.Bytes)
	if err != nil {
		return nil, err
	}
	// ignoring redundant date
	_, err = asn1.Unmarshal(rest, &info)
	if err != nil {
		return nil, err
	}
	// object for product id
	productID, err := getValue(info.Bytes)
	if err != nil {
		return nil, err
	}
	return &AppleInAppPurchaseOrder{
		TransactionID: transactionID,
		PurchaseDate:  txDate,
		ProductID:     productID,
	}, nil
}

func getValue(val []byte) (string, error) {
	var info asn1.RawValue
	rest, err := asn1.Unmarshal(val, &info)
	if err != nil {
		return "", err
	}
	rest, err = asn1.Unmarshal(rest, &info)
	if err != nil {
		return "", err
	}
	_, err = asn1.Unmarshal(rest, &info)
	if err != nil {
		return "", err
	}
	test := strings.Split(string(info.Bytes), "")
	joined := strings.Join(test[SkipIndexString:], "")
	return joined, nil
}

func getObject(n int, r []byte, info *asn1.RawValue) (rest []byte, err error) {
	for i := 0; i < n; i++ {
		rest, err = asn1.Unmarshal(r, info)
		r = rest
		if err != nil {
			return nil, err
		}
	}
	return rest, nil
}

func verifyCertificate(data string) ([]byte, error) {
	decodedReceipt, err := base64.StdEncoding.DecodeString(data)
	if err != nil {
		return nil, err
	}
	pkcsContainer, err := pkcs7.ParseCMS(decodedReceipt)
	if err != nil {
		return nil, err
	}

	certificates := pkcsContainer.Certificates
	receiptData := pkcsContainer.Content

	itunesCert, err := x509.ParseCertificate(certificates[0].Raw)
	if err != nil {
		return nil, err
	}

	wwdrCert, err := x509.ParseCertificate(certificates[1].Raw)
	if err != nil {
		return nil, err
	}

	response, err := http.Get(URL)
	if err != nil {
		return nil, err
	}
	defer response.Body.Close()
	cf, err := io.ReadAll(response.Body)
	if err != nil {
		return nil, err
	}

	trustedRoot, err := x509.ParseCertificate(cf)
	if err != nil {
		return nil, err
	}

	err = trustedRoot.CheckSignature(x509.SHA1WithRSA, wwdrCert.RawTBSCertificate, wwdrCert.Signature)
	if err != nil {
		return nil, err
	}
	err = wwdrCert.CheckSignature(x509.SHA1WithRSA, itunesCert.RawTBSCertificate, itunesCert.Signature)
	if err != nil {
		return nil, err
	}
	return receiptData, nil
}

func extractMainReceipt(receiptData []byte) ([]byte, error) {
	var d asn1.RawValue
	_, err := asn1.Unmarshal(receiptData, &d)
	if err != nil {
		return nil, err
	}
	var info asn1.RawValue
	rest, err := getObject(SkipObjectParse21, d.Bytes, &info)
	if err != nil {
		return nil, err
	}
	// Main Recite Date Starts here
	_, err = asn1.Unmarshal(rest, &info)
	if err != nil {
		return nil, err
	}
	return info.Bytes, nil
}

func skipIndices(rest []byte) ([]byte, error) {
	var info asn1.RawValue
	_, err := getObject(SkipObjectParse3, rest, &info)
	if err != nil {
		return nil, err
	}
	_, err = asn1.Unmarshal(info.Bytes, &info)
	if err != nil {
		return nil, err
	}
	rest, err = getObject(SkipObjectParse15, info.Bytes, &info)
	if err != nil {
		return nil, err
	}
	return rest, nil
}
