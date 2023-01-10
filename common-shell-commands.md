[<== Back to main README](README.md)

# Common shell commands

* Arguments between [] are optional
* Arguments between <> are mandatory

## Standard commands - found in any typical Linux environment

| Command                        | Notes                                                                              |
| :----------------------------- | :--------------------------------------------------------------------------------- |
| `ls` [directory]               | List contents. If directory is not specified, lists contents of current directory. |
| `ls -lah` [directory]          | As `ls` but **l**ong format, **a**ll files, and show **h**idden files.             |
| `cd [location]`                | Change directory. If location unspecified, goes to HOME (~)                        |
| `rm <filename>`                | Remove _file_                                                                      |
| `rmdir <dirname>`              | Remove _empty_ directory                                                           |
| `rm -rf <dirname>`             | Remove directory and all contents! Careful! Irreversible!                          |
| `mkdir <dirname>`              | Make new (empty) directory `<dirname>`                                             |
| `mkdir -p </some/full/path>`   | Make new target directory _and all parents if they don't exist_                    |
| `mv <origin> <destination>`    | Move file _or (empty or nonempty)_ directory from origin to destination            |
| `cp <origin> <destination>`    | Copy _file_ from source to destination                                             |
| `cp -R <origin> <destination>` | Copy _directory and all contents_ from origin to destination                       |

## Bespoke commands - written for convenience for LSHTM-TBMG - not found in other environments

**NOTE:** only useful when you are working in the interactive prompt (i.e., at the prompt). Do not use in cluster job scripts.

| Command            | Notes                                                |
| :----------------- | :--------------------------------------------------- |
| `cdwork`           | Change to `/work/ec232/ec232/YourUserName`           |
| `usqueue`          | Show the cluster queue for your user only            |
| `update-hpc-setup` | Update the `hpc-setup` folder in your HOME directory |

## Non-standard commands - installed for LSHTM-TBMG

**NOTE**: these aren't 'custom', but these applications aren't installed everywhere. I have installed them for convenience.

| Command | Notes                                                             |
| :------ | :---------------------------------------------------------------- |
| `gh`    | GitHub CLI. Running `gh` will show you the available sub commands |