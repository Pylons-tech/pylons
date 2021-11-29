package main

import (
	"os"

	"github.com/spf13/cobra"
)

func Completion() *cobra.Command {

	// completionCmd outputs the completion script
	c := &cobra.Command{
		Use:   "completions",
		Short: "Generate tab completion scripts",
		Long: ` The completions command outputs completions scripts you can use in your shell. The output script requires 
				that [bash-completion](https://github.com/scop/bash-completion)	is installed and enabled in your 
				system. Since most Unix-like operating systems come with bash-completion by default, bash-completion 
				is probably already installed and operational.

Bash:

  $ source <(pylonsd completions bash)

  To load completions for every new session, run:

  ** Linux **
  $ pylonsd completions bash > /etc/bash_completion.d/pylonsd

  ** macOS **
  $ pylonsd completions bash > /usr/local/etc/bash_completion.d/pylonsd

Zsh:

  If shell completions is not already enabled in your environment, you will need to enable it.  You can execute the following once:

  $ echo "autoload -U compinit; compinit" >> ~/.zshrc

  To load completions for each session, execute once:
  
  $ pylonsd completions zsh > "${fpath[1]}/_pylonsd"

  You will need to start a new shell for this setup to take effect.

fish:

  $ pylonsd completions fish | source

  To load completions for each session, execute once:
  
  $ pylonsd completions fish > ~/.config/fish/completionss/pylonsd.fish

PowerShell:

  PS> pylonsd completions powershell | Out-String | Invoke-Expression

  To load completions for every new session, run:
  
  PS> pylonsd completions powershell > pylonsd.ps1
  
  and source this file from your PowerShell profile.
`,
		DisableFlagsInUseLine: true,
		ValidArgs:             []string{"bash", "zsh", "fish", "powershell"},
		Args:                  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			switch args[0] {
			case "bash":
				cmd.Root().GenBashCompletion(os.Stdout)
			case "zsh":
				cmd.Root().GenZshCompletion(os.Stdout)
			case "fish":
				cmd.Root().GenFishCompletion(os.Stdout, true)
			case "powershell":
				cmd.Root().GenPowerShellCompletionWithDesc(os.Stdout)
			}
			return nil
		},
	}
	return c
}
