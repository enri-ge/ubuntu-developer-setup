#!/bin/bash

# ************************************************************
# Distro:       Ubuntu 18.04
# Autor:        Enrico Alletto
# Description:  automatic installation of development tools
# Note:         for help autoinstall-dev-tools.sh help
# ************************************************************

#########################
# The command line help #
#########################
display_help() {
    echo
    echo "Usage: $0 [option...] {list|verify|install|remove}" >&2
    echo
    echo "   list           ottieni la lista di tutti i pacchetti installati"
    echo "   verify         verifica se sono installati i pacchetti development"
    echo "   install        installa i pacchetti development"
    echo "   remove         rimuovi i pacchetti development"
    echo
    # echo some stuff here for the -a or --add-options
    exit 1
}

case $1 in
  list)
    dpkg -l
    echo
    dpkg -l | grep ^ii | wc -l
    echo
    # dpkg -l | grep ^ii | awk '{print $2, $3, $4, $5}'
    echo Comando da lanciare per filtrare pacchetti specifici: "dpkg -l | grep <pacchetto>"
    echo
  ;;
  verify)
    # deve essere presente il file dev-pack.txt
    dpkg -l | grep ^ii | awk '{print $2}' > package.txt # crea file per confronare i pacchetti installati
    echo
    echo "**********************"
    echo "* Packages installed *"
    echo "**********************"
    diff dev-pack.txt package.txt -u | grep -v '^\+' | grep -v "^\-" | grep -v '^\@@'
    echo
    echo "**********************"
    echo "* Package to install *"
    echo "**********************"
    diff dev-pack.txt package.txt -u | grep -v '^\+' | grep -e "^\-" | grep -v '^\---'
    diff dev-pack.txt package.txt -u | grep -v '^\+' | grep -e "^\-" | grep -v '\dev-pack.txt' > toinst.txt
    echo
    rm package.txt
  ;;
  install)
    #sudo ls -latr # chiede la password sudo
    read -r -p "Vuoi proseguire a installare i pacchetti? [S/n]" response
    response=${response,,} # tolower
      if [[ $response =~ ^(si|s| ) ]] || [[ -z $response ]]; then
        # add repository
        echo
        echo --- Add ubuntu repository ---
        sudo add-apt-repository -y ppa:webupd8team/atom
        # update and upgrade
        echo
        echo --- ubuntu update ---
        sudo apt update
        echo
        echo --- ubuntu upgrade ---
        sudo apt -y upgrade
        # Install
        filename="dev-pack.txt"
        #While loop to read line by line
        while read -r line
        do
            pack=$line
                pack=$line
                pack1=${pack#"-"}
                echo
                echo --- $pack1 Install ---
                sudo apt -y install $pack1
        done < "$filename"
        #echo --- GIT Install ---
        # sudo apt -y install git
        # echo --- ATOM Install ---
        # sudo apt -y install atom
      fi
  ;;
  remove)
  read -r -p "Vuoi proseguire a rimuovere i pacchetti? [S/n]" response
  response=${response,,} # tolower
    if [[ $response =~ ^(si|s| ) ]] || [[ -z $response ]]; then

      filename="dev-pack.txt"
      #While loop to read line by line
      while read -r line
      do
          pack=$line
              pack=$line
              pack1=${pack#"-"}
              echo
              echo --- $pack1 Remove ---
              sudo apt-get remove --autoremove -y $pack1
      done < "$filename"
      sudo apt-get update
      sudo apt-get autoclean
      sudo apt-get clean
    fi
  ;;
  *)
  display_help
esac
