# gitautomata
Automating my linux needs


# Gitautomata
The original goal of this package was to automate a deployment of a couple websites, later also installing nginx automatically, and now I've added a personal configuration script for manjaro-i3wm.

### _
All the files prefixed with _ will be dot sourced to every script file.

### private_info_config
The git config step can also be automated, but you don't want that here, so that file should be made locally.

## Freshpull.sh

### "Fresh"
The pull is done in such a way that all potential changes on the server side will be overwritten with
whatever is on the github repository, but it leaves all the untracked files (such as uploaded images,
db, etc). This way, you can try out things on the server, and you'll know that the next time this script is run, everything is exactly like the repo again.

### Save config
A couple of config files are saved to ./zimmerman/ and ./higala (not in this repo), and those are
copied back after the freshpull to keep necessary server config working, that is not in the 
repository.

This should probably be fixed in the source code (separating all the server-specific config to one file, that is .gitignored). But this works for now.
