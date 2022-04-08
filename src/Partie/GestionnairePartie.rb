#Inclusion du fichier contenant le gestionnaire de partie abstrait
require_relative "../Partie/GestionnairePartieAbstrait.rb"
##
# La classe Jouer représente l'object qui affiche le menu Jouer dans la fenetre du jeu
class GestionnairePartie < GestionnairePartieAbstrait
  # @gestionnaire	=> Le gestionnaire de menu attaché à l'acceuil
  #	@builder	=> Le builder qui instancie les différents widgets du fichier glade
  #	@grid	=> La grille qui contient tous les widgets de l'accueil
  # @difficulte => Niveau de difficulte de la partie
  # @numeroPartie => Numéro de la partie

  #Méthode de classe qui permet de reinitialiser les scores d'un profil
  def GestionnairePartie.resetScore(difficulte,numeroPartie,name)
    #Effacement de la sauvegarde de la partie
    begin
      File.delete(DIR_SAVE+"#{difficulte}/#{name}.#{numeroPartie}.save")
    rescue
      puts "File inexistante"
    end
    #Effacement des quicksaves de la partie
    0.upto(3){|i|
      begin
        File.delete(DIR_QUICKSAVE+"#{name}.#{difficulte}.#{numeroPartie}.#{i}.save")
      rescue
        #puts "File inexistante"
      end
    }
  end

  #La méthode de classe creer permet d'appeler la méthode new et de rendre cette dernière inutilisable dans le but de rendre le code plus parlant
  def GestionnairePartie.creer(gestionnaire,difficulte,numeroPartie)
    new(gestionnaire,difficulte,numeroPartie)
  end

  #On rend la méthode de classe new private
  private_class_method :new

  attr_reader :gestionnaire

  #Méthode initialize permet de charger une partie à l'écran en créant tous les évenements aux différents widgets
  def initialize(gestionnaire,difficulte,numeroPartie)
    @difficulte = difficulte
    @numeroPartie = numeroPartie

    #On appèle le builder avec le fichier correspondant
    @builder = Builder.new("Partie.glade")

    #On appèle la méthode initialize de la superClasse
    super(gestionnaire)

    #On attache au gestionnaire de Menu, le gestionnaire de Partie pour pouvoir stopper une partie si on clique sur la croix de la fenetre
    @gestionnaire.setGestioPartie(self)


    #On défini à 700 par 700 la taille de la grille du jeu
    @builder.getVar("@grilleJeu").set_size_request(700,700)



    #On affecte un comportement à l'évenement clicked pour le boutton @btnMenuCheck
    @builder.getVar("@btnMenuCheck").signal_connect('clicked'){
      if(@partie.check)
        @partie.stop
        PopupCheckOk.creer("Victoire", self, @partie)
      else
        PopupCheckKo.creer("Essaie encore", self, @partie)
      end
    }

    @builder.getVar("@btnMenuAide").signal_connect('clicked'){
      @partie.getAide().chercherTechniqueApplicable()
    }


    #On affecte un comportement à l'évenement clicked pour le boutton @btnMenuParametres
		#@builder.getVar("@btnMenuParametres").signal_connect('clicked') {
    #  options = Options.creer(@gestionnaire,self)
    #  options.retirerFonctionsCritiques(@partie.autoCompletion)
		#	@gestionnaire.changerMenu(options)
		#
    #}


    #Charger / Creer Partie
    chargerPartie()
    actualiseAffichage()
    #puts "démarage de la partie"
    @partie.run
  end

  #Méthode qui renvoie le bouton (Gtk::Button) de coordonnée x,y
  def getButton(x,y)
    @builder.getVar("@btnMur_#{x}_#{y}")
  end

  attr_reader :partie, :gestionnaire

  #Méthode qui charge en mémoire la partie
  #Si aucune partie associé à cette partie existe alors on en créer une nouvelle
  def chargerPartie()
    begin
      file = File.open(DIR_SAVE+"#{@difficulte}/#{@gestionnaire.getProfilActif().name()}.#{@numeroPartie}.save","r")
      string = file.read()
      @partie = YAML.load(string)
      #On connecte le gestionnaire de partie à la partie
      @partie.connect(self)
      file.close
    rescue
      #Si on a pas reussi à load l'ancienne partie
      #puts "echec ouverture => " + e.message
      #puts "Création partie"
      @partie = Partie.creer(self,@numeroPartie,@difficulte,gestionnaire.getProfilActif.autoCompletion)
    end
    #puts "Création partie reussi"
    begin
      #On charge le plateau 0
      @partie.loadPlateau(0)
    rescue
      raise PartieChargerError.new "Impossible de charger le plateau 0"
    end
    chargerCases()
  end


  #Méthode pour mettre fin à la partie
  def arreterPartie()
    #On coupe le compteur de temps de la partie
    @partie.stop()
    #On sauvegarde le score ainsi que le temps du profil actif
    @gestionnaire.getProfilActif.setScore(@difficulte,@numeroPartie,@partie.calculerScore,@partie.getTemps)
    #on sauvegarde la partie
    self.sauvegardePartie()
    #On déconnecte la partie
    @partie.connect(nil)
    #On retourne à l'accueil
    @gestionnaire.changerMenu(Accueil.creer(@gestionnaire))
  end


  #Méthode qui sauvegarde la partie dans le fichier correspondant
  def sauvegardePartie()
    begin
      #Déconnexion du gestionnaire de partie à la partie
      @partie.connect(nil)
      #On déconnecte également le plateau (Pour ne pas le sauvegardé 2 fois)
      @partie.plateau = nil
      #string = Marshal.dump(@partie)
      string = @partie.to_yaml()
      #On reconnecte le gestionnaire de partie
      @partie.connect(self)
      #On connecte le plateau 0 (courant) à la partie
      @partie.loadPlateau(0)
      file = File.open(DIR_SAVE+"#{@difficulte}/#{@gestionnaire.getProfilActif().name()}.#{@numeroPartie}.save","w")
      file.write(string)
      file.close
    rescue => e
      puts "Partie nulle " + e.message
    end

  end
  
    #Méthode permettant de recommencer une partie
    def recommencerPartie()
      #On sauvegarde le score ainsi que le temps du profil actif
      @gestionnaire.getProfilActif.setScore(@difficulte,@numeroPartie,@partie.calculerScore,@partie.getTemps)
      #On réinitialise la partie
      @partie.reinitialiser()
      #On actualise l'affichage
      afficherCoups()
      actualiseAffichage()
      #On démarre la nouvelle partie
      @partie.run()
    end

end
