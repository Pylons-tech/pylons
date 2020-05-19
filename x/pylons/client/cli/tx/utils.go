package tx

import (
	"io/ioutil"
	"os"
)

func ReadFile(fileURL string) ([]byte, error) {
	jsonFile, err := os.Open(fileURL)
	if err != nil {
		return []byte{}, err
	}

	defer jsonFile.Close()

	byteValue, _ := ioutil.ReadAll(jsonFile)
	return byteValue, nil
}