# autoenv-track plugin for zsh

Adds utility functions for automatically cleaning aliases, functions and exports defined in [`.autoenv.zsh`](https://github.com/Tarrasch/zsh-autoenv). Can be used independenly of [zsh-autoenv](https://github.com/Tarrasch/zsh-autoenv) as well.

## Usage

After installing with your zsh plugin manager of choice add `autoenv-track-{pre,post}` to your `.autoenv.zsh` and `autoenv-track-restore` to your `.autoenv_leave.zsh`:


```bash
# .autoenv.zsh

# Uncomment the next line for verbose (!) debugging
# export AUTOENV_TRACK_DEBUG=true

autoenv-track-pre

#  your auotenv code here

# Save the lists of exports, functions and aliases defined in your code above
autoenv-track-post

# Defintions added after this call won't be tracked

```

```bash
# .autoenv_leave.zsh

# Unset the definitons saved in .autoenv.zsh
autoenv-track-restore

```
