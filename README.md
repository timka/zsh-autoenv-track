# autoenv-track plugin for zsh

Adds utility functions for automatically cleaning aliases, functions and exports defined in [`.autoenv.zsh`](https://github.com/Tarrasch/zsh-autoenv). Can be used independenly of [zsh-autoenv](https://github.com/Tarrasch/zsh-autoenv) as well.

## Usage

After installing with your zsh plugin manager of choice add `@autoenv-track-{pre,post}` to your `.autoenv.zsh` and `@autoenv-track-restore` to your `.autoenv_leave.zsh`:


`.autoenv.zsh`:
```zsh

# Uncomment the next line for debugging output
# export AUTOENV_TRACK_DEBUG=true
#
# Ensure zinit is installed...
# which zinit > /dev/null \
# || zsh -c "$( \
#   curl \
#     --fail \
#     --show-error \
#     --silent \
#     --location \
#     https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh \
# )"
# ... and the plugin is loaded ...
# zinit load "timka/zsh-autoenv-track"
#
# ... as well as another plugin
# zinit load "another/zsh-plugin"

@autoenv-track-pre

#  your auotenv code here

# Save the lists of exports, functions and aliases defined in your code above
@autoenv-track-post

# Defintions added after this call won't be tracked

```

`.autoenv_leave.zsh`:
```zsh

# Unset the definitons saved in .autoenv.zsh
@autoenv-track-restore

# Unload the loaded plugins
# zinit unload "another/zsh-plugin"
# zinit unload "timka/zsh-autoenv-track"
```
