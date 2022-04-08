require_relative "../Modules/Difficulte.rb"
require_relative "../Error/ProfilScoresError.rb"
##
#La classe Profil permet de représenter un profil utilisateur

class Profil
  #@name => Le nom du profil (pseudo)
  #@id => L'id du profil
  #@scores => Le tableau des scores du joueur
  #@theme => Thème choisi par l'utilisateur
  #@autoCompletion => Boolean si l'utilisateur active ou non l'autoCompletion

  #On inclu le module Difficulte
  include Difficulte

  #La méthode de classe creer permet d'appeler la méthode new et de rendre cette dernière inutilisable dans le but de rendre le code plus parlant
  def Profil.creer(name,id)
    new(name,id)
  end

  #On rend la méthode de classe new private
  private_class_method :new

  #La méthode initialize permet de définir les variables d'instances
  def initialize(name,id)
    @name = name
    @id = id
    @scores = Array.new(3) {Array.new(15)}
    @theme = 0
    @autoCompletion = false
  end

  #Coding assistant
  attr_accessor :theme, :autoCompletion
  attr_reader :name, :id

  #La méthode setScore permet d'affecter un score à un profil
  #On associe un score et un temps à une grille y de difficulté x
  def setScore(difficulte,grille,score,temps)
    #On récupère l'entier correspondant à la difficulte
    difficulte = to_i(difficulte,0,1,2)
    begin
      @scores[difficulte][grille]=[score,temps]
    rescue
    end
  end

  #La méthode getScore permet de récuper 1 score en fonction de la difficulte et de la grille passée en paramètre
  def getScore(difficulte,grille)
    #On récupère l'entier correspondant à la difficulte
    difficulte = to_i(difficulte,0,1,2)
    begin
      score = @scores[difficulte][grille]
    rescue
      #Si il n'y a pas de score on renvoie nil
      score = nil
    end
    return score
  end

  #La méthode getScores permet de renvoyer le total des scores du profil
  def getScores()
    score = 0
    @scores.each{ |difficulte|
      difficulte.each{ |grilles|
        begin
          score += grilles[0]
        rescue
        end
      }
    }
    return score
  end

  #Lorsqu'on supprime un id il faut décrémenter tous les id suivant, cette méthode réalise cette tache
  def decrementeId()
    @id-=1
    true
  end

  #La méthode permet de reinitialiser le score d'une grille de difficulté x
  def resetScore(difficulte,grille)
    #On récupère l'entier correspondant à la difficulte
    difficulte=to_i(difficulte,0,1,2)
    begin
      @scores[difficulte][grille]=nil
    rescue
      #Si on arrive ici c'est qu'on a pas initialisé les scores, c'est donc un gros problème
      #on doit faire remonter l'exception
      raise ProfilScoreError
    end
  end



end
