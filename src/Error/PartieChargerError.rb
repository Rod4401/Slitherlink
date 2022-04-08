#Cette classe permet de définir une nouvelle Exception
#Cette Exception est levée lorsqu'il y a un souci au chargement d'une partie
class PartieChargerError < StandardError
  def initialize(msg)
    super(msg)
  end
end
