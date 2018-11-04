#!/bin/bash

# ************************************************************
# Distro:       Ubuntu 18.04
# Autor:        Enrico Alletto
# Description:  automatic installation of development tools
# Note:         for help autoinstall-dev-tools.sh help
# ************************************************************

case $1 in
  list)
    dpkg -l | grep ^ii | awk '{print $2, $3}'
    dpkg -l | grep ^ii | wc -l

  ;;
  verify)
    # deve essere presente il file dev-pack.txt
    dpkg -l | grep ^ii | awk '{print $2}' > package.txt # crea file per confronare i pacchetti installati
    echo
    echo OK package
    diff dev-pack.txt package.txt -u | grep -v "^\+" | grep -v "^\-" | grep -v "^\@@"
    echo
    echo Install package
    diff dev-pack.txt package.txt -u | grep -v "^\+" | grep -e "^\-" | grep -v "^\---"
    echo
    rm package.txt
  ;;
  install)
    read -r -p "Vuoi proseguire a installare i pacchetti? [S/n]" response
    response=${response,,} # tolower
      if [[ $response =~ ^(si|s| ) ]] || [[ -z $response ]]; then
        # add repository
        echo --- Add ubuntu repository ---
        sudo add-apt-repository -y ppa:webupd8team/atom
        # update and upgrade
        echo --- ubuntu update ---
        sudo apt update
        echo --- ubuntu upgrade ---
        sudo apt -y upgrade
        # Install
        echo --- GIT Install ---
        sudo apt -y install git
        echo --- ATOM Install ---
        sudo apt -y install atom
      fi
  ;;
  remove)
    echo removing
  ;;
  *)
  echo ATTENZIONE! Non hai inserito il comando corretto. Controlla help
  ;;
esac
