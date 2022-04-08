
# Le dossier Error
Le dossier Error contient 3 classes permettant de générer une erreur. L'objectif de ces classes est de générer des Erreurs personalisées.
Elles sont au nombre de 3:

 - PartieChargerError
 - PlateauCreationError
 - ProfilScoresError

## PartieChargerError.rb
Cette erreur est levée lorsque qu'il y a un souci au chargement d'une partie.
Le GestionnairePartie, lui seul, peut lancée cette erreur. Pour plus de détails : [GestionnairePartie.rb](../Partie/GestionnairePartie.rb).


## PlateauCreationError.rb
Lorsque la partie ne trouve pas de sauvegarde du plateau, elle lance la création de ce dernier. Cette création peut générer une exception et dans ce cas, la partie lève cette exception. Pour plus de détails : [Partie.rb](../Partie/Partie.rb).

## ProfilScoresError.rb
Cette dernière exception est très peu utilisée et arrive que dans un cas très particulier. En effet, l'erreur est levée si le profil ne peut pas réinitialiser ses scores. Si pour une raison, le tableau des scores est altéré, cette exception sera émise. Pour plus de détails : [Profil.rb](../Profil/Profil.rb).
