EASY = "faciles"
MEDIUM = "normales"
HARD = "difficiles"
CONTRE_LA_MONTRE = "modes/clm"

##
#Le module Difficulte permet d'ajouter une méthode qui permet de transformer
#une difficulte en un entier ou une autre valeure
module Difficulte
  def to_i(difficulte,w,x,y,z = 0)
    case difficulte
    when EASY
      difficulte = w
    when MEDIUM
      difficulte = x
    when HARD
      difficulte = y
    when CONTRE_LA_MONTRE
      difficulte = z
    end
    return difficulte
  end
end
