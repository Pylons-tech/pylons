package main

import (
	"context"
	log "github.com/sirupsen/logrus"
	chainconf "github.com/tendermint/starport/starport/chainconf"
	"github.com/tendermint/starport/starport/pkg/cosmosprotoc"
	"github.com/tendermint/starport/starport/pkg/xos"
	"github.com/tendermint/starport/starport/services/chain"
	"os"
	"path/filepath"
)

func main() {

	app, err := chain.NewAppAt(os.Args[1])
	if err != nil {
		log.Fatalln(err)
	}

	conf := chainconf.Build{
		Proto: chainconf.Proto{
			Path: "./proto",
			ThirdPartyPaths: []string{
				"third_party/proto",
				"proto_vendor",
			},
		},
	}

	// If proto dir exists, compile the proto files.
	if _, err := os.Stat(conf.Proto.Path); err != nil {
		log.Fatalln(err)
	}

	if err := cosmosprotoc.InstallDependencies(context.Background(), app.Path); err != nil {
		log.Fatalln(err)
	}

	log.Println("🛠️  Building proto...")

	err = cosmosprotoc.Generate(
		context.Background(),
		app.Path,
		app.ImportPath,
		filepath.Join(app.Path, conf.Proto.Path),
		xos.PrefixPathToList(conf.Proto.ThirdPartyPaths, app.Path),
	)

	if err != nil {
		log.Fatalln(err)
	}

	log.Println("🛠️  Proto is builded")
}
