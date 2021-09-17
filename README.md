# element-web-update.sh

This is a bash script that installs from scratch and checks the new released version of [Matrix](http://matrix.org/) client [Element-web](https://element.io/) from [official Github repo](https://github.com/vector-im/element-web) and if it differs from installed - updates the local files with deleting old version (to cleanup old files) and unpacking new one, but with keeping the config files by mask `config*.json`.

You can put it to your `crontab.daily` and got an always fresh Element with forgetting about manual update routine.

Also you can override variables using copy of `.env.example` file and place it with `.env` name in your launching directory, variables:

- `DIRECTORY_INSTALL` - a directory to which Element files must be placed.
- `DIRECTORY_TMP` - a directory for placing temporary downloaded files - it must be different than install directory!
- `VERSION_URL` - an url to repository for checking latest version number.

---

Requirements:

- `jq` to parse JSON reply from Github.
- `curl` to download the package.
- `tar` for unpack the package.

On Debian/Ubuntu Linx systems you can install all of them using command:
```
sudo apt install jq curl curl 
```
Or similar way in other Linux systems.

