##
# La classe Profils représente l'object qui affiche le menu Profils dans la fenetre du jeu
class Profils < Menu
	# @gestionnaire	=> Le gestionnaire de menu attaché à l'acceuil
	#	@builder	=> Le builder qui instancie les différents widgets du fichier glade
	#	@grid	=> La grille qui contient tous les widgets de l'accueil

	#La méthode de classe creer permet d'appeler la méthode new et de rendre cette dernière inutilisable dans le but de rendre le code plus parlant
	def Profils.creer(gestionnaire)
		new(gestionnaire)
	end

	#On rend la méthode de classe new private
	private_class_method :new

	#Méthode initialize permet de charger le menu jouer à l'écran en créant tous les évenements aux différents widgets
	def initialize(gestionnaire)
		#On appèle le builder avec le fichier correspondant
		@builder = Builder.new("Profils.glade")

		#On appèle la méthode initialize de la superClasse
		super(gestionnaire)

		#On change le nom de la fenetre
		@gestionnaire.changerNom("-#{self.class}")

		#On affecte un comportement à l'évenement clicked pour le boutton @btnRetour
		@builder.getVar("@btnRetour").signal_connect('clicked') {
			@gestionnaire.changerMenu(Accueil.creer(@gestionnaire))
		}

		#Méthode qui remplit la combox avec tous les profils déjà crees
		editerBoxProfils()

		#On rend la textentry en invisible car par default
		#on ne veut pas saisir un nouveau nom d'utilisateur
		@builder.getVar("@boxNewUser").set_child_visible(false)
		@builder.getVar("@selectionUser").signal_connect('changed'){
			if(@builder.getVar("@selectionUser").active_text() == "Créer profil")
				@builder.getVar("@boxNewUser").set_child_visible(true)
			else
				#Si on a pas selectionné "Créer profil" alors on souhaite selectionner un profil
				@builder.getVar("@boxNewUser").set_child_visible(false)
				@gestionnaire.setProfilActif(@builder.getVar("@selectionUser").active_text())
			end
		}
		@builder.getVar("@btnValidate").signal_connect('clicked'){
			unless(@builder.getVar("@inNameUser").text.empty?())
				#Si ce n'est pas vide on peut créer un profil
				@gestionnaire.creerProfileUtilisateur(@builder.getVar("@inNameUser").text)
				@builder.getVar("@inNameUser").text=""
				@builder.getVar("@selectionUser").insert_text(@gestionnaire.getProfilActif().id,@gestionnaire.getProfilActif().name)
				@builder.getVar("@selectionUser").active=@gestionnaire.getProfilActif().id

			end
		}

		#On affecte un comportement à l'évenement clicked pour le boutton @btnSupprimer
		@builder.getVar("@btnSupprimer").signal_connect('clicked'){
			#puts "Suppression"
			if( @gestionnaire.getProfilActif().id > 1)
				#Dans a combox, chaque "item" possède un id
				#En l'occurence "Créer Profil (0) et Invité (1)"
				#On ne veut donc pas supprimer ces 2 "item"

				#Si ce n'est pas vide on peut supprimer un profil
				#puts "Gestionnaire : " + @gestionnaire.getProfilActif().to_s
				@gestionnaire.supprimerProfil()
				#self.editerBoxProfils()
				@builder.getVar("@selectionUser").remove_all()
				#Création de l'item "Créer profil"
				@builder.getVar("@selectionUser").insert_text(0,"Créer profil")
				#puts "User : " + @builder.to_s
				#Ajout de tous les profils au comboBox
				#puts "Gestionnaire : " + @gestionnaire.to_s
				@gestionnaire.listeProfils.each{|i|
					@builder.getVar("@selectionUser").insert_text(i.id,i.name)
				}
				#On selectionne le profil actif
				#puts "User : " + @gestionnaire.getProfilActif().to_s
				@builder.getVar("@selectionUser").active=1
			end
		}
	end

	#Méthode qui permet d'ajouter tous les profils à la combobox
	def editerBoxProfils()

		@builder.getVar("@selectionUser").remove_all()
		#Création de l'item "Créer profil"
		@builder.getVar("@selectionUser").insert_text(0,"Créer profil")
		#puts "User : " + @builder.to_s
		#Ajout de tous les profils au comboBox
		@gestionnaire.listeProfils.each{|i|
			@builder.getVar("@selectionUser").insert_text(i.id,i.name)
		}
		#On selectionne le profil actif
		#puts "User : " + @gestionnaire.getProfilActif().to_s
		@builder.getVar("@selectionUser").active=@gestionnaire.getProfilActif().id
	end
end
