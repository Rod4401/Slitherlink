VIDE = 0
REMPLI = 1
CROIX = 2
class Mur
  #La classe Mur permet de représenté au sein de la mémoire un mur c'est-à-dire un lien entre 2 cases
  #@etat  => Etat courant du mur (vide, remplit, avec une croix)
  #@etatCorrect => L'état correcte du mur
  #@btn => Le Gtk::Button relié à ce mur, cela permet l'affichage de l'état

  #La méthode de classe creer permet d'appeler la méthode new et de rendre cette dernière inutilisable dans le but de rendre le code plus parlant
  def Mur.creer()
    new()
  end

  #On rend la méthode de classe new private
  private_class_method :new

  #La méthode initialize permet de définir les variables d'instances
  def initialize()
    @etat = VIDE
    @etatCorrect = VIDE
  end

  def changeWallState()
    @etatCorrect+=1
    @etatCorrect%=3
  end

  def getState()
    case @etatCorrect
    when VIDE
      return " "
    when REMPLI
      return "@"
    when CROIX
      return "X"
    end
  end

end
