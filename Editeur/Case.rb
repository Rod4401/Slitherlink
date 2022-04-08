class Case
  # La classe Case représente une case du plateau pendant une partie
  # @x	=> La coordonnée x de la case
  # @y	=> La coordonnée y de la case
  #	@numero	=> Le numero de la case (-1 si vide)
  #	@plateau	=> Le plateau attaché à la case

  #La méthode de classe creer permet d'appeler la méthode new et de rendre cette dernière inutilisable dans le but de rendre le code plus parlant
  def Case.creer(x,y)
    new(x,y)
  end

  #On rend la méthode de classe new private
  private_class_method :new

  #La méthode initialize permet de définir les variables d'instances
  def initialize(x,y)
    @x = x
    @y = y
    @numero = -1
    @correct = false
  end

  def increaseNumero()
    @numero += 1
    if(@numero == 4) then
      @numero = -1
    end
  end

  def getNumero()
    if(@numero == -1) then
      return ""
    else return @numero.to_s
    end
  end
end
