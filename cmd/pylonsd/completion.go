package main

import (
	"os"

	"github.com/spf13/cobra"
)

func Completion() *cobra.Command {

	// completionCmd represents the completion command
	c := &cobra.Command{
		Use:   "completion",
		Short: "Generate completion script",
		Long: ` The completion command outputs a completion script you can use in your shell. The output script requires 
				that [bash-completion](https://github.com/scop/bash-completion)	is installed and enabled in your 
				system. Since most Unix-like operating systems come with bash-completion by default, bash-completion 
				is probably already installed and operational.

Bash:

  $ source <(pylons completions bash)

  To load completions for every new session, run:

  ** Linux **
  $ pylons completions bash > /etc/bash_completion.d/pylons

  ** macOS **
  $ pylons completions bash > /usr/local/etc/bash_completion.d/pylons

Zsh:

  If shell completions is not already enabled in your environment, you will need to enable it.  You can execute the following once:

  $ echo "autoload -U compinit; compinit" >> ~/.zshrc

  To load completions for each session, execute once:
  
  $ pylons completions zsh > "${fpath[1]}/_pylons"

  You will need to start a new shell for this setup to take effect.

fish:

  $ pylons completions fish | source

  To load completions for each session, execute once:
  
  $ pylons completions fish > ~/.config/fish/completionss/pylons.fish

PowerShell:

  PS> pylons completions powershell | Out-String | Invoke-Expression

  To load completions for every new session, run:
  
  PS> pylons completions powershell > pylons.ps1
  
  and source this file from your PowerShell profile.
`,
		DisableFlagsInUseLine: false,
		ValidArgs:             []string{"bash", "zsh", "fish", "powershell"},
		Args:                  cobra.ExactValidArgs(1),
		Run: func(cmd *cobra.Command, args []string) {
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
		},
	}
	return c
}
