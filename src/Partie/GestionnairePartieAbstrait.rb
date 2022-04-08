#Inclusion du fichier contenant le module Difficulte
require_relative "../Modules/Difficulte.rb"
#Inclusion de la classe Partie pour pouvoir lancer une partie
require_relative "../Partie/Partie.rb"
#Inclusion de la classe Partie pour pouvoir lancer une partie
require_relative "../Error/PartieChargerError.rb"
#Inclusion de yaml pour pouvoir sérialiser une partie
require 'yaml'
require_relative '../Popup/PopupCheckOk.rb'
require_relative '../Popup/PopupCheckKo.rb'
#Constante correspondant au dossier des saves

DIR_SAVE = "Saves/"

NB_CASES_FACILE=5
NB_CASES_MOYEN=8
NB_CASES_DIFFICILE=10
NB_CASES_CLM = 8

class GestionnairePartieAbstrait < Menu
  #On inclue le module Difficulte dans la classe
  include Difficulte

  def initialize(gestionnaire)
    #On appèle le builder avec le fichier correspondant
    @builder = Builder.new("Partie.glade")

    super(gestionnaire)

    #On demande au builder de générer la grille en fonction de la difficulté
    @nbCases = to_i(@difficulte,NB_CASES_FACILE,NB_CASES_MOYEN,NB_CASES_DIFFICILE,NB_CASES_CLM)
    @sizeCases = to_i(@difficulte,120,70,50,70)
    @cssCase = to_i(@difficulte,"CasePartieFacile.css","CasePartieNormale.css","CasePartieDifficile.css","CasePartieNormale.css")
    @cssCaseDark = to_i(@difficulte,"CasePartieFacileDark.css","CasePartieNormalDark.css","CasePartieDifficileDark.css","CasePartieNormalDark.css")
    if(@gestionnaire.getThemeId == THEME_DARK)
      @builder.genererGrille(@nbCases,@sizeCases,@cssCaseDark,@gestionnaire.getThemeId)
    elsif(@gestionnaire.getThemeId == THEME_WHITE)
      @builder.genererGrille(@nbCases,@sizeCases,@cssCase,@gestionnaire.getThemeId)
    end

    css_menu = Gtk::CssProvider.new
    css_menu.load(path: DIR_CSS+"MenuPartie.css")

    @builder.getVar("@btnMenuQuitter").style_context.add_provider(css_menu, Gtk::StyleProvider::PRIORITY_USER)
    @builder.getVar("@btnMenuPrec").style_context.add_provider(css_menu, Gtk::StyleProvider::PRIORITY_USER)
    @builder.getVar("@btnMenuAide").style_context.add_provider(css_menu, Gtk::StyleProvider::PRIORITY_USER)
    @builder.getVar("@btnMenuRestart").style_context.add_provider(css_menu, Gtk::StyleProvider::PRIORITY_USER)
    #@builder.getVar("@btnMenuRegles").style_context.add_provider(css_menu, Gtk::StyleProvider::PRIORITY_USER)
    @builder.getVar("@btnMenuCheck").style_context.add_provider(css_menu, Gtk::StyleProvider::PRIORITY_USER)

    #A tous les bouttons de l'interface de la partie on associe le css (css_menu)
    #On défini un nom selon l'événement pour donner un effet de clique sur le boutton (cf : MenuPartie.css)
    #@builder.getVar("@btnMenuParametres").style_context.add_provider(css_menu, Gtk::StyleProvider::PRIORITY_USER)
    @builder.getVar("@btnQuickSaveSave1").style_context.add_provider(css_menu, Gtk::StyleProvider::PRIORITY_USER)
    @builder.getVar("@btnQuickSaveSave2").style_context.add_provider(css_menu, Gtk::StyleProvider::PRIORITY_USER)
    @builder.getVar("@btnQuickSaveSave3").style_context.add_provider(css_menu, Gtk::StyleProvider::PRIORITY_USER)
    @builder.getVar("@btnQuickSaveLoad1").style_context.add_provider(css_menu, Gtk::StyleProvider::PRIORITY_USER)
    @builder.getVar("@btnQuickSaveLoad2").style_context.add_provider(css_menu, Gtk::StyleProvider::PRIORITY_USER)
    @builder.getVar("@btnQuickSaveLoad3").style_context.add_provider(css_menu, Gtk::StyleProvider::PRIORITY_USER)


    #Affectation des images correspondantes aux différents bouttons de l'interface d'une partie
    @builder.getVar("@btnMenuQuitter").image = Gtk::Image.new(:file => DIR_IMG+"btn/quitter.png")
    @builder.getVar("@btnMenuPrec").image = Gtk::Image.new(:file => DIR_IMG+"btn/precedent.png")
    @builder.getVar("@btnMenuAide").image = Gtk::Image.new(:file => DIR_IMG+"btn/aide.png")
    @builder.getVar("@btnMenuRestart").image = Gtk::Image.new(:file => DIR_IMG+"btn/reset.png")
    #@builder.getVar("@btnMenuRegles").image = Gtk::Image.new(:file => DIR_IMG+"btn/regles.png")
    @builder.getVar("@btnMenuCheck").image = Gtk::Image.new(:file => DIR_IMG+"btn/valider.png")
    #@builder.getVar("@btnMenuParametres").image = Gtk::Image.new(:file => DIR_IMG+"btn/parametres.png")

    @builder.getVar("@btnQuickSaveSave1").image = Gtk::Image.new(:file => DIR_IMG+"btn/enregistrer.png")
    @builder.getVar("@btnQuickSaveSave2").image = Gtk::Image.new(:file => DIR_IMG+"btn/enregistrer.png")
    @builder.getVar("@btnQuickSaveSave3").image = Gtk::Image.new(:file => DIR_IMG+"btn/enregistrer.png")

    @builder.getVar("@btnQuickSaveLoad1").image = Gtk::Image.new(:file => DIR_IMG+"btn/load.png")
    @builder.getVar("@btnQuickSaveLoad2").image = Gtk::Image.new(:file => DIR_IMG+"btn/load.png")
    @builder.getVar("@btnQuickSaveLoad3").image = Gtk::Image.new(:file => DIR_IMG+"btn/load.png")

    #Affectation des bouttons de quicksave
    @builder.getVar("@btnQuickSaveSave1").signal_connect('clicked') {
      @partie.savePlateau(1)
    }
    @builder.getVar("@btnQuickSaveLoad1").signal_connect('clicked') {
      @partie.loadPlateau(1)
    }
    @builder.getVar("@btnQuickSaveSave2").signal_connect('clicked') {
      @partie.savePlateau(2)
    }
    @builder.getVar("@btnQuickSaveLoad2").signal_connect('clicked') {
      @partie.loadPlateau(2)
    }
    @builder.getVar("@btnQuickSaveSave3").signal_connect('clicked') {
      @partie.savePlateau(3)
    }
    @builder.getVar("@btnQuickSaveLoad3").signal_connect('clicked') {
      @partie.loadPlateau(3)
    }



    #On affecte un comportement à l'évenement clicked pour le boutton @btnMenuQuitter
    @builder.getVar("@btnMenuQuitter").signal_connect('clicked') {
      self.arreterPartie()
    }

    #On affecte un comportement à l'évenement clicked pour le boutton @btnMenuPrec
    @builder.getVar("@btnMenuPrec").signal_connect('clicked'){
      #Revenir au coup précédent
      @partie.dejouerCoup
      afficherCoups()
    }


        #On affecte un comportement à l'évenement clicked pour le boutton @btnMenuRestart
        @builder.getVar("@btnMenuRestart").signal_connect('clicked'){
          #Remise à 0 du plateau
          @partie.raz
          afficherCoups()
        }

        #On scanne tous les boutons (Gtk::Button) pour leur associer le comportement (jouer()) au mur qu'il lui est destiné
        # ex : le mur en 0-1 est relié au bouton (Gtk::Button) 0-1
        begin
          #On récupère la taille du plateau (le nombre de cases)
          taille = to_i(@difficulte,NB_CASES_FACILE,NB_CASES_MOYEN,NB_CASES_DIFFICILE,NB_CASES_CLM)
          0.upto(taille*2){ |x|
            0.upto(taille*2){ |y|
              #Si ce n'est pas un mur on passe au suivant
              next if ((x%2 == 1 && y%2 == 1) || (x%2 == 0 && y%2 == 0) )
              @builder.getVar("@btnMur_#{x}_#{y}").signal_connect('clicked'){
                @partie.jouerCoup(x,y)
                afficherCoups()
              }
            }
          }
        rescue => e
          #Si on a une erreur
          #Ici la seule erreur c'est qu'un bouton n'a pas été généré
          puts e.message
        end

  end

  #Méthode qui affiche le temps dans le label correspodant et actualise le score en fonction
  #Cette méthode est appelée par le compteur de temps de la partie
  def afficheTemps(s,m,h,j)
    puts "#{s} #{m}"
    chaine = ""
    #Ajoue des jours à la chaine
    if j >= 1
      chaine += j.to_s + "j "
    end

    #Ajoue des heures à la chaine
    if h >= 1
      chaine += h.to_s + "h "
    end

    #Ajoue des minutes à la chaine
    if m >= 1
      chaine += m.to_s + "m "
    end

    #Ajoue des secondes à la chaine
    chaine += s.to_s + "s "

    @builder.getVar("@lblTps").set_markup(chaine)

    afficherScore()
  end

  #Méthode qui affiche le nombre de coups joués
  def afficherCoups()
    @builder.getVar("@lblNbCoup").set_markup(@partie.getNbCoups.to_s)
  end

  #Méthode qui envoie le message affiche toi à tous les murs
  #Ici elle ne fait que passer le message à la classe compétente
  def actualiseAffichage()
    @partie.actualiseAffichage()
    afficherCoups()
  end

  #Méthode qui affiche le score total actuel
  def afficherScore()
    @builder.getVar("@lblNbPts").set_markup(@partie.calculerScore.to_s)
  end

  #Méthode qui renvoie le bouton (Gtk::Button) de coordonnée x,y
  def getButton(x,y)
    @builder.getVar("@btnMur_#{x}_#{y}")
  end

  #On affecte les valeurs des cases aux différents widgets (Gtk::Label)
  def chargerCases()
    #On récupère la liste des cases
    liste = @partie.getCases()
    #On calcul la taille c'est-à-dire le nombre de case
    taille = to_i(@difficulte,NB_CASES_FACILE,NB_CASES_MOYEN,NB_CASES_DIFFICILE, NB_CASES_CLM)
    #Un plateau de 2 cases contient 5*5 éléments:
    #X X X X X
    #X C X C X
    #X X X X X
    #X C X C X
    #X X X X X
    #Donc pour n cases on a (n*2+1) par (n*2+1) éléments

    0.upto(taille*2){|x|
      0.upto(taille*2){|y|
        #A moins que ce ne soit pas une cases on next
        next unless (x%2 == 1 && y%2 == 1)
        #Ici liste[x][y] est forcément une case
        if(liste[x][y].numero >= 0)
          #Si elle possède un numéro supérieur à 0 (différent de -1)
          #On écrit sa valeur dans le Gtk::Label correspondant
          @builder.getVar("@lblCase_#{x}_#{y}").set_markup(liste[x][y].numero.to_s)
        else
          #Si elle vaut -1 on écrit rien
          #-1 correspond à une case vide
          @builder.getVar("@lblCase_#{x}_#{y}").set_markup("")
        end
      }
    }
  end
end
