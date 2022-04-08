require_relative "PopupBase.rb"
##
#La classe PopupText est une PopopBase plus spécialisée
#Elle permet d'afficher du texte dans la popup
#Crée et génère une fenêtre popup, on renseigne dans le champ text le texte à afficher à l'écran

class PopupText < PopupBase
  #La méthode de classe creer permet d'appeler la méthode new et de rendre cette dernière inutilisable dans le but de rendre le code plus parlant
  def PopupText.creer(nom_fenetre,text)
    new(nom_fenetre,text)
  end

  #On rend la méthode de classe new private
  private_class_method :new

  #La méthode initialize permet de définir les paramètres de la popup
  def initialize(nom_fenetre,text)
    #On appèle le constructeur de la classe mère
    super(nom_fenetre)
    #On ajoute le Gtk::Label à la fenetre
    add(Gtk::Label.new(text, {:use_underline => true}))
    #On rend visible tous les widgets
    show_all()
  end
end
