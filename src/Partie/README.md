# Le dossier Partie
Ce dossier contient, au format **rb** l'ensemble des classes définissant chaque composant utilisé lors d'une partie.

## Aide.rb

## Case.rb
La classe **Case** définit la création d'une case de la grille.
Cette dernière est caractérisée par des coordonnées en abscisse et ordonnée, un numéro et le plateau auquel elle appartient.

## Coup.rb
La classe **Coup** définit l'interaction de l'utilisateur sur un point du plateau.
Ce **coup** est caractérisé, comme une case, par des coordonnées en abscisse et ordonnée.
De plus, la classe permet de revenir au coup précédant ce même coup.

## GestionnairePartie.rb
La classe fille, de la classe **Menu**,  **GestionnairePartie** définit l'ensemble des méthodes de gestion de l'affichage d'une partie, notamment :
 - La réinitialisation des scores
 - Le chargement d'une partie, en mémoire ou non, et la création de tous les évènements des différents widgets
 - La sauvegarde d'une partie dans un fichier
 - L'actualisation de l'affichage, notamment du temps et du nombre de coups joués
 - L'arrêt de la partie en cours

## Mur.rb
La classe **Mur** permet la représentation du lien entre deux coins d'une même case ou de deux cases adjacentes.
Un **mur** possède un état (vide, remplit ou croix), l'état dans lequel il doit être selon la solution finale du plateau et le bouton permettant à l'utilisateur d’interagir avec ce mur.
De plus, un mur peut changer son état et, notamment, revenir à son état précédent (**CROIX -> REMPLI -> VIDE**).

## Partie.rb
La classe **Partie** représente les données de la partie, contrairement à la classe **GestionnairePartie** qui définit son affichage.
Ainsi, une **partie** est caractérisée par un gestionnaire, un numéro d'identification, le niveau de difficulté du niveau choisi et un compteur de temps écoulé.
**Partie** définit l'ensemble des méthodes de gestion des données d'une partie, notamment :

 - Lancer et mettre à jour le compteur de temps
 - L'arrêt d'une partie
 - Charger un plateau, ses cases et, au plus, trois quicksave sous forme de plateaux
 - Sauvegarder un plateau
 - Faire jouer ou déjouer un ou tous les coups
 - Calculer le nombre total de coups joués et le score
 
## Temps.rb
La classe **Temps** représente le compteur du temps écoulé depuis le lancement de la partie.
Ce **temps** peut être calculé en secondes, minutes, heures ou jours.
Il peut être mit en pause et relancé.
