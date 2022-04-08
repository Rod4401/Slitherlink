require_relative "../Partie/GestionnairePartieMode.rb"
##
# La classe Modes représente l'object qui affiche le menu des modes dans la fenetre du jeu

class Modes < Menu
	# @gestionnaire	=> Le gestionnaire de menu attaché à l'acceuil
	#	@builder	=> Le builder qui instancie les différents widgets du fichier glade
	#	@grid	=> La grille qui contient tous les widgets de l'accueil

	#La méthode de classe creer permet d'appeler la méthode new et de rendre cette dernière inutilisable dans le but de rendre le code plus parlant
	def Modes.creer(gestionnaire)
		new(gestionnaire)
	end

	#On rend la méthode de classe new private
	private_class_method :new

	#Méthode initialize permet de charger l'accueil à l'écran en créant tous les évenements aux différents widgets
	def initialize(gestionnaire)
		#On appèle le builder avec le fichier correspondant à l'accueil
		@builder = Builder.new("Modes.glade")

		#On appèle la méthode initialize de la superClasse
		super(gestionnaire)
		@gestionnaire.redimentioner()

    #On affecte un comportement à l'évenement clicked pour le boutton @btnRetour
    @builder.getVar("@btnRetour").signal_connect('clicked') {
      @gestionnaire.changerMenu(Accueil.creer(@gestionnaire))
    }

    @builder.getVar("@btnContreLaMontre").signal_connect("clicked"){
				begin
					@gestionnaire.changerMenu(GestionnairePartieMode.creer(@gestionnaire))
				rescue PartieChargerError => e
					#On réaffiche le menu campagne
					@gestionnaire.changerMenu(self)
					#On remet à nil le gestionnairePartie dans le GestionnaireMenu (cf gestionnairePartie.rb)
					@gestionnaire.setGestioPartie(nil)
					PopupText.creer("Erreur","Erreur création partie : " + e.message)
				end
    }

	end
end
