##
# La classe Menu est abstraite, elle permet de définir des comportements communs aux menus
class Menu < Gtk::Box
  # @gestionnaire	=> Le gestionnaire de menu attaché à ce menu
  #	@builder	=> Le builder qui instancie les différents widgets du fichier glade
  #	@grid	=> La grille qui contient tous les widgets de ce menu

  def initialize(gestionnaire)
    super(:horizontal)
    @gestionnaire = gestionnaire
    #On récupère la grille
    @grid=@builder.getGrid()
    #On affecte le theme (css) à l'ensemble des widgets
    @builder.changerTheme(@gestionnaire.getTheme)

    #On ajoute la grid dans cette instance
    self.pack_start(@grid)
    #On rend l'accueil homogène
    self.set_homogeneous(true)
    #On affiche cette instance dans la fenetre
    @gestionnaire.changerMenu(self)
  end
end
