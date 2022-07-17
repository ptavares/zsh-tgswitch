#!/usr/bin/env zsh

################################################################################
# commons
################################################################################
autoload colors is-at-least
autoload -U add-zsh-hook

################################################################################
# constant
################################################################################
BOLD="bold"
NONE="none"

################################################################################
# Plugin main
################################################################################

[[ -z "$TGSWITCH_HOME" ]] && export TGSWITCH_HOME="$HOME/.tgswitch/"

ZSH_TGSWITCH_VERSION_FILE=${TGSWITCH_HOME}/version.txt

# ------------------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------------------

_zsh_tgswitch_log() {
    local font=$1
    local color=$2
    local msg=$3
    if [ $font = $BOLD ]
    then
        echo $fg_bold[$color] "[zsh-tgswitch-plugin] $msg" $reset_color
    else
        echo $fg[$color] "[zsh-tgswitch-plugin] $msg" $reset_color
    fi
}

_zsh_tgswitch_last_version() {
    echo $(curl -s https://api.github.com/repos/warrensbox/tgswitch/releases/latest | grep tag_name | cut -d '"' -f 4)
}

_zsh_tgswitch_download_install() {
    local version=$1
    local machine
    case "$(uname -m)" in
      x86_64)
        machine=amd64
        ;;
      arm64)
        machine=arm64
        # if on Darwin, trim $OSTYPE to match the tgswitch release
        [[ "$OSTYPE" == "darwin"* ]] && local OSTYPE=darwin
        ;;
      i686 | i386)
        machine=386
        ;;
      *)
        _zsh_tgswitch_log $BOLD "red" "Machine $(uname -m) not supported by this plugin"
        return 1
      ;;
    esac
    _zsh_tgswitch_log $NONE "blue" "  -> download and install tgswitch ${version}"
    curl -o ${TGSWITCH_HOME}/tgswitch.tar.gz -fsSL https://github.com/warrensbox/tgswitch/releases/download/${version}/tgswitch_${version}_${OSTYPE%-*}_${machine}.tar.gz
    tar xzf ${TGSWITCH_HOME}/tgswitch.tar.gz --directory ${TGSWITCH_HOME} 2>&1 > /dev/null
    rm -rf ${TGSWITCH_HOME}/tgswitch.tar.gz
    echo ${version} > ${ZSH_TGSWITCH_VERSION_FILE}
}

_zsh_tgswitch_install() {
    _zsh_tgswitch_log $NONE "blue" "#############################################"
    _zsh_tgswitch_log $BOLD "blue" "Installing tgswitch..."
    _zsh_tgswitch_log $NONE "blue" "-> creating tgswitch home dir : ${TGSWITCH_HOME}"
    mkdir -p ${TGSWITCH_HOME} || _zsh_tgswitch_log $NONE "green" "dir already exist"
    local last_version=$(_zsh_tgswitch_last_version)
    _zsh_tgswitch_log $NONE "blue" "-> retrieve last version of tgswitch..."
    _zsh_tgswitch_download_install ${last_version}
    _zsh_tgswitch_log $BOLD "green" "Install OK"
    _zsh_tgswitch_log $NONE "blue" "#############################################"
}

update_zsh_tgswitch() {
    _zsh_tgswitch_log $NONE "blue" "#############################################"
    _zsh_tgswitch_log $BOLD "blue" "Checking new version of tgswitch..."

    local current_version=$(cat ${ZSH_TGSWITCH_VERSION_FILE})
    local last_version=$(_zsh_tgswitch_last_version)

    if is-at-least ${last_version} ${current_version}
    then
        _zsh_tgswitch_log $BOLD "green" "Already up to date, current version : ${current_version}"
    else
        _zsh_tgswitch_log $NONE "blue" "-> Updating tgswitch..."
        _zsh_tgswitch_download_install ${last_version}
        _zsh_tgswitch_log $BOLD "green" "Update OK"
    fi
    _zsh_tgswitch_log $NONE "blue" "#############################################"
}

_zsh_tgswitch_load() {
    # export PATH if needed
    local -r plugin_dir=${TGSWITCH_HOME}
    # Add the plugin bin directory path if it doesn't exist in $PATH.
    if [[ -z ${path[(r)$plugin_dir]} ]]; then
        path+=($plugin_dir)
    fi    
}

# install tgswitch if it isnt already installed
[[ ! -f "${ZSH_TGSWITCH_VERSION_FILE}" ]] && _zsh_tgswitch_install

# load tgswitch if it is installed
if [[ -f "${ZSH_TGSWITCH_VERSION_FILE}" ]]; then
    _zsh_tgswitch_load
fi

# ------------------------------------------------------------------------------
# Set Alias for tgswitch to always use $HOME/.local/bin directory
# ------------------------------------------------------------------------------
alias tgswitch='tgswitch --bin=$HOME/.local/bin/terragrunt'

# ------------------------------------------------------------------------------
# function to load tgswitch automatically
# ------------------------------------------------------------------------------
load-tgswitch() {
  local tgswitchrc_path=".tgswitchrc"
  if [ -f "$tgswitchrc_path" ]; then
    tgswitch
  fi
}

add-zsh-hook chpwd load-tgswitch
load-tgswitch

unset -f _zsh_tgswitch_install _zsh_tgswitch_load
