
# Le dossier Menus
Le dossier menus contient toutes les classes qui représentes des menus.
En effet, avec ruby gtk, une fenêtre ne peut contenir qu'un seul composant. Pour remédier à ce problème, nous avons imaginé une classe (GestionnaireMenu). Cette classe est passée en paramètre de chaque menu pour pouvoir avoir un accès à la fenêtre.

## Glade
Pour générer l'interface graphique de chaque menu, nous avons utilisé [Glade](https://glade.gnome.org/).
Glade propose une interface permettant de faciliter la création d'interface graphique.

![glade.png](../image/glade.png)
Vous trouverez l'ensemble des fichiers glade dans ce dossier [FileGlade](../FileGlade/).

## Le builder
Le builder est notre ami !
En effet, cette classe de ruby Gtk nous a permi d'intégrer nos fichiers glade dans notre projet.
Nous avons créer une classe Builder qui fait appel au builder Gtk et nous génère dynamiquement nos composants graphiques.
Chaque menu possède une variable nommée "@builder" qui est un accès à la classe builder qui a généré les composoants. Vous trouverez plus d'informations [ici](./Builder.rb).

## Menu
Comme pour les popups, nous avons remarqué que tous les menus ont des comportements communs. Tous ces comportements ont été écrit une seule fois dans la classe Menu. Tous les autres menu hérites de la classe Menu (cf [Menu.rb](./Menu.rb)).
Revenons à notre introduction, une fenêtre peut contenir un seul composant.
Donc chaque menu est une Gtk::Box, cela permet de dire au GestionnaireMenu d'ajouter dans sa fenêtre, l'instance de la sous-classe Menu.
