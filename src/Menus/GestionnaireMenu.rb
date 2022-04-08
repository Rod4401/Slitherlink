#Incusion du Builder pour pouvoir générer les variables d'instances à partir d'un fichier glade
require_relative "Builder.rb"
#Incusion des différents fichiers nécéssaires au jeu
require_relative "Menu.rb"
require_relative "Campagne.rb"
require_relative "Accueil.rb"
require_relative "APropos.rb"
require_relative "Jouer.rb"
require_relative "Modes.rb"
require_relative "Profils.rb"
require_relative "Options.rb"
require_relative "Regles_Techniques.rb"
require_relative "Regles.rb"
require_relative "Techniques.rb"
require_relative "Tutoriel.rb"
require_relative "TutoImage.rb"
require_relative "Classement.rb"
#require_relative "TutoInter.rb"

require_relative "../Popup/PopupBase.rb"
require_relative "../Popup/PopupText.rb"
require_relative "../Profils/Profil.rb"
require_relative "../Profils/GestionnaireProfils.rb"
#####################################################
#Constante correspondant au fichier de sauvegarde des profils
FILE_SAVE_PROFILS = "Profils/profils.save"
#Constante correspondant au fichier du logo de la fenetre
FILE_ICON = "Image/logo.png"
#Constante correspondant au dossier des css
DIR_CSS = "../src/css/"

THEME_WHITE = 0
THEME_DARK = 1

##
# La classe Jouer représente l'object qui affiche le menu Jouer dans la fenetre du jeu
class GestionnaireMenu
  # @window	=> La fenetre du jeu
  #	@gestionnairePartie	=> Le gestionnaire de partie rattaché au gestionnaire de menu dans le cas où une partie est en cours
  #	@grid	=> La grille qui contient tous les widgets de l'accueil
  # @difficulte => Niveau de difficulte de la partie
  # @numeroPartie => Numéro de la partie

  #La méthode de classe creer permet d'appeler la méthode new et de rendre cette dernière inutilisable dans le but de rendre le code plus parlant
  def GestionnaireMenu.creer
    new()
  end

  #On rend la méthode de classe new private
  private_class_method :new

  #Méthode initialize permet de créer la fenetre et d'appeler l'accueil du jeu
  def initialize
    #On créer la fenetre
    @window = Gtk::Window.new
    #On affecte un comportement à l'évenement destroy pour la fenetre
    @window.signal_connect('destroy') {
      #Si une partie est en cours
      if(@gestionnairePartie != nil && @gestionnairePartie.partie != nil)
        #On arrete la partie
        @gestionnairePartie.arreterPartie()
      end
      #On sauvegarde les profils
      sauvegarderProfils()
      #On coupe gtk ce qui implique la fin du jeu
      Gtk.main_quit
    }
    @gestionnairePartie = nil

    #On place la fenetre au centre
    @window.window_position=:center_always

    #On rend la fenetre non redimentionnable
    @window.resizable=false
    #On la redimentionne à la bonne taille
    redimentioner()

    #On défini le titre de la fenetre
    changerNom("")
    #On affecte l'icone à la fenetre
    @window.icon=FILE_ICON
    #On adéfini la taille par défaut de la fenetre
    #@window.set_default_size(700, 800)
    #On charge les profils
    chargerProfils()
    #On affiche l'accueil
    changerMenu(Accueil.creer(self))
    #On change le thème
    changerTheme(getProfilActif().theme)
    end

  #Méthode qui redimentionne la fenetre
  def redimentioner()
    #puts "redimentioner"
    @window.set_size_request(700, 600)
  end

  def redimensionner_withsize(l1,l2)
    @window.set_size_request(l1,l2)
  end

  #Méthode qui attache le gestionnaire de partie de au gestionnaire de menu
  def setGestioPartie(gestio)
    @gestionnairePartie = gestio
  end

  #Méthode qui change le menu actuel par celui qui est passé en paramètre
  def changerMenu(menuAff)
    @window.each { |child|
      @window.remove(child)
    }
    @window.add(menuAff)
    @window.show_all
  end

  #Méthode qui change le thème en fonction de celui qui est séléctionné
  def changerTheme(theme)
    @provider = Gtk::CssProvider.new
    if (theme == 0)
      @provider.load(path: DIR_CSS+"white.css")
    elsif (theme == 1)
      @provider.load(path: DIR_CSS+"dark.css")
    end
    @window.style_context.add_provider(@provider, Gtk::StyleProvider::PRIORITY_USER)
    getProfilActif().theme=theme
  end

  #Méthode qui permet d'obtenir le thème actuel
  def getTheme()
    @provider
  end

  #Méthode qui permet d'obenir l'id du thème selectionné
  def getThemeId()
    getProfilActif().theme
  end

  ################################
  # => Partie Profils
  ################################
  #Méthode qui permet de changer le profil actif
  def setProfilActif(user)
    @gestionnaireProfils.setProfilActif(user)
  end

  #Méthode qui permet d'obtenir le profil actif
  def getProfilActif()
    @gestionnaireProfils.getProfilActif()
  end

  #Méthode qui permet de créer un nouveau profil
  def creerProfileUtilisateur(name)
    @gestionnaireProfils.nouveauProfil(name)
  end

  #Méthode qui permet de supprimer un profil
  def supprimerProfil()
    @gestionnaireProfils.supprimerProfil()
  end

  #Méthode qui permet d'obenir une liste de tous les profils
  def listeProfils()
    @gestionnaireProfils.listeProfils
  end

  #Méthode qui renvoie le nombre total de profil
  def getNbProfils()
    @gestionnaireProfils.getNbProfils
  end

  #Méthode qui permet de charger le gestionnaire de profil
  def chargerProfils
    begin
      #On ouvre le fichier de save des profils
      file = File.open(FILE_SAVE_PROFILS,"r")
      #On récupère la chaine de caractères
      string = file.read()
      #On load Marshal pour récupérer le gestionnaire des profils
      @gestionnaireProfils = Marshal.load(string)
      #puts "Ouverture du fichier de save profil"
    rescue
      #Aucune sauvegarde de profil trouvé
      #Création du fichier
      file = File.open(FILE_SAVE_PROFILS,"w")
      @gestionnaireProfils = GestionnaireProfils.creer()
      sauvegarderProfils()
    ensure
      file.close
    end
  end

  #Méthode qui permet de sauvegarder les profils
  def sauvegarderProfils
    @gestionnaireProfils.sauvegardeToi()
  end

  #Méthode qui permet de changer le nom de la fenetre
  def changerNom(name)
    @window.title="Slitherlink"+name
  end

end
