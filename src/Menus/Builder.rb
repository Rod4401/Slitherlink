DIRFILEGLADE = "FileGlade/"

##
#La classe builder a pour but de générer les variables d'instances (les widgets) dynamiquement à partir d'un fichier glade
class Builder < Gtk::Builder
	#la méthode initialize va permettre au builder d'executer son unique tâche c'est-à-dire de générer les variables d'instances à partir du fichier glade
	def initialize(file)
		super()
		#On ajoute au builder le lien du fichier glade
		self.add_from_file(DIRFILEGLADE+file)
		#puts "Création des variables d'instances"
		self.objects.each() { |p|
			unless p.builder_name.start_with?("___object")
				#puts "\tCreation de la variable d'instance @#{p.builder_name}"
				instance_variable_set("@#{p.builder_name}".intern, self[p.builder_name])
			end
		}
	end

	#Méthode qui renvoie la grid c'est-à-dire le Gtk::Grid qui contient tous les widgets générés avec le builder
	def getGrid()
		@grid
	end

	#Méthode qui renvoie la variable d'instance correspodant au nom passé en paramètre
	def getVar(name)
		instance_variable_get(name)
	end

	#Méthode qui permet de changer le thème de tous les widgets générés avec le builder
	def changerTheme(theme)
		begin
			#On parcours toutes les variables d'instances
			self.instance_variables.each{ |i|
				#Si ce n'est pas des éléments d'une partie
				next if(i.to_s.start_with?("@lblCase_") || i.to_s.start_with?("@lblCoin_") || i.to_s.start_with?("@btnMur_"))
				#On applique le thème choisi
				instance_variable_get("#{i}").style_context.add_provider(theme, Gtk::StyleProvider::PRIORITY_USER)
			}
		rescue
			#Si il y a eu un souci avec le css on créer un thème de secours
			theme_secours = Gtk::CssProvider.new
			theme_secours.load(path: DIR_CSS+"white.css")
			self.instance_variables.each{ |i|
				next if(i.to_s.start_with?("@lblCase_") || i.to_s.start_with?("@lblCoin_") || i.to_s.start_with?("@btnMur_"))
				instance_variable_get("#{i}").style_context.add_provider(theme_secours, Gtk::StyleProvider::PRIORITY_USER)
			}
		end
	end

	#Méthode qui génère dynamiquement la grille du jeu en fonction de la taille (nombre de cases)
	def genererGrille(taille,size_cases,cssCase,theme)
		#Récupération du css correspodant aux murs du plateau
		css_buttonVertical = Gtk::CssProvider.new
		css_buttonHorizontal = Gtk::CssProvider.new
		case theme
		when THEME_WHITE
			css_buttonVertical.load(path: DIR_CSS+"MurPartieVerticalWhite.css")
			css_buttonHorizontal.load(path: DIR_CSS+"MurPartieHorizontalWhite.css")
		when THEME_DARK
			css_buttonVertical.load(path: DIR_CSS+"MurPartieVerticalDark.css")
			css_buttonHorizontal.load(path: DIR_CSS+"MurPartieHorizontalDark.css")
		end

		#Récupération du css correspodant aux coins du plateau
		css_points = Gtk::CssProvider.new
		css_points.load(path: DIR_CSS+"CoinPartie.css")

		#Récupération du css correspodant aux cases du plateau
		css_Valeurs = Gtk::CssProvider.new
		css_Valeurs.load(path: DIR_CSS+cssCase)


		0.upto(taille*2){ |x|
			0.upto(taille*2){ |y|
				if(x%2 == 1 && y%2 == 1)
					#=====Les cases=====
					#Une case s'appelle @lblCase.x.y
					self.instance_variable_set("@lblCase_#{x}_#{y}",Gtk::Label.new("", {:use_underline => true}))
					variable = self.instance_variable_get("@lblCase_#{x}_#{y}")
					variable.style_context.add_provider(css_Valeurs, Gtk::StyleProvider::PRIORITY_USER)
					variable.set_size_request(size_cases, size_cases)
				elsif(x%2 == 0 && y%2 == 0)
					#=====Les coins=====
					#Un coin s'appelle @lblCoin.x.y
					self.instance_variable_set("@lblCoin_#{x}_#{y}",Gtk::Label.new("", {:use_underline => true}))
					variable = self.instance_variable_get("@lblCoin_#{x}_#{y}")
					variable.style_context.add_provider(css_points, Gtk::StyleProvider::PRIORITY_USER)
				else
					#=====Les murs=====
					#Un coin s'appelle @btnMur.x.y
					self.instance_variable_set("@btnMur_#{x}_#{y}",Gtk::Button.new)
					variable = self.instance_variable_get("@btnMur_#{x}_#{y}")
					if(x%2 == 0)
						variable.style_context.add_provider(css_buttonHorizontal, Gtk::StyleProvider::PRIORITY_USER)
					else
						variable.style_context.add_provider(css_buttonVertical, Gtk::StyleProvider::PRIORITY_USER)
					end

				end
				#On fixe sur la grille du jeu le widget créé avec ses coordonnées et sa taille (1,1)
				@grilleJeu.attach(variable,x,y,1,1)
			}
		}
	end
end
