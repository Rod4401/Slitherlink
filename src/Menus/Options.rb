##
# La classe Options représente l'object qui affiche le menu Options dans la fenetre du jeu
class Options < Menu
	# @gestionnaire	=> Le gestionnaire de menu attaché à l'acceuil
	#	@builder	=> Le builder qui instancie les différents widgets du fichier glade
	#	@grid	=> La grille qui contient tous les widgets de l'accueil

	#La méthode de classe creer permet d'appeler la méthode new et de rendre cette dernière inutilisable dans le but de rendre le code plus parlant
	def Options.creer(gestionnaire,menuParent)
		new(gestionnaire,menuParent)
	end

	#On rend la méthode de classe new private
	private_class_method :new

	#Méthode initialize permet de charger le menu jouer à l'écran en créant tous les évenements aux différents widgets
	def initialize(gestionnaire,menuParent)
		#On appèle le builder avec le fichier correspondant
		@builder = Builder.new("Options.glade")

		#On appèle la méthode initialize de la superClasse
		super(gestionnaire)

		#On change le nom de la fenetre
		@gestionnaire.changerNom("-#{self.class}")

		#On affecte un comportement à l'évenement clicked pour le boutton @btnRetour
		@builder.getVar("@btnRetour").signal_connect('clicked') {
			@gestionnaire.changerMenu(menuParent)
		}

		#On selectionne le thème choisi par l'utilisateur dans la combobox
		@builder.getVar("@selectionTheme").active=@gestionnaire.getThemeId

		#On affecte un comportement à l'évenement changed pour le boutton @selectionTheme
		@builder.getVar("@selectionTheme").signal_connect('changed') {
			#On associe le thème séléctionné au profil actif
			@gestionnaire.changerTheme(@builder.getVar("@selectionTheme").active)
			#On applique le nouveau thème
			@builder.changerTheme(@gestionnaire.getTheme)
		}

		#Boutton d'activation de l'autoCompletion
		@builder.getVar("@btnCheckAutoCompl").set_active(@gestionnaire.getProfilActif().autoCompletion)
		@builder.getVar("@btnCheckAutoCompl").signal_connect("clicked"){
			@gestionnaire.getProfilActif().autoCompletion=!@gestionnaire.getProfilActif().autoCompletion
		}

		#On affecte un comportement à l'évenement clicked pour le boutton @btnClearQuickSave
		@builder.getVar("@btnClearQuickSave").signal_connect("clicked"){
			#Création d'une popup qui demande vérification à l'utilisateur pour la validation
			#de suppression de toute les quicksave
			PopupVerification.creer("Optimisation",self)
		}
	end

	#Méthode défini pour la popup à la demande de suppression des quicksave
	def valider()
		#Supprimer toutes les quicksave sans supprimer les parties en cours
		Dir.foreach(DIR_QUICKSAVE) do |filename|
			#Si le fichier n'est pas '.' (directory actuel) ou '..' (directory parent) ou qu'il ne commence pas par le nom du profil actif
			next if filename == '.' or filename == '..' or !filename.start_with?(@gestionnaire.getProfilActif().name)
			File.delete(DIR_QUICKSAVE+"#{filename}")
		end
	end

	#Méthode défini pour la popup à la demande de suppression des quicksave
	def refuser()
		#Ne fait rien si on refuse de supprimer les quicksave
	end

	#Méthode qui permet de bloquer l'accès à l'utilisateur à certaines fonctions
	# autoCompletion => (Boolean) L'etat de l'autoCompletion de la partie
	def retirerFonctionsCritiques(autoCompletion)
		#On set l'etat
		@builder.getVar("@btnCheckAutoCompl").set_active(autoCompletion)
		#A chaque fois que on clique on laisse l'etat non changé
		@builder.getVar("@btnCheckAutoCompl").signal_connect("clicked"){
			@builder.getVar("@btnCheckAutoCompl").set_active(autoCompletion)
		}
		@builder.getVar("@btnClearQuickSave").set_sensitive(false)
	end

end
