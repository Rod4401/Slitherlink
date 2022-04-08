##
# Editeur de grille
# Réalisé par Yohann Delacroix
require 'gtk3'
require 'yaml'
require_relative 'Case.rb'
require_relative 'Mur.rb'

TAILLE_FACILE = 5
TAILLE_MOYEN = 8
TAILLE_DIFFICILE = 10

puts "Editeur de Grille : "
puts "Les murs à placer sont représentés par des @"
puts "Le numéro à l'interieur de la case indique le numero affiché à l'écran,  -1 pour rien"
puts "Définir la taille de la grille 5:Facile _ 8:Moyen _ 10:Difficile"
@taille = 0
while @taille != TAILLE_FACILE && @taille != TAILLE_MOYEN && @taille != TAILLE_DIFFICILE
	@taille = gets.to_i
end

puts "Taille choisie : #{@taille}"

@tab_save = Array.new(2)#Tableau de données à sauvegarder
@tab_cases = Array.new((@taille*2)+1){Array.new((@taille*2)+1){nil}} #TABLEAU DE CASES
@tab_murs = Array.new((@taille*2)+1){Array.new((@taille*2)+1){nil}} #TABLEAU DE MURS


#Incrémente la valeur de la case ciblée
def clickCase(x,y, button_case)
	@tab_cases[x][y].increaseNumero()
	puts "Incrémentation de la case #{x},#{y}"
	button_case.set_label(@tab_cases[x][y].getNumero)
end

def clickMur(x,y, button_mur)
	@tab_murs[x][y].changeWallState()
	puts "Changement d'état du mur #{x},#{y}"
	button_mur.set_label(@tab_murs[x][y].getState)
end

#Méthode qui génère dynamiquement la grille du jeu en fonction de la taille (nombre de cases)
	def genererGrille(taille,size_cases)
		0.upto(taille*2){ |x|
			0.upto(taille*2){ |y|
				if(x%2 == 1 && y%2 == 1)
					#=====Les cases=====
					#Une case s'appelle @lblCase.x.y
					self.instance_variable_set("@lblCase_#{x}_#{y}",Gtk::Button.new)
					variable = self.instance_variable_get("@lblCase_#{x}_#{y}")

					@tab_cases[x][y] = Case.creer(x,y)
					#Action à effectuer lorsqu'on clique sur une case
					variable.signal_connect('clicked'){clickCase(x,y,variable)}

					variable.set_size_request(size_cases, size_cases)
				elsif(x%2 == 0 && y%2 == 0)
					#=====Les coins=====
					#Un coin s'appelle @lblCoin.x.y
					self.instance_variable_set("@lblCoin_#{x}_#{y}",Gtk::Label.new("", {:use_underline => true}))
					variable = self.instance_variable_get("@lblCoin_#{x}_#{y}")

				else
					#=====Les murs=====
					#Un coin s'appelle @btnMur.x.y
					self.instance_variable_set("@btnMur_#{x}_#{y}",Gtk::Button.new)
					variable = self.instance_variable_get("@btnMur_#{x}_#{y}")


					@tab_murs[x][y] = Mur.creer()
					#Action à effectuer lorsqu'on clique sur un mur
					variable.signal_connect('clicked'){clickMur(y,x,variable)}
				end
				#On fixe sur la grille du jeu le widget créé avec ses coordonnées et sa taille (1,1)
				@grilleJeu.attach(variable,x,y,1,1)
			}
		}
	end

def onDestroy
  puts "Fin de l'application"
	Gtk.main_quit
	#Sauvegarder
	@tab_save[0] = @tab_cases
	@tab_save[1] = @tab_murs
	string = @tab_save.to_yaml

	puts "Entrer le numéro du fichier ou -1 pour annuler"
	file_number = gets.to_i
	if(file_number == -1)
		return
	end

	case @taille
	when TAILLE_FACILE
		file = File.open("../src/Saves/faciles/#{file_number}.default","w")
	when TAILLE_MOYEN
		file = File.open("../src/Saves/normales/#{file_number}.default","w")
	when TAILLE_DIFFICILE
		file = File.open("../src/Saves/difficiles/#{file_number}.default","w")
	end

	begin
		file.write(string)
		file.close
	rescue
		puts "La taille de la grille n'était pas valide"
	end

end






@grilleJeu = Gtk::Grid.new

@monApp = Gtk::Window.new

@monApp.set_title("Editeur de grille")
@monApp.set_default_size(800,600)
@monApp.set_window_position(Gtk::WindowPosition::CENTER_ALWAYS)

frame = Gtk::Table.new(2,2,true)

genererGrille(@taille,1)

@monApp.add(@grilleJeu)

@monApp.show_all
@monApp.signal_connect('destroy'){onDestroy}

Gtk.main
