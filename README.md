# zsh-tgswitch

![GitHub](https://img.shields.io/github/license/ptavares/zsh-tgswitch)

zsh plugin for installing and loading [tgswitch](https://github.com/warrensbox/tgswitch)

## Table of content

_This documentation section is generated automatically_

<!--TOC-->

- [zsh-exa](#zsh-exa)
  - [Table of content](#table-of-content)
  - [Supported Operating system](#supported-operating-system)
  - [Usage](#usage)
  - [Aliases set up by plugin](#aliases-set-up-by-plugin)
  - [Updating exa](#updating-exa)
  - [License](#license)

<!--TOC-->

## Usage

Once the plugin installed, `tgswitch` will be available

- Using [Antigen](https://github.com/zsh-users/antigen)

Bundle `zsh-tgswitch` in your `.zshrc`

```shell script
antigen bundle ptavares/zsh-tgswitch
```

- Using [zplug](https://github.com/b4b4r07/zplug)

Load `zsh-tgswitch` as a plugin in your `.zshrc`

```shell script
zplug "ptavares/zsh-tgswitch"
```

- Using [zgen](https://github.com/tarjoilija/zgen)

Include the load command in your `.zshrc`

```shell script
zget load ptavares/zsh-tgswitch
```

- As an [Oh My ZSH!](https://github.com/robbyrussell/oh-my-zsh) custom plugin

Clone `zsh-tgswitch` into your custom plugins repo and load as a plugin in your `.zshrc`

```shell script
git clone https://github.com/ptavares/zsh-tgswitch.git ~/.oh-my-zsh/custom/plugins/zsh-tgswitch
```

```shell script
plugins+=(zsh-tgswitch)
```

Keep in mind that plugins need to be added before `oh-my-zsh.sh` is sourced.

- Manually

Clone this repository somewhere (`~/.zsh-tgswitch` for example) and source it in your `.zshrc`

```shell script
git clone https://github.com/ptavares/zsh-tgswitch ~/.zsh-tgswitch
```

```shell script
source ~/.zsh-tgswitch/zsh-tgswitch.plugin.zsh
```

## Updating tgswitch

The plugin comes with a zsh function to update [tgswitch](https://github.com/ahmetb/tgswitch.git) manually

```shell script
# From zsh shell
update_zsh_tgswitch
```

## License

[MIT](LICENCE)
