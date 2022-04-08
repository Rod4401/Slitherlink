require_relative "PopupBase.rb"
require_relative "../Menus/Builder.rb"
require_relative "../Partie/Partie.rb"
##
#La classe PopupVerification est une PopopBase plus spécialisée
#Elle permet de proposer une choix (oui ou non) à l'utilisateur
#Cette classe agit comme une interface Java car elle nécéssite pour la classe appelante de définir 2 méthodes
# => La méthode valider => Appelé dans le cas d'un appui sur valider
# => La méthode refuser => Appelé dans le cas d'un appui sur reffuser

class PopupCheckOk < PopupBase
  #La méthode de classe creer permet d'appeler la méthode new et de rendre cette dernière inutilisable dans le but de rendre le code plus parlant
  def PopupCheckOk.creer(nom_fenetre, appelant, partie)
    new(nom_fenetre, appelant, partie)
  end

  #On rend la méthode de classe new private
  private_class_method :new

  #La méthode initialize permet de définir les paramètres de la popup
  def initialize(nom_fenetre, appelant, partie)
    #On appèle le constructeur de la classe mère
    super(nom_fenetre)
    #On appèle le builder de la PopupVerification
    @builder = Builder.new("PopupCheckOk.glade")
    #On récupère la grille
    @grid=@builder.getGrid()

    #On affecte une image aux 2 Gtk::Button
    @builder.getVar("@btnOui").image = Gtk::Image.new(:file => "Image/valider.png")
    @builder.getVar("@btnNon").image = Gtk::Image.new(:file => "Image/refuser.png")

    #On affecte un comportement à l'évenement clicked pour le boutton @btnOuin permettant de quitter la partie
    @builder.getVar("@btnOui").signal_connect('clicked'){
      #On demande à l'appelant de relancer la partie
      appelant.recommencerPartie()
      #On détruit la popup
      self.destroy
    }

    #On affecte un comportement à l'évenement clicked pour le boutton @brnNon permettant de quitter la partie
    @builder.getVar("@btnNon").signal_connect('clicked'){
      #On demande à l'appelant de terminer la partie
      appelant.arreterPartie()
      #On détruit la popup
      self.destroy
    }

    #Affichage du temps de jeu final
    j = partie.compteurTemps.jours
    h = partie.compteurTemps.heures
    m = partie.compteurTemps.minutes
    s = partie.compteurTemps.secondes

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

    @builder.getVar("@lblTemps").set_markup(chaine)

    #Affichage du nombre de coups final
    @builder.getVar("@lblNbCoups").set_markup(partie.getNbCoups.to_s)

    #Affichage du nombre d'aides utilisées final
    @builder.getVar("@lblNbAides").set_markup(partie.getNbAides.to_s)

    #Affichage du score final sous forme d'étoiles
    #Si l'auto-complétion est activé, alors on affiche des étoiles argentées
    if(partie.autoCompletion)
      etoile = "Image/etoileArgent.png"
    #Sinon des étoiles dorées
    else
      etoile = "Image/etoileDoree.png"
    end
    #Affichage du nombre d'étoiles selon le score
    score = partie.calculerScore() #% 30
    #Les 3 étoiles sont accordées pour un score parfait, de 30 ou 60
    if(score == 30 || score == 61)
      @builder.getVar("@etoile3").clear()
      @builder.getVar("@etoile3").set_from_file(etoile)
      @builder.getVar("@etoile2").clear()
      @builder.getVar("@etoile2").set_from_file(etoile)
      @builder.getVar("@etoile1").clear()
      @builder.getVar("@etoile1").set_from_file(etoile)
    # 2 étoiles sont accordées pour un score de 20 à 29 ou 50 à 59 si l'auto-complétion est désactivée
  elsif((score >= 20 && score <30) || (score >= 50 && score < 60))
      @builder.getVar("@etoile2").clear()
      @builder.getVar("@etoile2").set_from_file(etoile)
      @builder.getVar("@etoile1").clear()
      @builder.getVar("@etoile1").set_from_file(etoile)
    # 1 étoile est accordée pour un score de 10 à 19 ou 40 à 49 si l'auto-complétion est désactivée
  elsif((score >= 10 && score < 20) || (score >= 40 && score < 50))
      @builder.getVar("@etoile1").clear()
      @builder.getVar("@etoile1").set_from_file(etoile)
    end

    #On ajoute la grille à la fenetre
    self.add(@grid)
    #On rend visible tous les widgets
    show_all()
  end
end
