##
# La classe APropos représente l'object qui affiche les infos du jeu à l'écran
class APropos < Menu
	# @gestionnaire	=> Le gestionnaire de menu attaché
	#	@builder	=> Le builder qui instancie les différents widgets du fichier glade
	#	@grid	=> La grille qui contient tous les widgets

	#La méthode de classe creer permet d'appeler la méthode new et de rendre cette dernière inutilisable dans le but de rendre le code plus parlant
	def APropos.creer(gestionnaire)
		new(gestionnaire)
	end

	#On rend la méthode de classe new private
	private_class_method :new

	#Méthode initialize permet de charger la page d'informations à l'écran en créant tous les évenements aux différents widgets
	def initialize(gestionnaire)
		#On appèle le builder avec le fichier correspondant à la page aPropos
		@builder = Builder.new("A_Propos.glade")

		#On appèle la méthode initialize de la superClasse
		super(gestionnaire)

		#On change le nom de la fenetre
		@gestionnaire.changerNom("-À propos")

		#On affecte un comportement à l'évenement clicked pour le boutton @btnRetour
		@builder.getVar("@btnRetour").signal_connect('clicked') {
			@gestionnaire.changerMenu(Accueil.creer(@gestionnaire))
		}
	end
end
