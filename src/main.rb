#Inclusion de gtk 3
require 'gtk3'

#Constante correspondant au dossier des menus
DIRMENU = "Menus/"

#Constante correspondant au dossier des css
DIRCSS = "css/"

#Inclusion du gestionnaire de menu pour lancer le jeu
require_relative DIRMENU+"GestionnaireMenu.rb"

# On lance l'application
GestionnaireMenu.creer()

#On lance l'éxecution de gtk
Gtk.main
