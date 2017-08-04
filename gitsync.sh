#!/bin/bash
#
# gitsync
#
# Auteur : Adimux <adam@cherti.name>
# Site web : adam.cherti.name
#
# Ce script synchronise un dépôt git en ajoutant automatiquement les nouveaux fichiers au dépôt et en ramenant les changements distants, puis poussant les changements locaux
# Utilisation du script :
# gitsync                       # Synchronise le dépôt courant
# gitsync path/to/repositorydir # Synchronise le dépôt dans le dossier /path/to/repositorydir
 
tosync=$1
cd "$tosync"
 
if git rev-parse --git-dir > /dev/null 2>&1; then # C'est un dépôt git valide
    root_dir=$(git rev-parse --show-toplevel) # Le répertoire racine du dépôt
 
    tosync=$root_dir
    git pull
 
    # On parcourt la liste des dossiers
    # et on "git add" tous les fichiers
    find | while read line; do
        if [[ (-d "$line") && ( "$line" != */.git/* ) ]]; then # On vérifie si c'est un dossier
            if [ "$(ls -A "$line")" ]; then # Si le dossier n'est pas vide
                if [[ "$(cd "$line" && git rev-parse --show-toplevel)" == "$(git rev-parse --show-toplevel)" ]] # On voit si ce n'est pas un sous-dépôt
                then
                    git add --all "$line"/* # On ajoute tous les fichiers dans le dossier
                fi
            fi
        fi
    done
 
    git commit -a -m 'auto update' # On commit avec comme message auto update
    git push
else # Ce n'est pas un dépôt
    echo "\"$tosync\" is not a valid git repository"
fi
