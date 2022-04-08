##
# La classe TutoImage représente l'object qui affiche le menu TutoImage dans la fenetre du jeu
class TutoImage < Menu
	# @gestionnaire	=> Le gestionnaire de menu attaché à ce menu
	#	@builder	=> Le builder qui instancie les différents widgets du fichier glade
	#	@grid	=> La grille qui contient tous les widgets de ce menu

	#La méthode de classe creer permet d'appeler la méthode new et de rendre cette dernière inutilisable dans le but de rendre le code plus parlant
	def TutoImage.creer(gestionnaire)
		new(gestionnaire)
	end

	#On rend la méthode de classe new private
	private_class_method :new

	#Méthode initialize permet de charger le menu tutoriel imagé à l'écran en créant tous les évenements aux différents widgets
	def initialize(gestionnaire)
		#On appèle le builder avec le fichier correspondant
		@builder = Builder.new("TutoImage.glade")

		#On appèle la méthode initialize de la superClasse
		super(gestionnaire)

		#On change le nom de la fenetre
		@gestionnaire.changerNom("-#{self.class}")

		#On affecte un comportement à l'évenement clicked pour le boutton @btnRetour
		@builder.getVar("@btnRetour").signal_connect('clicked') {
			@gestionnaire.changerMenu(Tutoriel.creer(@gestionnaire))
		}



	end

end
