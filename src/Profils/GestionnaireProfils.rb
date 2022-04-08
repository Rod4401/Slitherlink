##
#La classe GestionnaireProfils permet de gérer l'ensemble des profils

class GestionnaireProfils
  #@listeUser => La liste des profils
  #@selectedUser => Le profil actif/selectionné

  #La méthode de classe creer permet d'appeler la méthode new et de rendre cette dernière inutilisable dans le but de rendre le code plus parlant
  def GestionnaireProfils.creer()
    new()
  end

  #On rend la méthode de classe new private
  private_class_method :new

  #La méthode initialize permet de créer le profil par défaut et d'initialiser les variables d'instance
  def initialize()
    @listeUser = Array.new()
    #On créer le profil par défaut "Invité"
    invite = Profil.creer("Invité",1)
    #On ajoute invité à la liste des profils
    @listeUser.push(invite)
    #On rend invité comme profil actif
    @selectedUser = invite
  end

  #La méthode permet de séléctionner un autre utilisateur comme profil actif
  #Le name passé en paramètre est le nom du prochain profil actif
  #Le name passé en paramètre est forcément correcte car il est seléctionné parmi l'ensemble des profils
  #et est donc pas écrit par l'utilisateur
  def setProfilActif(name)
    #On prend le premier profil qui porte le nom name
    @selectedUser=@listeUser.select{|i| i.name == name }.first
  end

  #Retourne la liste des profils
  def getNbProfils
    @listeUser.length
  end

  #Cette méthode renvoie le profil actif
  def getProfilActif
    @selectedUser
  end

  #Cette méthode renvoie la liste des profils
  def listeProfils
    @listeUser
  end

  #Cette méthode permet de créer un nouveau profil
  def nouveauProfil(name)
    #On créer le nouveau profil
    newUser = Profil.creer(name,self.getNbProfils()+1)
    #On ajoute le nouveau profil à la liste des profils
    @listeUser.push(newUser)
    #On rend ce profil actif
    @selectedUser = newUser
    #on demande la sauvegarde
    sauvegardeToi()
  end

  #Cette méthode supprime le profil actif et met à jour les "id" des profils
  def supprimerProfil()
    #On récupère l'id du profil actif
    idDuName = @selectedUser.id()
    #On séléctionne tous les profils qui ont un id supérieur au profil actif
    @listeUser.select{|i| i.id > idDuName }.map{ |i|
      #Pour chaque profil on décrémente leur id
      i.decrementeId()
    }
    #On retire de la lite le profil actif
    @listeUser.delete(@selectedUser)
    #On prend le premier profil "Invité" comme profil actif
    @selectedUser = @listeUser.first
    #on demande la sauvegarde
    sauvegardeToi()
  end

  #Retourne un profil en fonction du nom
  def getUserByName(name)
    @listeUser.select{|i| i.name == name }.first
  end

  #La méthode permet de sauvegarder le gestionnaire de profil
  def sauvegardeToi()
    #On ouvre le fichier correspondant
    file = File.open(FILE_SAVE_PROFILS,"w")
    #On demande à Marshal de sérialiser notre gestionnaire de profil
    string =  Marshal.dump(self)
    #On écrit le résultat de Marshal
    file.write(string)
    #On ferme le fichier
    file.close
  end

end
