##
#La classe Coup représente un coup joué par le joueur
class Coup
  #@x => La coordonnée x du coup joué
  #@y => la coordonnée y du coup joué

  #La méthode de classe creer permet d'appeler la méthode new et de rendre cette dernière inutilisable dans le but de rendre le code plus parlant
  def Coup.creer(x,y)
    new(x,y)
  end

  #On rend la méthode de classe new private
  private_class_method :new

  #La méthode initialize permet de définir les variables d'instances
  def initialize(x,y)
    @x = x
    @y = y
  end

  #la méthode dejouer permet de faire déjouer le coup joué plus tôt
  def dejouer(plateau)
    mur = plateau.getMur(@x,@y)
    mur.revenirEtat
  end
end
