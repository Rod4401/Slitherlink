require_relative "PopupBase.rb"
require_relative "../Menus/Builder.rb"
##
#La classe PopupVerification est une PopopBase plus spécialisée
#Elle permet de proposer une choix (oui ou non) à l'utilisateur
#Cette classe agit comme une interface Java car elle nécéssite pour la classe appelante de définir 2 méthodes
# => La méthode valider => Appelé dans le cas d'un appui sur valider
# => La méthode refuser => Appelé dans le cas d'un appui sur reffuser

class PopupCheckKo < PopupBase
  #La méthode de classe creer permet d'appeler la méthode new et de rendre cette dernière inutilisable dans le but de rendre le code plus parlant
  def PopupCheckKo.creer(nom_fenetre,appelant, partie)
    new(nom_fenetre,appelant, partie)
  end

  #On rend la méthode de classe new private
  private_class_method :new

  #La méthode initialize permet de définir les paramètres de la popup
  def initialize(nom_fenetre,appelant, partie)
    #On appèle le constructeur de la classe mère
    super(nom_fenetre)
    #On appèle le builder de la PopupVerification
    @builder = Builder.new("PopupCheckKo.glade")
    #On récupère la grille
    @grid=@builder.getGrid()

    #On affecte une image aux 2 Gtk::Button
    @builder.getVar("@btnOui").image = Gtk::Image.new(:file => "Image/valider.png")
    @builder.getVar("@btnNon").image = Gtk::Image.new(:file => "Image/refuser.png")
    #Affichage du nombre d'erreurs
    @builder.getVar("@lblNbErreurs").set_markup(partie.aide.compteErreur.to_s)

    #On affecte un comportement à l'évenement clicked pour le boutton @btnOuin permettant de quitter la partie
    @builder.getVar("@btnOui").signal_connect('clicked'){
      #On demande à l'appelant de revenir avant la première erreur
      partie.retourPremiereErreur
      #On détruit la popup
      self.destroy
    }

    #On affecte un comportement à l'évenement clicked pour le boutton @brnNon permettant de quitter la partie
    @builder.getVar("@btnNon").signal_connect('clicked'){
      #On détruit la popup
      self.destroy
    }

    #On ajoute la grille à la fenetre
    self.add(@grid)
    #On rend visible tous les widgets
    show_all()
  end
end
