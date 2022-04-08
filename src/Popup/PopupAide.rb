require_relative "PopupBase.rb"
require_relative "../Menus/Builder.rb"
##


class PopupAide < PopupBase
  #La méthode de classe creer permet d'appeler la méthode new et de rendre cette dernière inutilisable dans le but de rendre le code plus parlant
  def PopupAide.creer(nom_fenetre, label, chemin_image, chemin_image2)
    new(nom_fenetre ,label, chemin_image, chemin_image2)
  end

  #On rend la méthode de classe new private
  private_class_method :new

  #La méthode initialize permet de définir les paramètres de la popup
  def initialize(nom_fenetre,label, chemin_image, chemin_image2)
    #On appèle le constructeur de la classe mère
    super(nom_fenetre)
    #On appèle le builder de la PopupAide
    @builder = Builder.new("PopupAide.glade")
    #On récupère la grille
    @grid=@builder.getGrid()
    
    #On affiche les images correspondant à la technique applicable
    @builder.getVar("@img1").set_from_file(chemin_image)
    @builder.getVar("@img2").set_from_file(chemin_image2)
    @builder.getVar("@lbl").set_markup(label)

    #@builder.getVar("pu").setText(.......)
    self.add(@grid)
    #On rend visible tous les widgets
    show_all()
  end
end
