#!/bin/bash

read -p "Donnez votre choix : 0 pour télécharger, 1 pour installer avec pacman : " choix


# this for creating a new folder where we can store the for eeach package some links for it

folder_name="packages_folder/"
if [ ! -d 'packages_folder' ]; then
   echo "It doesn't already exists"
   mkdir folder_name
fi

if [ $choix -eq 0 ]; then
    read -p "Donnez le nom du package : " package
    curl -o links_new.txt "https://packages.debian.org/bookworm/amd64/$package/download"
    
    contenu=$(cat 'links_new.txt')
   
    links=$(echo "$contenu" | grep -o 'http[^"]*')
    
    echo -n > "${folder_name}package_${package}"
    
    for line in $links
    do
        ext="${line##*.}"
        if [[ $ext == "deb" ]]; then
            # Handle .deb file
	    echo "$line" >> "${folder_name}package_${package}"
	    wget $line
	    sudo dpkg -i ${line##*/}
	    break
        fi	
    done
    
    echo "Done storing links you can view them here : packages_folder/package_${package}"
elif [ $choix -eq 1 ]; then
    read -p "Donnez le nom du package : " package
    sudo apt install $package
    if [ $? -eq 0 ]; then
        echo "Installation réussie."
        exit
    else
        echo "Échec de l'installation avec le code de retour $?"
    fi
else
    echo "Choix invalide."
fi
