##
# La classe Profils représente l'object qui affiche le menu regles et techniques dans la fenetre du jeu
class Regles_Techniques < Menu
  # @gestionnaire	=> Le gestionnaire de menu attaché à ce menu
  #	@builder	=> Le builder qui instancie les différents widgets du fichier glade
  #	@grid	=> La grille qui contient tous les widgets de ce menu

  #La méthode de classe creer permet d'appeler la méthode new et de rendre cette dernière inutilisable dans le but de rendre le code plus parlant
  def Regles_Techniques.creer(gestionnaire)
    new(gestionnaire)
  end

  #On rend la méthode de classe new private
  private_class_method :new

  #Méthode initialize permet de charger le menu des regles et techniques à l'écran en créant tous les évenements aux différents widgets
  def initialize(gestionnaire)
    #On appèle le builder avec le fichier correspondant
    @builder = Builder.new("Regles_Techniques.glade")

    #On appèle la méthode initialize de la superClasse
    super(gestionnaire)

    #On change le nom de la fenetre
		@gestionnaire.changerNom("-Règles et Techniques")

    #On affecte un comportement à l'évenement clicked pour le boutton @btnRetour
    @builder.getVar("@btnRetour").signal_connect('clicked') {
      @gestionnaire.changerMenu(Accueil.creer(@gestionnaire))
    }

    #On affecte un comportement à l'évenement clicked pour le boutton @btnRegle
    @builder.getVar("@btnRegle").signal_connect('clicked') {
      @gestionnaire.changerMenu(Regles.creer(@gestionnaire))
    }

    #On affecte un comportement à l'évenement clicked pour le boutton @btnTech
    @builder.getVar("@btnTech").signal_connect('clicked') {
      @gestionnaire.changerMenu(Techniques.creer(@gestionnaire))
    }
  end
end
