#Inclusion du fichier contenant le gestionnaire de partie abstrait
require_relative "../Partie/GestionnairePartieAbstrait.rb"

class GestionnairePartieMode < GestionnairePartieAbstrait
  def GestionnairePartieMode.creer(gestionnaire)
    new(gestionnaire)
  end
  attr_reader :gestionnaire
  def initialize(gestionnaire)

    @difficulte = CONTRE_LA_MONTRE
    @limiteur = 600
    super(gestionnaire)


    #Pas de check
    @builder.getVar("@btnMenuCheck").set_child_visible(false)

    #On défini à 700 par 700 la taille de la grille du jeu
    @builder.getVar("@grilleJeu").set_size_request(700,700)

    #On affecte un comportement à l'évenement clicked pour le boutton @btnMenuRestart
    @builder.getVar("@btnMenuRestart").signal_connect('clicked'){
      #Remise à 0 du plateau
      @partie.raz
      afficherCoups()
    }

    #On affecte un comportement à l'évenement clicked pour le boutton @btnMenuCheck
    @builder.getVar("@btnMenuCheck").signal_connect('clicked'){
      if(@partie.check)
        @partie.stop
        #FAIRE UNE AUTRE PARTIE
        PopupCheckOk.creer("Victoire", self, @partie)
      else
        PopupCheckKo.creer("Essaie encore", self)
      end
    }


    @builder.getVar("@tp").set_markup("Total partie validées")
    #Le nombre de grille validées
    @nbGrillesValidees = -1

    @builder.getVar("@lblNbPts").set_markup("#{@nbGrillesValidees}")

    partieSuivante()

    masquerParametres()

  end

  def partieSuivante()
    @partie = Partie.creer(self,0,CONTRE_LA_MONTRE,false,false)
    @partie.limiteur(@limiteur)
    @partie.loadPlateau(0)
    chargerCases()
    @partie.run
    @nbGrillesValidees +=1
    actualiseAffichage()
  end

  #Méthode qui affiche le nombre d'aides utilisées
  #def afficherNbAides()
  #  @builder.getVar("@lblNbAides").set_markup(@partie.getNbAides.to_s)
  #end

  #Méthode qui affiche le score total actuel
  def afficherScore()
    @builder.getVar("@lblNbPts").set_markup("#{@nbGrillesValidees}")
  end


  #Méthode pour mettre fin à la partie
  def arreterPartie()
    #On coupe le compteur de temps de la partie
    @partie.stop()
    #On déconnecte la partie
    @partie.connect(nil)
    #On retourne à l'accueil
    @gestionnaire.changerMenu(Accueil.creer(@gestionnaire))
  end

  def masquerParametres
    @builder.getVar("@boxIndicesRestants").set_child_visible(false)
    @builder.getVar("@boxNbIndicesRestants").set_child_visible(false)
    @builder.getVar("@lblQuickSave").set_child_visible(false)
    @builder.getVar("@boxQuickSaves1").set_child_visible(false)
    @builder.getVar("@boxQuickSaves2").set_child_visible(false)
    @builder.getVar("@boxQuickSaves3").set_child_visible(false)
  end


  def valider
    arreterPartie()
  end

  def refuser
    arreterPartie()
  end

end
