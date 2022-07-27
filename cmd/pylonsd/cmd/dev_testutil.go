package cmd

import "os"

func writeFixtureAtTestRuntime(name string, data string) {
	file, err := os.Create(name)
	if err != nil {
		panic(err)
	}
	defer file.Close()
	_, err = file.WriteString(data)
	if err != nil {
		panic(err)
	}
}
