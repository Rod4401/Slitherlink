##
#La classe PopupBase permet de créer une popup, c'est une gtk::Window plus spécialisée
class PopupBase < Gtk::Window
  #La méthode de classe creer permet d'appeler la méthode new et de rendre cette dernière inutilisable dans le but de rendre le code plus parlant
  def PopupBase.creer(nom_fenetre)
    new(nom_fenetre)
  end

  #On rend la méthode de classe new private
  private_class_method :new

  #La méthode initialize permet de définir les paramètres de la popup
  def initialize(nom_fenetre)
    super()
    #On centre la popup à l'écran
    self.window_position=:center_always
    #On défini la taille de la popup
    self.set_size_request(300, 60)
    #On défini le nom de la fentre
    self.title=nom_fenetre
    #On set l'icone de la fenetre
    self.icon=FILE_ICON
    #On rend visible la fenetre
    self.show()

    #On connecte le signal 'destroy' pour que la fenetre se ferme en cas d'appui sur fermer
    self.signal_connect('destroy'){
      self.destroy
    }
  end
end
