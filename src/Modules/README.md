# Le dossier Modules
Le dossier Modules contient un seul module qui se nomme [Difficulte.rb](./Difficulte.rb).
Dans la plupart de notre code, nous avons besoin pour les différentes difficultés, des entiers (0-facile,1-normale,2-difficiles) ou encore un nombre de case. Pour simplifier, nous avons mis en place un module incluant une méthode to_i(). Cette méthode permet de transformer un une constante de difficulté en un entier.
Pour facilité le problème, nous avons mis en place 3 constantes qui sont :
 - EASY = "faciles"
 - MEDIUM = "normales"
 - HARD = "difficiles"

Enfin lorsque nous voulons avoir un nombre de cases nous faisons : to_i(difficulte,x,y,z).
Dans cet exemple x, y, z correspondent aux nombre de case respectivement facile, normale, difficile. et difficulté correspond à la constante choisie selon le niveau de difficulté.
