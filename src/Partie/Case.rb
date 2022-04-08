##
#Constantes pour la localisation d'une case adjacente par rapport à une autre
NORD = 0
SUD = 1
EST = 2
OUEST = 3

#Constantes pour la localisation d'une case en diagonale par rapport à une autre
NORDEST = 4
NORDOUEST = 5
SUDEST = 6
SUDOUEST = 7

#Constantes etat MURS
VIDE = 0
REMPLI = 1
CROIX = 2

# La classe Case represente une case du plateau pendant une partie
class Case
  # @x	=> La coordonnee x de la case
  # @y	=> La coordonnee y de la case
  #	@numero	=> Le numero de la case (-1 si vide)
  #	@plateau	=> Le plateau attache a la case
  # @correct  => Boolean de test si la case est correcte, permet d'éviter de redemander au murs
  # @listeMurLocal => Liste des murs autour de la case
  #La methode de classe creer permet d'appeler la methode new et de rendre cette dernière inutilisable dans le but de rendre le code plus parlant
  def Case.creer(x,y,numero)
    new(x,y,numero)
  end

  #On rend la methode de classe new private
  private_class_method :new

  #Coding assistant
  attr_reader :numero, :x, :y
  attr_accessor :plateau

  #La methode initialize permet de definir les variables d'instances
  def initialize(x,y,numero)
    @x = x
    @y = y
    @listeMurLocal = Array.new()
    @numero = numero
    @correct = false
  end

  def afficheNumero()
    puts("Je suis la case numero : " , @numero)
    return self
  end
  #La methode permet de savoir si la case est en etat correct, c'est-a-dire si les murs de la case sont dans un etat correct
  #Pour eviter de redemander aux murs a chaque fois, on memorise dans la variable @correct qui est remit a 0 si un mur a proximite de la case est active
  def estCorrect
      #puts "recalcul de la case #{@x} #{@y}"
      return (@plateau.autoCompGetMur(@x-1,@y).estCorrect) && (@plateau.autoCompGetMur(@x+1,@y).estCorrect) && (@plateau.autoCompGetMur(@x,@y-1).estCorrect) && (@plateau.autoCompGetMur(@x,@y+1).estCorrect)
  end

  #Cette methode permet de recuperer les murs qui se situe autour de la case
  def listeDesMursAutour()
    listeMurAutour = Array.new()
    listeMurAutour.push(@plateau.getMur(@x-1,@y))
    listeMurAutour.push(@plateau.getMur(@x+1,@y))
    listeMurAutour.push(@plateau.getMur(@x,@y-1))
    listeMurAutour.push(@plateau.getMur(@x,@y+1))
    puts(listeMurAutour)
    return listeMurAutour
  end

  #Cette methode permet de recuperer les murs qui se situe autour de la case
  def listeDesMursLocal()
    listeMurLocal = Array.new()
    listeMurX = Array.new()
    listeMurY = Array.new()
    listeMurInfo = Array.new()

    listeMurLocal.push(@plateau.autoCompGetMur(@x-1,@y))
    listeMurX.push(@x-1)
    listeMurY.push(@y)

    listeMurLocal.push(@plateau.autoCompGetMur(@x+1,@y))
    listeMurX.push(@x+1)
    listeMurY.push(@y)

    listeMurLocal.push(@plateau.autoCompGetMur(@x,@y-1))
    listeMurX.push(@x)
    listeMurY.push(@y-1)

    listeMurLocal.push(@plateau.autoCompGetMur(@x,@y+1))
    listeMurX.push(@x)
    listeMurY.push(@y+1)

    puts(listeMurLocal)
    listeMurInfo.push(listeMurLocal)
    listeMurInfo.push(listeMurX)
    listeMurInfo.push(listeMurY)
    return listeMurInfo
  end

  #La methode renvoie le nombre de croix autour de la case
  def getNbCroix
    nbCroix = 0
    listeMurLocal = listeDesMursLocal()
    0.upto(3){ |x|
      if(listeMurLocal[0][x].getEtat == 2)
        nbCroix += 1
      end
    }
    return nbCroix
  end

  #La methode renvoie le nombre de mur autour de la case
  def getNbMur
    nbMur = 0
    listeMurLocal = listeDesMursLocal()
    0.upto(3){ |x|
      if(listeMurLocal[0][x].getEtat == 1)
        nbMur += 1
      end
    }
    return nbMur
  end

  #Complete les murs autour de la case par des croix
  def completeCroix
    listeMurLocal = listeDesMursLocal()
    0.upto(3){ |x|
      if(listeMurLocal[0][x].etat != 1)
        @plateau.listeCoups.push(CoupVersEtat.creer(listeMurLocal[2][x],listeMurLocal[1][x],listeMurLocal[0][x].etat))
        listeMurLocal[0][x].changerEtatDefini(CROIX)
      end
    }
  end

  #Complete les murs autour de la case par des croix
  def completeMurs
    listeMurLocal = listeDesMursLocal()
    0.upto(3){ |x|
      if(listeMurLocal[0][x].etat != 2)
        @plateau.listeCoups.push(CoupVersEtat.creer(listeMurLocal[2][x],listeMurLocal[1][x],listeMurLocal[0][x].etat))
        listeMurLocal[0][x].changerEtatDefini(REMPLI)
      end
    }
  end

    #Transforme tout les murs autour de la case en croix
    def completeAllCroix
      listeMurLocal = listeDesMursLocal()
      0.upto(3){ |x|
        @plateau.listeCoups.push(CoupVersEtat.creer(listeMurLocal[2][x],listeMurLocal[1][x],listeMurLocal[0][x].etat))
        listeMurLocal[0][x].changerEtatDefini(CROIX)
      }
    end

    #Transforme tout les murs autour de la case en murs
    def completeAllMurs
      listeMurLocal = listeDesMursLocal()
      0.upto(3){ |x|
        @plateau.listeCoups.push(CoupVersEtat.creer(listeMurLocal[2][x],listeMurLocal[1][x],listeMurLocal[0][x].etat))
        listeMurLocal[0][x].changerEtatDefini(REMPLI)
      }
    end

    #Mets l'état des murs autour de la case a vide
    def videMur
      listeMurLocal = listeDesMursLocal()
      0.upto(3){ |x|
        @plateau.listeCoups.push(CoupVersEtat.creer(listeMurLocal[2][x],listeMurLocal[1][x],listeMurLocal[0][x].etat))
        listeMurLocal[0][x].changerEtatDefini(VIDE)
      }
    end


    def donneEtatMur()
      puts(@listeMurs.length.to_s)
      if ((y < @plateau.listeMurs.length) && (y >= 0) && (x >= 0) && (x < @plateau.listeMurs.length))
        # puts("val dans etat" + y.to_s() + " " + x.to_s())
        return @listeMurs[y][x].etat
      else
        return 2;
      end
    end


  def completeToi(x,y)
    case (@numero)
      when 0
        completeAllCroix()
      when 1
        if(getNbMur() == 1)
          if(getNbCroix() == 2)
            completeAllCroix()
            @plateau.autoCompGetMur(y,x).changerEtatDefini(REMPLI)
          else
            completeCroix()
          end
        elsif(getNbCroix() == 4)
          videMur()
        end
      when 2
        if(getNbMur() == 2)
          completeCroix()
        end
      when 3
        if(getNbMur() == 3)
          completeCroix()
        elsif(getNbCroix() == 1)
          completeMurs()
        elsif(getNbCroix() == 2)
          completeAllMurs()
          @plateau.autoCompGetMur(y,x).changerEtatDefini(CROIX)
        end
    end
  end

  #Methode qui permet de remettre a false l'etat de la case
  def resetEtat
    @correct = false
  end

  #Retourne la liste des cases adjacentes à cette case
  def casesAdjacentes()
    taille = @plateau.getTaille()
    listeCasesAdjacentes = Array.new()

    if(@y-2 > 0) then
      #puts "T1: Chercher x:#{@x} , y#{@y-2}"
      listeCasesAdjacentes.push(@plateau.getCaseObject(@x,@y-2))
    end

    if(@x-2 > 0) then
      #puts "T2: Chercher x:#{@x-2} , y#{@y}"
      listeCasesAdjacentes.push(@plateau.getCaseObject(@x-2,@y))
    end

    if(@y+2 < taille*2) then
      #puts "T3 : Chercher x:#{@x} , y#{@y+2}"
      listeCasesAdjacentes.push(@plateau.getCaseObject(@x,@y+2))
    end

    if(@x+2 < taille*2) then
      #puts "T4 : Chercher x:#{@x+2} , y#{@y}"
      listeCasesAdjacentes.push(@plateau.getCaseObject(@x+2,@y))
    end

    #listeCasesAdjacentes.each{|c|
    #  puts(c)
    #  puts("x: #{c.x} , y: #{c.y}, numero: #{c.numero}")
    #}
    return listeCasesAdjacentes
  end

  #Retourne la liste des 4 cases en diagonales les plus proches de cette case
  def casesDiagonales()
    taille = @plateau.getTaille()
    listeCasesDiagonales = Array.new()

    #Ajoute la diagonale NORDOUEST
    if(@y-2 > 0 && @x-2 > 0) then
      listeCasesDiagonales.push(@plateau.getCaseObject(@x-2,@y-2))
    end

    #Ajoute la diagonale NORDEST
    if(@x+2 < taille*2 && @y-2 > 0) then
      listeCasesDiagonales.push(@plateau.getCaseObject(@x+2,@y-2))
    end

    if(@y+2 < taille*2 && @x-2 > 0) then
      listeCasesDiagonales.push(@plateau.getCaseObject(@x-2,@y+2))
    end

    #Ajoute la diagonale SUDEST
    if(@y+2 < taille*2 && @x+2 < taille*2) then
      listeCasesDiagonales.push(@plateau.getCaseObject(@x+2,@y+2))
    end
    #TEST
    #listeCasesDiagonales.each{|c|
    #  puts(c)
    #  puts("x: #{c.x} , y: #{c.y}, numero: #{c.numero}")
    #}
    return listeCasesDiagonales
  end

  #Retourne la position relative d'une case donnée en paramètre par rapport à celle-ci
  # Si la case renseignée en paramètre ...
  # =>  est au dessus, la fonction retourne NORD
  # =>  est en dessous, SUD
  # =>  est à droite, OUEST
  # =>  est à gauche, EST
  # Lorsque la case se situe en diagonale, la fonction renvoie selon la même logique:
  # => NORDEST, NORDOUEST, SUDEST, SUDOUEST
  def trouverPositionRelativeA(uneCase)
    #Recuperation des coordonnées de la case à rechercher
    x = uneCase.x
    y = uneCase.y

    #Recherche de l'orientation
    if(@x-2 == x && @y == y) then
      return OUEST
    elsif(@x+2 == x && @y == y) then
      return EST
    elsif(@x == x && @y+2 == y) then
      return SUD
    elsif(@x == x && @y-2 == y) then
      return NORD
    elsif(@x+2 == x && @y-2 == y) then
      return NORDEST
    elsif(@x-2 == x && @y-2 == y) then
      return NORDOUEST
    elsif(@x+2 == x && @y+2 == y) then
      return SUDEST
    elsif(@x-2 == x && @y+2 == y) then
      return SUDOUEST
    else
      puts("Attention : Case.rb, trouverPositionRelativeA() : \n Le paramètre renseigné n'est ni une case en diagonale, ni adjacente")
      return -1
    end
  end

  #Retourne NORD, SUD, EST ou OUEST si la case actuelle est située sur un bord
  #Si la case n'est pas située sur le bord retourne -1
  def estSurLeBord()
    taille = @plateau.getTaille()
    #Pour chaque cas on évalue si la case est située sur un bord
    if(@x == 1)then
      return OUEST
    elsif(@x == taille*2-1) then
      return EST
    elsif(@y == 1 ) then
      return NORD
    elsif(@y == taille*2-1) then
      return SUD
    else
      return -1
    end
  end

  #Retourne NORDEST, NORDOUESt, SUDEST ou SUDOUEST si la case actuelle est située dans un coin
  #Si la case n'est pas située dans un coin retourne -1
  def estDansUnCoin()
    taille = @plateau.getTaille()
    #Pour chaque cas on évalue si la case est située sur un bord
    if(@x == 1 && @y == 1)then
      return NORDOUEST
    elsif(@x == 1 && @y == taille*2-1) then
      return SUDOUEST
    elsif(@y == 1 && @x == taille*2-1 ) then
      return NORDEST
    elsif(@y == taille*2-1 && @x == taille*2-1) then
      return SUDEST
    else
      return -1
    end
  end

end
