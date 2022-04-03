# pass-tmuxclip

`pass-tmuxclip` is an extension for the [password store](https://www.passwordstore.org/) (*"the standard unix password manager"*) that copies a stored password into the tmux paste buffer (as opposed to `pass show --clip` which copies into the system clipboard). This makes using `pass` more comfortable on systems that don't have an X session running and thus no system clipboard available.

## Usage

```sh
pass tmuxclip [--clip[=line-number],-c[line-number]] pass-name
```

Paste the password (within tmux) with *Ctrl-b Ctrl-]*.

The password will be deleted from the tmux paste buffer after 45 seconds (or `$PASSWORD_STORE_CLIP_TIME` if set).

## Examples

```sh
pass tmuxclip email/gmail
pass tmuxclip -c2 email/gmail
```

You get the first line of a password file unless you specify a different line number using `--clip[=line-number]` or `-c[line-number]` (analogous to `pass show --clip=line-number pass-name`).

## Installation

### For the current user only

* Copy (or symlink) `tmuxclip.bash` into `~/.password-store/.extensions/`.
* Enable local extensions by setting `PASSWORD_STORE_ENABLE_EXTENSIONS` to `true` and exporting it.

### System wide

* Copy (or symlink) `tmuxclip.bash` into `/usr/lib/password-store/extensions/`.

## License

This extension's only function is a modified version of `pass`'s original `clip()` function. That's why GPLv2 applies to this extension, too.
