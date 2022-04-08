#Inclusion du fichier contenant le gestionnaire de partie
require_relative "../Partie/GestionnairePartie.rb"
#Inclusion des fichiers des popups
require_relative "../Popup/PopupVerification.rb"
require_relative "../Popup/PopupText.rb"
##################################
#Constante correspondant au dossier des images
DIR_IMG = "Image/"
#Constante correspondant à l'image de l'étoile vide
IMG_ETOILEVIDE = DIR_IMG+"etoileVide.png"
#Constante correspondant à l'image de l'étoile en argent
IMG_ETOILEARGENT = DIR_IMG+"etoileArgent.png"
#Constante correspondant à l'image de l'étoile en or
IMG_ETOILEOR = DIR_IMG+"etoileDoree.png"
##
#La classe Campagne représente l'object qui affiche le menu Campagne dans la fenetre du jeu
class Campagne < Menu
	# @gestionnaire	=> Le gestionnaire de menu attaché à l'acceuil
	#	@builder	=> Le builder qui instancie les différents widgets du fichier glade
	#	@grid	=> La grille qui contient tous les widgets de l'accueil
	# @difficulte => Niveau de difficulte de la partie

	#La méthode de classe creer permet d'appeler la méthode new et de rendre cette dernière inutilisable dans le but de rendre le code plus parlant
	def Campagne.creer(gestionnaire,difficulte)
		new(gestionnaire,difficulte)
	end

	#On rend la méthode de classe new private
	private_class_method :new

	#Méthode initialize permet de charger le menu campagne en créant tous les évenements aux différents widgets
	def initialize(gestionnaire,difficulte)
		@difficulte = difficulte

		#On appèle le builder avec le fichier correspondant
		@builder = Builder.new("Campagne.glade")

		#On appèle la méthode initialize de la superClasse
		super(gestionnaire)

		#On change le nom de la fenetre
		@gestionnaire.changerNom("-#{self.class} #{@difficulte}")

		#On attribue au label la difficulte choisie
		@builder.getVar("@lblDifficulte").set_markup("Grilles "+@difficulte)

		#On affecte un comportement à l'évenement clicked pour le boutton @btnRetour
		@builder.getVar("@btnRetour").signal_connect('clicked') {
			@gestionnaire.changerMenu(Jouer.creer(@gestionnaire))
		}

		#On affecte un comportement à l'évenement clicked pour le boutton @btnReset
		@builder.getVar("@btnReset").signal_connect('clicked') {
			#Popup qui demande de confirmer la reinitialisation des grilles séléctionnées
			PopupVerification.creer("Suppression ?",self)
		}

		#On associe à chaque button le comportement qui charge la bonne partie en fonction du bouton
		0.upto(14){|id|
			@builder.getVar("@btnJouer#{id}").signal_connect('clicked'){
				begin
					@gestionnaire.changerMenu(GestionnairePartie.creer(@gestionnaire,@difficulte,id))
				rescue PartieChargerError => e
					#On réaffiche le menu campagne
					@gestionnaire.changerMenu(self)
					#On remet à nil le gestionnairePartie dans le GestionnaireMenu (cf gestionnairePartie.rb)
					@gestionnaire.setGestioPartie(nil)
					PopupText.creer("Erreur","Erreur création partie : " + e.message)
				end
			}
		}

		#On affiche le score de chacune des partie ainsi que le temps
		afficherScores()
	end

	#Méthode défini pour la popup à la demande de reinitialisation des grilles séléctionnées
	def valider()
		0.upto(14){|button|
			if(@builder.getVar("@btnCheck#{button}").active?)
				@gestionnaire.getProfilActif().resetScore(@difficulte,button)
				GestionnairePartie.resetScore(@difficulte,button,@gestionnaire.getProfilActif.name)
				#On déséléctionne le checkButton
				@builder.getVar("@btnCheck#{button}").set_active(false)
			end
		}
		#On met à jours les scores
		afficherScores()
	end

	#Méthode défini pour la popup à la demande de reinitialisation des grilles séléctionnées
	def refuser()
		#On déséléctionne chaque checkButton
		0.upto(14){|button|
			@builder.getVar("@btnCheck#{button}").set_active(false)
		}
	end

	#Méthode qui affiche les scores des parties ainsi que leur temps
	def afficherScores()
		profil = @gestionnaire.getProfilActif()
		0.upto(14){|grille|
			#On récupère les infos de la grille
			infos = profil.getScore(@difficulte,grille)
			if(infos == nil)
				#Si il n'y a pas de score pour la grille on affiche 00:00
				@builder.getVar("@lblTps#{grille}").set_markup("00:00")
				@builder.getVar("@imgEtoile#{grille}#{1}").set_file(IMG_ETOILEVIDE)
			    @builder.getVar("@imgEtoile#{grille}#{2}").set_file(IMG_ETOILEVIDE)
			    @builder.getVar("@imgEtoile#{grille}#{3}").set_file(IMG_ETOILEVIDE)
			else
				@builder.getVar("@lblTps#{grille}").set_markup("#{(infos[1]/3600).to_i}:#{(infos[1]%3600)/60}")
			
				#On parcours pour les 3 étoiles
				if(infos == nil)
					#Si aucune info pour la grille on met une étoile vide
					#3 fois du coup
					1.upto(3){|y|
						@builder.getVar("@imgEtoile#{grille}#{y}").set_file(IMG_ETOILEVIDE)
					}
				else
					#Score d'une partie :
					# => De 0 à 9 --> 0 étoile
					# => De 10 à 19 --> 1 étoile
					# => De 20 à 29 --> 2 étoiles
					# => 30 --> 3 étoiles
					# => Auto-complétion activée --> étoiles argentées
					# => Auto-complétion désactivée --> étoiles dorées
					if(infos[0]>30)
						etoile = IMG_ETOILEOR
					else
						etoile = IMG_ETOILEARGENT
					end
					#Affichage des étoiles
					score = infos[0] #% 30
					#if(score == 0)
					if(score == 30 || score == 61)
			      @builder.getVar("@imgEtoile#{grille}#{1}").set_file(etoile)
			      @builder.getVar("@imgEtoile#{grille}#{2}").set_file(etoile)
			      @builder.getVar("@imgEtoile#{grille}#{3}").set_file(etoile)
			    #elsif(score >= 20)
					elsif((score >= 20 && score <30) || (score >= 50 && score < 60))
			      @builder.getVar("@imgEtoile#{grille}#{1}").set_file(etoile)
			      @builder.getVar("@imgEtoile#{grille}#{2}").set_file(etoile)
						@builder.getVar("@imgEtoile#{grille}#{3}").set_file(IMG_ETOILEVIDE)
			    #elsif(score >= 10)
					elsif((score >= 10 && score < 20) || (score >= 40 && score < 50))
			      @builder.getVar("@imgEtoile#{grille}#{1}").set_file(etoile)
						@builder.getVar("@imgEtoile#{grille}#{2}").set_file(IMG_ETOILEVIDE)
						@builder.getVar("@imgEtoile#{grille}#{3}").set_file(IMG_ETOILEVIDE)
					else
						@builder.getVar("@imgEtoile#{grille}#{1}").set_file(IMG_ETOILEVIDE)
						@builder.getVar("@imgEtoile#{grille}#{2}").set_file(IMG_ETOILEVIDE)
						@builder.getVar("@imgEtoile#{grille}#{3}").set_file(IMG_ETOILEVIDE)
			    end
				end
			end
			}

		end
end
