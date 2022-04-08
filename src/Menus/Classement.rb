class Classement < Menu

	def Classement.creer(gestionnaire)
		new(gestionnaire)
	end

  def initialize(gestionnaire)

    #On appèle le builder avec le fichier correspondant à l'accueil
		@builder = Builder.new("Classement.glade")
    super(gestionnaire)

    #On change le nom de la fenetre
		@gestionnaire.changerNom("-#{self.class}")

    #On affecte un comportement à l'évenement clicked pour le boutton @btnRetour
		@builder.getVar("@btnRetour").signal_connect('clicked') {
			@gestionnaire.changerMenu(Accueil.creer(@gestionnaire))
		}

    #Récupérer la liste des profils ()    def listeProfils()
    listeProfils = @gestionnaire.listeProfils()

    #Création d'une table de hachage
    hashProfils = Hash.new()
    listeProfils.each{ |p|
      hashProfils[p.name] = p.getScores()
    }

    #Tri de la table selon le score
    hashProfils = hashProfils.sort_by{|key,value| value}.reverse.to_h


    #Traitement de la table et affichage du classement
    rang = 1
    hashProfils.each{ |key,value|
      puts("#{rang}. Nom : #{key} Score : #{value} ")
      rang += 1
    }

    #Créer une grid
    grid = Gtk::Grid.new()
    grid.set_column_spacing(10)
		grid.set_row_spacing(10)
    grid.set_column_homogeneous(true)
		grid.set_row_homogeneous(true)
    grid.set_border_width(5)
    @builder.getVar("@listeProfils").add(grid);


    #Traitement de la table et affichage du classement
    rang = 1
    hashProfils.each{ |key,value|

      rang_lb = Gtk::Label.new("#{rang}")
      grid.attach(rang_lb, 0, rang-1, 1, 1)
      name = Gtk::Label.new("#{key}")
      grid.attach(name, 1, rang-1, 1, 1)
      score = Gtk::Label.new("#{value}")
      grid.attach(score, 2, rang-1, 1, 1)

      rang += 1
    }


  end




end
