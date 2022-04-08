
##
#La classe Mur permet de représenté au sein de la mémoire un mur c'est-à-dire un lien entre 2 cases
class Mur
  #@etat  => Etat courant du mur (vide, remplit, avec une croix)
  #@etatCorrect => L'état correcte du mur
  #@btn => Le Gtk::Button relié à ce mur, cela permet l'affichage de l'état
  #@listeCase => Les cases au cotés du mur
  #La méthode de classe creer permet d'appeler la méthode new et de rendre cette dernière inutilisable dans le but de rendre le code plus parlant
  def Mur.creer(ec)
    new(ec)
  end

  #On rend la méthode de classe new private
  private_class_method :new

  #Coding assistant
  attr_reader :etatCorrect, :etat

  #La méthode initialize permet de définir les variables d'instances
  def initialize(ec)
    #Etat vide par défaut
    @etat = VIDE
    @etatCorrect = ec
  end

  #Cette méthode permet d'affecter à ce mur le Gtk::button passé en paramètre
  #Lorsqu'on recharge une partie on créé de nouveau Gtk::button, il faut donc
  #mettre à jour les murs en leur attribuant le nouveau button qui leur est relié
  def setButton(btn)
    @btn = btn
  end

 #Cette méthode permet de savoir si le mur est correct
  def estCorrect
    #puts("OK2")
    if(@etatCorrect == CROIX)
      return (@etat == CROIX) || (@etat == VIDE)
    else
      return @etat == @etatCorrect
    end
    puts("OK3")
  end

  #La méthode changerEtat permet de passé à l'état suivant (0-1-2)
  #0  => Vide
  #1  => Rempli
  #2  => Croix
  def changerEtat()
    #Changer l'état du mur
    #mettre à jour le button
    @etat = (@etat+1)%3
    #On affiche le nouvel état
    afficheToi()
  end

  def changerEtatDefini(unEtat)
    #Changer l'état du mur par un etat mis en parametre
    @etat = unEtat%3
    #On affiche le nouvel état
    afficheToi()
  end

  #La méthode revenirEtat fait l'inverse de changerEtat, elle revient à l'état précédent
  def revenirEtat()
    @etat = (@etat-1)%3
    #On affiche le nouvel état
    afficheToi()
  end

  def getEtat
    return @etat
  end



  #La méthode afficheToi permet d'envoyé l'état du mur au Gtk::button attaché au mur
  #Pour afficher différent état sur un bouton, nous utilisons des name sur les buttons.
  #"rien" => Correspond à l'état vide
  #"check"=> Correspond à l'état rempli
  #"croix"=> Correspond à l'état avec une croix
  #cf css/MurPartie.css
  def afficheToi()
    case @etat
    when VIDE
      #On change le name du button à "rien"
      @btn.set_name("rien");
    when REMPLI
      #On change le name du button à "check"
      @btn.set_name("check")
    when CROIX
      #On change le name du button à "croix"
      @btn.set_name("croix");
    end
  end
end
