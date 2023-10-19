#!/bin/bash

folder_name="packages_folder"
if [ ! -d "$folder_name" ]; then
   mkdir "$folder_name"
   echo "Folder '$folder_name' created."
fi


function GetLinks() {
  local packageName="$1"
  local folder_name="packages_folder"
  curl -o links_new.txt "https://packages.debian.org/bookworm/amd64/$packageName/download"
  contenu=$(cat "links_new.txt")
  links=$(echo "$contenu" | grep -o 'http[^"]*')
  
  for line in $links; do
        ext="${line##*.}"
        if [[ $ext == "deb" ]]; then
           echo "$line" >> "${folder_name}/package_${package}"
           return 1
        fi
   done
   
   return 0 # means that there is no links available : 
}

function InstallPackage() {
    local folder_name="packages_folder"
    local packageName="$1"
    linkFromFile=$(cat "${folder_name}/package_$packageName")
    wget "$linkFromFile" -P "$folder_name"
    echo "the links is ther e: "$(basename $linkFromFile)
    sudo dpkg -i "$folder_name/$(basename $linkFromFile)"
}

read -p "Donnez votre choix : 0 pour télécharger, 1 pour installer avec pacman : " choix



if [ $choix -eq 0 ]; then
    read -p "Donnez le nom du package : " package

    # Check if the package already exists in the folder
    if [ -f "${folder_name}/package_${package}" ]; then
        echo "Package already exists. No need to reinstall."
        exit 0
    fi
    echo -n "${folder_name}/package_${package}"
    
    # view first if there is a links in the text file : 
    
    GetLinks "$package"
    if [ $? -eq 0 ]; then
       echo "No links are available for this packet try another one"
       exit 0
    fi	
  
    # Download and install the package
    
    InstallPackage "$package"
    if [ $? -eq 0 ]; then
    	echo "the package is installed with success"
    	exit 0
    fi
    
        dependancies=$(apt-cache show "$package" | grep 'Depends' | cut -d: -f 2)
	IFS="," read -ra items <<< "$dependancies"

	for item in "${items[@]}"; do
	    echo "Item: $item"
	    sudo apt install "$item"
	done
    
    
elif [ $choix -eq 1 ]; then
    read -p "Donnez le nom du package : " package
    sudo apt install "$package"
    apt_exit_code=$?
    if [ $apt_exit_code -eq 0 ]; then
        echo "Installation réussie."
    else
        echo "Échec de l'installation avec le code de retour $apt_exit_code"
    fi
else
    echo "Choix invalide."
fi
