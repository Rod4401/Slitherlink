##
#La classe Temps permet de représenté un compteur de temps
class Temps
	#@secondes => Le nombre de secondes écoulées
	#@minutes => Le nombre de minutes écoulées
	#@heures => Le nombre d'heures écoulées
	#@jours => Le nombre de jours écoulés
	#@pause	=> Boolean pour mettre en pause le thread
	#@continuer	=> Boolean pour faire tourner le thread

	#La méthode de classe creer permet d'appeler la méthode new et de rendre cette dernière inutilisable dans le but de rendre le code plus parlant
	def Temps.creer()
		new()
	end

	#On rend la méthode de classe new private
	private_class_method :new

	#Coding assistant
	attr_reader :secondes, :minutes, :heures, :jours

	#La méthode initialize permet de définir les variables d'instances
	def initialize
		@secondes = @minutes = @heures = @jours = 0
		@pause = false
		@continuer = true
		@limiteur = -1
	end

	#Méthode qui met en pause le thread
	def pause
		@pause = true
	end

	#Méthode qui coupe le thread définitivement
	def kill
		@continuer = false
	end

	#Méthode qui renvoie le nombre de secondes totales écoulées
	def getTemps()
		@jours * 86400 + @heures * 3600 + @minutes * 60 + @secondes
	end

	#Méthode qui permet de compter le temps
	# => Crée un thread qui tourne tant que @continuer vaut true
	# => Attend 1 seconde et incrémente les secondes
	def run(gestionnairePartie)
		self.afficheTemps(gestionnairePartie)
		@continuer = true
		#Création du thread
		Thread.new do
			while(@continuer && (@limiteur == -1 || getTemps() <@limiteur)) do
				if(!@pause)
					@secondes+=1
					sleep(1)
					#Transformation des secondes en minures
					if @secondes >= 60
						@secondes -= 60
						@minutes += 1
					end

					#Transformation des minutes en heures
					if @minutes >= 60
						@minutes -= 60
						@heures += 1
					end

					#Transformation des heures en jours
					if @heures >= 24
						@heures -= 24
						@jours += 1
					end
					#Envoie un message au gestionnaire de partie qui va afficher le temps total
					self.afficheTemps(gestionnairePartie)
				end
			end
		end
	end

	#Méthode qui demande au gestionnaire d'afficher le temps
	def afficheTemps(gestionnairePartie)
		if(@limiteur != -1)
			secondes = @limiteur - @secondes - @minutes*60
			minutes = (secondes/60).round.to_i
			secondes%=60
			gestionnairePartie.afficheTemps(secondes, minutes, 0,0)
		else
			gestionnairePartie.afficheTemps(@secondes, @minutes, @heures, @jours)
		end
	end

	#Methode qui permet de definir une limite de temps
	def limiteur(nombre_secondes)
		@limiteur = nombre_secondes
	end

	#Méthode de réinitialisation du compteur
	def reinitialiser()
		@secondes = @minutes = @heures = @jours = 0
	end
end
