##
# La classe Jouer représente l'object qui affiche le menu Jouer dans la fenetre du jeu
class Jouer < Menu
	# @gestionnaire	=> Le gestionnaire de menu attaché à l'acceuil
	#	@builder	=> Le builder qui instancie les différents widgets du fichier glade
	#	@grid	=> La grille qui contient tous les widgets de l'accueil

	#La méthode de classe creer permet d'appeler la méthode new et de rendre cette dernière inutilisable dans le but de rendre le code plus parlant
	def Jouer.creer(gestionnaire)
		new(gestionnaire)
	end

	#On rend la méthode de classe new private
	private_class_method :new

	#Méthode initialize permet de charger le menu jouer à l'écran en créant tous les évenements aux différents widgets
	def initialize(gestionnaire)
		#On appèle le builder avec le fichier correspondant
		@builder = Builder.new("Jouer.glade")

		#On appèle la méthode initialize de la superClasse
		super(gestionnaire)

		#On change le nom de la fenetre
		@gestionnaire.changerNom("-#{self.class}")

		#On affecte un comportement à l'évenement clicked pour le boutton @btnRetour
		@builder.getVar("@btnRetour").signal_connect('clicked') {
			@gestionnaire.changerMenu(Accueil.creer(@gestionnaire))
		}

		#On affecte un comportement à l'évenement clicked pour le boutton @btnFacile
		@builder.getVar("@btnFacile").signal_connect('clicked') {
			@gestionnaire.changerMenu(Campagne.creer(@gestionnaire,EASY))
		}

		#On affecte un comportement à l'évenement clicked pour le boutton @btnNormal
		@builder.getVar("@btnNormal").signal_connect('clicked') {
			@gestionnaire.changerMenu(Campagne.creer(@gestionnaire,MEDIUM))
		}

		#On affecte un comportement à l'évenement clicked pour le boutton @btnDifficile
		@builder.getVar("@btnDifficile").signal_connect('clicked') {
			@gestionnaire.changerMenu(Campagne.creer(@gestionnaire,HARD))
		}

		#On affecte un comportement à l'évenement clicked pour le boutton @btnMode
		@builder.getVar("@btnMode").signal_connect('clicked') {
			@gestionnaire.changerMenu(Modes.creer(@gestionnaire))
		}
	end
end
