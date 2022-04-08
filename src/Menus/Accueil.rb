##
# La classe Accueil représente l'object qui affiche l'accueil dans la fenetre du jeu

class Accueil < Menu
	# @gestionnaire	=> Le gestionnaire de menu attaché à l'acceuil
	#	@builder	=> Le builder qui instancie les différents widgets du fichier glade
	#	@grid	=> La grille qui contient tous les widgets de l'accueil

	#La méthode de classe creer permet d'appeler la méthode new et de rendre cette dernière inutilisable dans le but de rendre le code plus parlant
	def Accueil.creer(gestionnaire)
		new(gestionnaire)
	end

	#On rend la méthode de classe new private
	private_class_method :new

	#Méthode initialize permet de charger l'accueil à l'écran en créant tous les évenements aux différents widgets
	def initialize(gestionnaire)
		#On appèle le builder avec le fichier correspondant à l'accueil
		@builder = Builder.new("Accueil.glade")

		#On appèle la méthode initialize de la superClasse
		super(gestionnaire)
		@gestionnaire.redimentioner()

		#On change le nom de la fenetre
		@gestionnaire.changerNom("-#{self.class}")

		#On affecte un comportement à l'évenement clicked pour le boutton @btnQuitter
		@builder.getVar("@btnQuitter").signal_connect('clicked') {
			@gestionnaire.sauvegarderProfils
			Gtk.main_quit
		}

		#On affecte un comportement à l'évenement clicked pour le boutton @btnJouer
		@builder.getVar("@btnJouer").signal_connect('clicked') {
			@gestionnaire.changerMenu(Jouer.creer(@gestionnaire))
		}

		#On affecte un comportement à l'évenement clicked pour le boutton @btnProfils
		@builder.getVar("@btnProfils").signal_connect('clicked') {
			@gestionnaire.changerMenu(Profils.creer(@gestionnaire))
		}

		#On affecte un comportement à l'évenement clicked pour le boutton @btnTutoriel
		@builder.getVar("@btnTutoriel").signal_connect('clicked') {
			@gestionnaire.changerMenu(Tutoriel.creer(@gestionnaire))
		}

		#On affecte un comportement à l'évenement clicked pour le boutton @btnRegles
		@builder.getVar("@btnRegles").signal_connect('clicked') {
			@gestionnaire.changerMenu(Regles_Techniques.creer(@gestionnaire))
		}

		#On affecte un comportement à l'évenement clicked pour le boutton @btnOptions
		@builder.getVar("@btnOptions").signal_connect('clicked') {
			@gestionnaire.changerMenu(Options.creer(@gestionnaire,self))
		}

		#On affecte un comportement à l'évenement clicked pour le boutton @btnAPropos
		@builder.getVar("@btnAPropos").signal_connect('clicked') {
			@gestionnaire.changerMenu(APropos.creer(@gestionnaire))
		}

		#On affecte un comportement à l'évenement clicked pour le boutton @btnClassement
		@builder.getVar("@btnClassement").signal_connect('clicked') {
			@gestionnaire.changerMenu(Classement.creer(@gestionnaire))
		}

		#On affiche le score du profil actif
		@builder.getVar("@lblScore").set_markup("Score : "+@gestionnaire.getProfilActif().getScores().to_s)

	end
end
