#Incusion des différents fichiers nécéssaires à une partie
require_relative 'Aide.rb'
require_relative 'Case.rb'
require_relative 'Coup.rb'
require_relative 'CoupVersEtat.rb'
require_relative 'Mur.rb'
require_relative 'Plateau.rb'
require_relative 'Temps.rb'
require_relative "../Error/PlateauCreationError.rb"
##########################################################

#Constante correspondant au fichier des quicksaves
DIR_QUICKSAVE = "Saves/quickSaves/"

##
#La classe partie permet de représenter une partie sans l'affichage, c'est une sorte de cœur de partie
class Partie
  #@gestionnairePartie  => Le gestionnaire de partie relié à cette partie
  #@numero  => Le numero de la partie
  #@difficulte  => Le niveau de difficulté de la partie
  #@compteurTemps => Le compteur de temps relié à cette partie
  #@autoCompletion => Boolean défini lors de la création de la partie et ne peut être modifier
  #@nbCoup => nombre de coups jouer


  #La méthode de classe creer permet d'appeler la méthode new et de rendre cette dernière inutilisable dans le but de rendre le code plus parlant
  def Partie.creer(gestionnairePartie,numPartie,difficulte,autoCompletion, sauvegarder = true)
    new(gestionnairePartie,numPartie,difficulte,autoCompletion, sauvegarder)
  end

  #On rend la méthode de classe new private
  private_class_method :new

  #Coding assistant
  attr_reader :autoCompletion, :compteurTemps, :aide

  #La méthode initialize permet de définir les variables d'instances
  def initialize(gestionnairePartie,numPartie,difficulte,autoCompletion,sauvegarder)
    #Le gestionnaire qui permet entre autres l'accès à la fenetre
    @gestionnairePartie = gestionnairePartie
    @numero = numPartie
    @difficulte = difficulte #easy normal difficile
    @compteurTemps = Temps.creer
    @autoCompletion = autoCompletion
    @aide = Aide.creer(self)
    @nbCoup = 0
    @nbAides = 0
    @sauvegarder = sauvegarder
    #puts "Partie créée"
    @limiteur = -1
  end

  #Coding assistant
  attr_reader :numero, :niveau, :gestionnairePartie, :difficulte
  attr_accessor :plateau

  #La méthode run permet de lancer le compteur de temps
  #Elle permet de lancer une partie
  def run
    @compteurTemps.run(@gestionnairePartie)
  end

  #La méthode stop à pour but de stoper une partie
  #Particulièrement elle coupe le thread qui compte le temps (pour éviter un zombie)
  #Et elle decconecte tous les Gtk::button des murs du plateau
  def stop
    @compteurTemps.kill
    @plateau.deloadButton()
  end

  #La méthode connect permet de conntecter le gestionnaire de partie à la partie
  def connect(obj)
    @gestionnairePartie=obj
  end

  #La méthode arreterPartie permet de prévenier le gestionnaire de partie de stopper la partie
  def arreterPartie()
    @gestionnairePartie.arreterPartie()
  end

  #La méthode getCases permet de renvoyer la liste des cases du plateau
  def getCases()
    @plateau.getCases
  end

  #Methode qui permet de definir une limite de temps pour le compteur
  def limiteur(nombre_secondes)
    @compteurTemps.limiteur(nombre_secondes)
    @limiteur = nombre_secondes
  end


  #La méthode loadPlateau permet de charger dans le jeu un plateau
  #Notre partie se compose d'un plateau principal (le 0)
  #Et peut charger jusqu'à 3 quicksave qui sont les plateau (1-2-3)
  def loadPlateau(numero_plateau)
    ##################################
    # => Ouverture du fichier de sauvegarde du plateau
    # => Ex : partie 2 easy de "User" save 0
    # => "../quickSaves/difficulte.User.2.0.save"
    ##################################
    begin
      #Onverture du fichier correspondant au plateau demandé
      file = File.open(DIR_QUICKSAVE+"#{@gestionnairePartie.gestionnaire.getProfilActif().name()}.#{@difficulte}.#{@numero}.#{numero_plateau}.save","r")
      #On récupère l'intégralité du fichier
      string = file.read()
      #YAML s'occupe de recréer le plateau
      @plateau = YAML.load(string)
      #On reconnecte la partie au plateau
      @plateau.connect(self)
      #On ferme de descripteur de fichier
      file.close
    rescue
      #Si pas réussi à load la 0 alors on charge celui par default
      if(numero_plateau == 0)
        #Si la partie veut charger le plateau 0 c'est qu'on souhaite créer un nouvelle partie
        #dans le cas où on a pas réussi à trouver le fichier du plateau 0
        #puts "Création plateau : "+e.message
        begin
          #puts "Création"
          #On créer un nouveau plateau
          @plateau = Plateau.creer(self)
        rescue
          #Si la création a engendré une erreur alors on génère l'exception PlateauCreationError
          raise PlateauCreationError.new
        end
      else
        #Si on souhaite chargé le plateau 1 - 2 - 3 mais qu'il ne trouve pas leur fichier
        #c'est qu'on a pas créer de quicksave correspodante donc on ne fait rien
        return true
      end
    ensure
      #Une fois qu'on a chager le plateau ou créer le plateau 0 on peut reconnecter les Gtk::button
      #puts "reloadButton"
      @plateau.reloadButton()
      #On actualise l'affichage pour afficher l'état de chaque mur
      @gestionnairePartie.actualiseAffichage()
    end
  end

  #La méthode savePlateau permet de sauvegarder un plateau
  #Comme pour la méthode loadPlateau, il y a 4 plateau possibles:
  #0  => Plateau courrant
  #1-2-3  => Les 3 quicksaves
  def savePlateau(numero_plateau)
    if(!@sauvegarder)
      return
    end
    begin
      #On ouvre le fichier correspodant au plateau (numero_plateau) en écriture
      file = File.open(DIR_QUICKSAVE+"#{@gestionnairePartie.gestionnaire.getProfilActif().name()}.#{@difficulte}.#{@numero}.#{numero_plateau}.save","w")
    rescue => e
      if (e.class.to_s == "Errno::ENOENT")
      #Exception obtenu si le dossier des quicksaves n'éxiste pas
      #Création du dossier des quicksaves
      Dir.mkdir(DIR_QUICKSAVE)
      #On ouvre le fichier correspodant au plateau (numero_plateau) en écriture
      file = File.open(DIR_QUICKSAVE+"#{@gestionnairePartie.gestionnaire.getProfilActif().name()}.#{@difficulte}.#{@numero}.#{numero_plateau}.save","w")
      end
    end

    #On déconnecte tous les Gtk::Button des murs
    @plateau.deloadButton()
    #On déconnecte la partie du plateau
    @plateau.connect(nil)
    #On demande à yaml de sérialiser
    string = @plateau.to_yaml
    #On reconnecte la partie au plateau
    @plateau.connect(self)
    #On reconnecte tous les Gtk::Button des murs
    @plateau.reloadButton()
    #On écrit dans le fichier le résultat de Marshal
    file.write(string)
    #On ferme le descripteur de fichier
    file.close
  end

  #La méthode jouerCoup permet de faire jouer un coup, elle transmet le message au plateau et lance une sauvegarde du platau courant
  def jouerCoup(x,y)
    begin
      if(@limiteur <= getTemps && @limiteur != -1)
        arreterPartie
        return
      end
    rescue
    end
    #puts "je joue #{x} #{y}"
    #Joue le coup en coordonnées x;y

    if(@plateau.jouerCoup(x,y))
      @nbCoup += 1
    end
    if(@autoCompletion)
      listeCase = @plateau.caseAdjacente(x,y)
      if(listeCase != nil)
        for uneCase in listeCase
          uneCase.completeToi(y,x)
        end
      end
    end
    #Lance la sauvegarde du plateau courant
    savePlateau(0)
    #On scanne le plateau pour connaitre l'avancement
    @aide.checkAll
    if(@aide.compteErreur == 0)
      self.savePlateau(4)
    end
  end

  #La méthode dejouerCoup permet de faire dejouer un coup, elle transmet le message au plateau et lance une sauvegarde du platau courant
  def dejouerCoup()
    #Dejoue le coup en coordonnées x;y
    @plateau.dejouerCoup()
    #Lance la sauvegarde du plateau courant
    savePlateau(0)
  end

  #La méthode raz permet de faire dejouer tous les coups
  #La méthode dejouerCoup renvoie false si aucun coup existe
  #La méthode se contente donc de faire dejouer tant que dejouerCoup renvoie vrai
  def raz()
    etat = true
    while(etat)
      etat = @plateau.dejouerCoup()
    end
    #Lance la sauvegarde du plateau courant
    savePlateau(0)
  end

  #La méthode sauvegardeToi transmet à la classe compétente c'est-à-dire le gestionnaire de partie de sauvegarder la partie
  def sauvegardeToi()
    @gestionnairePartie.sauvegardePartie()
  end

  #La méthode actualiseAffichage permet de mettre à jouer l'ensemble des murs du plateau, elle transmet juste le message au plateau
  def actualiseAffichage ()
    @plateau.actualiseAffichage()
  end

  #La méthode getTemps permet de renvoyer le temps écoulé en demandant au compteur de temps
  def getTemps()
    @compteurTemps.getTemps()
  end

  #La méthode calculerScore permet de renvoyer le score actuel de la partie
  def calculerScore()
    temps = getTemps()
    score = 0
    #Le calcul du score est dépendant de la difficulté
    case @difficulte
    #En facile, les 3 étoiles sont accordées pour moins de 1 minute, 2 étoiles pour moins 2 minutes et 1 étoile pour moins de 3 minutes
    when EASY
      if(temps < 60 && check())
        score += 30
      elsif(temps < 120 && check())
        score += 20
      elsif(temps < 180 && check())
        score += 10
      end
    #En facile, les 3 étoiles sont accordées pour moins de 5 minutes, 2 étoiles pour moins 7 minutes et 1 étoile pour moins de 8 minutes
    when MEDIUM
      if(temps < 300 && check())
        score += 30
      elsif(temps < 420 && check())
        score += 20
      elsif(temps < 480 && check())
        score += 10
      end
    #En facile, les 3 étoiles sont accordées pour moins de 10 minutes, 2 étoiles pour moins 12 minutes et 1 étoile pour moins de 15 minutes
    when HARD
      if(temps < 600 && check())
        score += 30
      elsif(temps < 720 && check())
        score += 20
      elsif(temps < 900 && check())
        score += 10
      end
    end
    #Un malus est attribué pour chaque aide utilisée
    #score = score - @nbAides * 2
    #Un bonus est accordé si l'auto-complétion est désactivée
    if(@autoCompletion == false)
      score += 31
    end
    return score
  end

  #La méthode getNbCoups permet de renvoyer le nombre total de coups joués, elle transmet juste le message au plateau
  def getNbCoups()
    return @nbCoup
  end

  #La méthode getNbAidess permet de renvoyer le nombre total d'aides utilisée, elle transmet juste le message au plateau
  def getNbAides()
    return @nbAides
  end

  def getAide()
    return @aide
  end

  def check()
    @aide.checkAll
  end

  #Méthode de réinitialisation d'une partie
  def reinitialiser()
    #On réinitialise la grille
    raz()
    raz()
    #On remet le nombre de coups joués à 0
    @nbCoup = 0
    #On remet le nombre d'aides utilisées à 0
    @nbAides = 0
    #On remet le temps à 0
    @compteurTemps.kill
    @compteurTemps.reinitialiser
  end

  #retourne à la premiere erreur
  def retourPremiereErreur
    self.loadPlateau(4)
    self.savePlateau(0)
  end
end
