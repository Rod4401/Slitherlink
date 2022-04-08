require_relative "Coup.rb"
require_relative"CoupVersEtat.rb"
#Constante correspondant au fichier des sauvegardes
DIR_GRILLES = "Saves/"
#Un fichier par defaut de plateau contient : [CASES,MURS]
#Ces 2 constantes permettent une meilleure lisibilité
CASES = 0
MURS = 1
##
#La classe Plateau permet de représenter un plateau pendant une partie
class Plateau
  #@partie => La partie reliée au plateau
  #@taille  => La taille du plateau (le nombre de cases)
  #@listeCoups => La liste des coups joués
  #@listeMurs  => La liste des murs
  #@listeCases  => La liste des cases

  #La méthode de classe creer permet d'appeler la méthode new et de rendre cette dernière inutilisable dans le but de rendre le code plus parlant
  def Plateau.creer(partie)
    new(partie)
  end

  #On rend la méthode de classe new private
  private_class_method :new

  #On inclue le module Difficulte
  include Difficulte

  #Coding assistant
  attr_reader :partie, :taille, :listeMurs
  attr_accessor :listeCoups

  #La méthode initialize permet de définir les variables d'instances
  def initialize(partie)
    @partie = partie
    @taille=to_i(@partie.difficulte,NB_CASES_FACILE,NB_CASES_MOYEN,NB_CASES_DIFFICILE,NB_CASES_CLM)
    @listeCoups = Array.new()
    #puts "ChargerCases"
    #On charge les cases du plateau
    self.chargerCases()
    #puts "chargerMurs"
    #On charge lrs murs du plateau
    self.chargerMurs()
  end

  #La méthode connect permet de conntecter une partie au plateau
  def connect(partie)
    @partie = partie
  end

  #La méthode reloadButton permet de conncter tous les Gtk::Button à chaque mur du plateau
  def reloadButton()
    0.upto(@taille*2){ |x|
      0.upto(@taille*2){ |y|
        if((x%2 == 0 && y%2 == 1) || (x%2 == 1 && y%2 == 0))
          button = @partie.gestionnairePartie.getButton(y,x)
          @listeMurs[x][y].setButton(button)
        end
      }
    }
  end

  #Cette méthode fait l'inverse de la méthode reload, elle déconnecte tous les Gtk::Button de chaque mur
  def deloadButton()
    begin
      0.upto(@taille*2){ |x|
        0.upto(@taille*2){ |y|
          if((x%2 == 0 && y%2 == 1) || (x%2 == 1 && y%2 == 0))
            @listeMurs[x][y].setButton(nil)
          end
        }
      }
    rescue
    end
  end

  #La méthode chargerMurs permet de récupérer la liste des murs dans le fichier défault
  #Chaque mur contient ses coordonnées ainsi que son état correcte
  def chargerMurs()
    begin
      file = File.open(DIR_GRILLES+"#{@partie.difficulte}/#{@partie.numero}.default","r")
      @listeMurs = YAML.load(file.read())[MURS]
      file.close
    rescue
      puts "erreur charger murs"
      raise PlateauCreationError
    end
  end

  #Méthode qui permet d'obtenir la liste des cases
  def getCases()
    return @listeCases
  end

  #Méthode qui permet de récupérer la liste des cases dans le fichier défault
  def chargerCases()
    begin
      file = File.open(DIR_GRILLES+"#{@partie.difficulte}/#{@partie.numero}.default","r")
      string = file.read()
      @listeCases = YAML.load(string)[CASES]
      0.upto(@taille*2){ |x|
        0.upto(@taille*2){ |y|
          if(x%2 == 1 && y%2 == 1)
            @listeCases[x][y].plateau=self
          end
        }
      }
      file.close
    rescue => e
      #Si on a pas pu trouver le fichier alors on génère une exception
      raise PlateauCreationError
    end
  end

  #La méthode permet d'envoyer à chaque mur le message afficheToi pour mettre à jour l'affichage si on change/charge un plateau
  def actualiseAffichage()
    0.upto(@taille*2){ |x|
      0.upto(@taille*2){ |y|
        if((x%2 == 0 && y%2 == 1) || (x%2 == 1 && y%2 == 0))
          @listeMurs[x][y].afficheToi
        end
      }
    }
  end
  ##################################
  # => Partie jeu
  ##################################

   #La méthode jouerCoup permet de créer un coup et de faire changer l'état du mur en question
    #On passe en paramètre un x et un y
    def jouerCoup(x,y)
      # puts(@taille)
      puts("val " + y.to_s() + " " + x.to_s())
      if (y%2 != 0 && conditionx(y,x) && @listeMurs[y][x].etat == 0)
        coup = CoupVersEtat.creer(y,x,@listeMurs[y][x].etat)
        @listeMurs[y][x].changerEtatDefini(2)
      elsif (y%2 == 0 && conditiony(y,x) && @listeMurs[y][x].etat == 0)
        coup = CoupVersEtat.creer(y,x,@listeMurs[y][x].etat)
        @listeMurs[y][x].changerEtatDefini(2)
      else
        coup = Coup.creer(y,x)
        @listeMurs[y][x].changerEtat()
      end
      @listeCoups.push(coup)
    end

    #verifie si une des deux extremite d'un mur est touché par au moins deux MURS
    def conditionx(y, x)
      cond = (donneEtatMur(y-1,x-1) == 1) && (donneEtatMur(y-2,x) == 1)
      cond = cond || ((donneEtatMur(y-2,x) == 1) && (donneEtatMur(y-1,x+1) == 1))
      cond = cond || ((donneEtatMur(y-1,x+1) == 1) && (donneEtatMur(y-1,x-1) == 1))
      cond = cond || ((donneEtatMur(y+1,x-1) == 1) && (donneEtatMur(y+2,x) == 1))
      cond = cond || ((donneEtatMur(y+2,x) == 1) && (donneEtatMur(y+1,x+1) == 1))
      cond = cond || ((donneEtatMur(y+1,x+1) == 1) && (donneEtatMur(y+1,x-1) == 1))
      puts(cond)
      return cond
    end

    def conditiony(y, x)
      cond = (donneEtatMur(y-1,x+1) == 1) && (donneEtatMur(y,x+2) == 1)
      cond = cond || ((donneEtatMur(y,x+2) == 1) && (donneEtatMur(y+1,x+1) == 1))
      cond = cond || ((donneEtatMur(y-1,x+1) == 1) && (donneEtatMur(y+1,x+1) == 1))
      cond = cond || ((donneEtatMur(y-1,x-1) == 1) && (donneEtatMur(y+1,x-1) == 1))
      cond = cond || ((donneEtatMur(y-1,x-1) == 1) && (donneEtatMur(y,x-2) == 1))
      cond = cond || ((donneEtatMur(y,x-2) == 1) && (donneEtatMur(y+1,x-1) == 1))
      puts(cond)
      return cond
    end

    def donneEtatMur(y,x)
      puts(@listeMurs.length.to_s)
      if ((y < @listeMurs.length) && (y >= 0) && (x >= 0) && (x < @listeMurs.length))
        # puts("val dans etat" + y.to_s() + " " + x.to_s())
        return @listeMurs[y][x].etat
      else
        return 2;
      end
    end

  #La méthode dejouerCoup permet de faire l'inverse de la méthode dejouerCoup
  #Elle retirer le dernier coup et fait faire au mur : prendre l'état précédent
  def dejouerCoup()
    begin
      coup = @listeCoups.pop
      coup.dejouer(self)
      return true
    rescue
      #puts "Aucun coup disponible"
      return false
    end
  end

  #Cette methode permet de remettre a false les cases a proximite du mur active
  def actualiserCases(x,y)
    #=============================#
    # CASE SUPERIEURE             #
    #=============================#
    begin
      @listeCases[x-1][y].resetEtat
    rescue
    end

    #=============================#
    # CASE INFERIEURE             #
    #=============================#
    begin
      @listeCases[x+1][y].resetEtat
    rescue
    end

    #=============================#
    # CASE GAUCHE                 #
    #=============================#
    begin
      @listeCases[x][y-1].resetEtat
    rescue
    end

    #=============================#
    # CASE DROITE                 #
    #=============================#
    begin
      @listeCases[x][y+1].resetEtat
    rescue
    end
  end


  #Retourne vrai si le mur existe, faux sinon
  #Paramètre : coordonnées x et y du supposé mur
  def murExiste?(x,y)
    puts ("murExiste?() x:#{x} , y:#{y}")
    if(x >= 0 && y >= 0 && x < @taille*2 && y < @taille*2) then
      if(x%2 == 1 || y%2 == 1) then
        return true
      else
        puts("ERREUR : Plateau.rb , murExiste?() \n Les coordonnées ne correspondent pas à un mur")
        return false
      end
    else
      puts("ERREUR : Plateau.rb , murExiste?() \n Les coordonnées renseignées sont hors du plateau")
      return false
    end
  end

  #Affiche la liste des murs dans le terminal
  def afficherPlateauTerminal()
    puts("Affichage du plateau :")
    0.upto(@taille*2){ |x|
      0.upto(@taille*2){ |y|
        if((x%2 == 0 && y%2 == 1) || (x%2 == 1 && y%2 == 0))then
          case(@listeMurs[y][x].etat)
          when REMPLI
            puts(" M , [#{x},#{y}] @listeMurs[#{y},#{x}]")
          when VIDE
            puts(" V , [#{x},#{y}] @listeMurs[#{y},#{x}]")
          when CROIX
            puts(" x , [#{x},#{y}] @listeMurs[#{y},#{x}]")
          end
        elsif(x%2 != 0 && y%2 != 0) then
          puts(" #{@listeCases[x][y].numero} , [#{x},#{y}]")
        else
          puts(" ")
        end
      }
      puts("ENDLINE")
    }
  end

  #La méthode getMur permet d'obtenir le mur x, y
  def getMur(x,y)
    #puts("Plateau.rb, getMur(#{x},#{y}), @listeMurs(#{y},#{x})")   #Position du mur si vous appellez getMur(y,x) (implique que vous utilisez listeCases[x][y])
    #puts("Plateau.rb, getMur(#{x},#{y}), @listeMurs(#{x},#{y})")   #Position du mur si vous appellez getMur(x,y) (implique que vous utilisez listeCases[y][x])
    @listeMurs[x][y]
  end

  #La méthode getMur permet d'obtenir le mur x, y
  def autoCompGetMur(y,x)
    #puts("Plateau.rb, getMur(#{x},#{y}), @listeMurs(#{y},#{x})")   #Position du mur si vous appellez getMur(y,x) (implique que vous utilisez listeCases[x][y])
    #puts("Plateau.rb, getMur(#{x},#{y}), @listeMurs(#{x},#{y})")   #Position du mur si vous appellez getMur(x,y) (implique que vous utilisez listeCases[y][x])
    @listeMurs[x][y]
  end

  #La méthode getCase permet d'obtenir la case x, y
  def getCase(y,x)
    puts("CASE RECUPERER : , getCase(#{x}, #{y}), @listCases(#{x}, #{y})")
    return @listeCases[x][y].afficheNumero
  end

  #Retourne l'objet case en x , y
  def getCaseObject(x,y)
    return @listeCases[x][y]
  end


  #Recupere une liste des cases adjacentes au mur x, y
  def caseAdjacente(x,y)
    listeCase = Array.new()
    puts("Vous avez sur le mur : " , x , " , " , y )
    if(y % 2 == 1)
      puts("Mur vertical")
      if((x-1) >= 0)
        puts("MV1")
        listeCase.push(self.getCase(y,x-1))
      end
      if((x + 1) < @taille*2)
        puts("MV2")
        listeCase.push(self.getCase(y,x+1))
      end
    else
      puts("Mur horizontal")
      if((y-1) >= 0)
        puts("MH1")
        listeCase.push(self.getCase(y-1,x))
        puts(listeCase)
      end
      if((y + 1) < @taille*2)
        puts("MH2")
        listeCase.push(self.getCase(y+1,x))
        puts(listeCase)
      end
    end
    puts(listeCase)
    return listeCase
  end

  #La méthode getNbCoups permet d'obtenir le nombre de coup joués
  def getNbCoups()
    @listeCoups.length
  end

  #Méthode getTaille : retourne la taille du plateau
  def getTaille()
    return @taille
  end
end
