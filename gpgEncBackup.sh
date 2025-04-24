#!/bin/bash

# v.0.1.0 // In testing (Thu.Apr24.2025)

# VARIABLES
SHOW_HEADER=$(cat sources/header)
SHOW_BANNER=$(cat sources/banner)
DEST_DIR="backups"
DATE=$(date +%Hh%Mm-%Y-%m-%d)
ARCHIVE_NAME="backup_$DATE.tar.gz"
ENCRYPTED_ARCHIVE="$ARCHIVE_NAME.gpg"
MK_DIRS=$(mkdir -p backups history sources)

# COLORS/STYLE
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
CYAN='\e[36m'
BOLD='\e[1m'
RESET='\e[0m'

# FUNCTIONS

# Creating a compressed file
createTar(){
  menuCreateTar=0
  until [[ $menuCreateTar == 1 ]];
  do
    $MK_DIRS # Creating directories 
    echo -e -n "\n${RESET}${BOLD}${RED}::${RESET} ${BOLD}${YELLOW}Enter the absolute path of the directory to be backed up:${RESET} ${RED}"
    read SRC_DIR
    echo -e -n "\n${RESET}${BOLD}${RED}::${RESET} ${BOLD}${YELLOW}Is the '$SRC_DIR' path correct?? (y/n):${RESET} ${RED}"
    read confirmPath
    if [ $confirmPath == "y" ]; then
      echo -e "\n${RESET}${BOLD}${RED}::${RESET} ${BOLD}${YELLOW}Creating compressed directory. Please wait...${RESET} ${RED}"
      echo ""
      tar -czf "$DEST_DIR/$ARCHIVE_NAME" "$SRC_DIR"
      echo -e "\n${RESET}${BOLD}${RED}::${RESET} ${BOLD}${YELLOW}The directory has been compressed successfully!${RESET} ${RED}"
      sleep 3
      clear
      ((menuCreateTar=1))
    else
      echo -e "\n${RESET}${BOLD}${RED}::${RESET} ${BOLD}${YELLOW}Returning...${RESET} ${RED}"
      sleep 1.5
      clear
      ((menuCreateTar=0))
    fi
  done
}

# Encrypting the directory
encDir(){
  menuEncDir=0
  until [[ $menuEncDir == 1 ]];
  do
    echo ""
    gpg --list-keys
    echo -e -n "\n${RESET}${BOLD}${RED}::${RESET} ${BOLD}${YELLOW}You have an active gpg key? (y/n):${RESET} ${RED}"
    read confirmKeyActive
    if [ $confirmKeyActive == "y" ]; then
        echo -e -n "\n${RESET}${BOLD}${RED}::${RESET} ${BOLD}${YELLOW}Enter your public key ID (user@example.com):${RESET} ${RED}"
        read GPG_RECIPIENT
        gpg --yes --batch --output "$DEST_DIR/$ENCRYPTED_ARCHIVE" --encrypt --recipient "$GPG_RECIPIENT" "$DEST_DIR/$ARCHIVE_NAME"
        sleep 2
        clear
        ((menuEncDir=1))
    elif [ $confirmKeyActive == "n" ]; then
        echo -e "\n${RESET}${BOLD}${RED}::${RESET} ${BOLD}${YELLOW}Next you will create a new public gpg key:${RESET} ${RED} "
        echo ""
        gpg --full-generate-key
        echo -e "\n${RESET}${BOLD}${RED}::${RESET} ${BOLD}${YELLOW}Your key has been generated successfully${RESET} ${RED}"
        sleep 2
        clear
        ((menuEncDir=0))
    else
        echo -e "\n${RESET}${BOLD}${RED}::${RESET} ${BOLD}${YELLOW}Unexpected response. Returning...${RESET} ${RED}"
        sleep 2
        clear
        ((menuEncDir=0))
    fi
  done
}

# Final mssg
finalMsg(){
  echo -e "\n${RESET}${BOLD}${RED}::${RESET} ${BOLD}${YELLOW}Backup encrypted and stored as: $DEST_DIR/$ENCRYPTED_ARCHIVE ${RESET}${RED}"
  echo -e -n "${RESET}${BOLD}${RED}::${RESET} ${BOLD}${YELLOW}Press Enter to continue _${RESET}${RED}"
  ls -l "$DEST_DIR/" > history/hist_file
  grep -oP 'backup.*' history/hist_file >> history/data.log
  sed -i "\$ s/\$/ Autor ID: $GPG_RECIPIENT/" history/data.log
  clear
  read endScript
}

# Remove the unencrypted file (.tar.gz)
removeUnencryptedFile() {
  echo -e "\n${RESET}${BOLD}${RED}::${RESET} ${BOLD}${YELLOW}Deleting temporary files...${RESET}${RED}"
  rm "$DEST_DIR/$ARCHIVE_NAME"
  rm "history/hist_file"
  echo -e "${RESET}${BOLD}${RED}::${RESET} ${BOLD}${YELLOW}Temporary files have been deleted!${RESET}${RED}"
  sleep 3
  clear
}

# MAIN MENU
homeMenu=0
until [[ $homeMenu == 1 ]];
do
  clear
  echo -e "${RESET}${BOLD}${RED}$SHOW_HEADER${RESET}"
  echo -e "${RESET}${YELLOW}$SHOW_BANNER${RESET}"
  echo -e "${BOLD}${RED}[1]${RESET} ${BOLD}${YELLOW}Run Script${RESET} ${BOLD}${RED}[2]${RESET} ${BOLD}${YELLOW}Exit${RESET}"
  echo -e "${RESET}${BOLD}${YELLOW}-------------------------------------------------------------------------------${RESET}"
  echo -e -n "\n${RESET}${BOLD}${RED}::${RESET} ${BOLD}${YELLOW}Choose an option:${RESET} ${RED}"
  read userOption
  if [ $userOption == 1 ]; then
    createTar
    encDir
    finalMsg
    removeUnencryptedFile
    ((homeMenu=1))
  elif [ $userOption == 2 ]; then
    echo -e "\n${RESET}${BOLD}${RED}::${RESET} ${BOLD}${YELLOW}Bye...${RESET}"
    sleep 2
    clear
    ((homeMenu=1))
  else
    echo -e "\n${RESET}${BOLD}${RED}::${RESET} ${BOLD}${YELLOW}Unexpected response. Returning...${RESET}${RED}"
    sleep 2
    ((homeMenu=0))
  fi
done
