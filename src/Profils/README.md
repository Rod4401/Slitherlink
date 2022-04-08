# Le dossier Profils
Le dossier profils contient 3 fichiers importants pour le projet :

 - [GestionnaireProfil.rb](./GestionnaireProfils.rb)
 - [Profil.rb](./Profil.rb)
 - [profil.save](./profils.save)

## GestionnaireProfils.rb
Ce fichier est une fichier pilier du jeu. En effet, il contient le code de la classe qui porte le même nom. Cette classe, dans l'ensemble permet de faire la gestion des profils.
Cette classe contient notamment une liste de profil ainsi qu'un profil sélectionné (dit actif).

## Profil.rb
Dans ce fichier vous retrouverez la classe Profil, qui permet de représenter un profil.

## profil.save
Ce fichier contient une version sérialisée du gestionnaireProfil. Pour pouvoir sauvegarder les profils, on a juste à sérialiser le gestionnaireProfil. Comme ce dernier contient la liste des profils, à son chargement, les profils sont restaurés. Lors du chargement du jeu, le GestionnaireMenu se charge de regarder si il y a un fichier profil.save, si il n'en trouve pas il créé un nouveau GestionnaireProfil.
(cf [GestionnaireMenu.rb](./GestionnaireMenu.rb))
