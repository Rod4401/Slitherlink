##
require_relative '../Popup/PopupAide.rb'

# La classe aide ...
class Aide
  # @partie	=> La partie à aider

  #On inclue le module Difficulte dans la classe
  include Difficulte

  def Aide.creer(partie)
    new(partie)
  end

  private_class_method :new

  def initialize(partie)
    @partie = partie
  end

  #Methode qui execute l'autoCompletion sur toute les cases
  def autoCompletionAll
      taille = to_i(@partie.difficulte,NB_CASES_FACILE,NB_CASES_MOYEN,NB_CASES_DIFFICILE)
      @partie = taille
      cases = @partie.getCases

      0.upto(taille*2){ |x|
      0.upto(taille*2){ |y|
        autoCompletion(cases[x][y])
      }
    }

  end

  def demandeAide

  end

  def checkAll
    cases = @partie.getCases
    taille = to_i(@partie.difficulte,NB_CASES_FACILE,NB_CASES_MOYEN,NB_CASES_DIFFICILE)
    0.upto(taille*2){ |x|
      0.upto(taille*2){ |y|
        if(x%2 == 1 && y%2 == 1)
          if(cases[x][y].estCorrect == false)
            return false
          end
        end
      }
    }
    return true
  end

  def compteErreur
    nbErr = 0
    0.upto(@partie.plateau.taille*2){ |x|
      0.upto(@partie.plateau.taille*2){ |y|
        if((x%2 == 0 && y%2 == 1) || (x%2 == 1 && y%2 == 0))
          if(@partie.plateau.listeMurs[x][y].etat != 0 && @partie.plateau.listeMurs[x][y].etat != @partie.plateau.listeMurs[x][y].etatCorrect)
            nbErr += 1
          end
        end
      }
    }
    return nbErr
  end




  def resolveur(unCase)
    while(!laCase.estCorrect)

      if(!laCase.getMur(x+1,y).estCorrect && laCase.getMur(x+1,y) != 0)
        laCase.getMur(x+1,y).changerEtat
      end

      if(!laCase.getMur(x-1,y).estCorrect && laCase.getMur(x-1,y) != 0)
        laCase.getMur(x+1,y).changerEtat
      end

      if(!laCase.getMur(x,y+1).estCorrect && laCase.getMur(x,y+1) != 0)
        laCase.getMur(x+1,y).changerEtat
      end

      if(!laCase.getMur(x,y-1).estCorrect && laCase.getMur(x,y-1) != 0)
        laCase.getMur(x+1,y).changerEtat
      end
    end
  end


  #Cherche une méthode disponible parmis les méthodes des techniques applicables
  def chercherTechniqueApplicable()
    puts "Recherche d'une technique applicable"
    if( noLineBetween0() != true) then
      if( adjacent0et3() != true ) then
        if( diagonale0et3() != true ) then
          if( adjacent3et3() != true ) then
            if( diagonale3et3() != true ) then
              if( contrainte3() != true ) then
                if( contrainte2() != true ) then
                  if( coin() != true ) then
                    if( boucleAtteignant1() != true ) then
                      if( boucleAtteignant3() != true ) then
                        #Affichage d'une pop-up qui informe qu'aucune technique n'est proposée
                        PopupAide.creer("Aide Technique", "Plus d'aide en réserve", "", "")
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  #Recherche dans la grille un cas ou un 0 serait entouré par une ligne
  # Retourne VRAI si des lignes se trouvent autour d'au moins un zéro
  # Retourne FAUX sinon
  def noLineBetween0()
    taille = to_i(@partie.difficulte,NB_CASES_FACILE,NB_CASES_MOYEN,NB_CASES_DIFFICILE)
    cases = @partie.getCases

    0.upto(taille*2){ |x|
      0.upto(taille*2){ |y|

        if(x%2 != 0 && y%2 != 0)#Si on est sur une case
          if(cases[y][x].numero == 0)#Si la case est un 0
            #puts "Traitement case [#{y},#{x}]"
            #Recupérer la liste des murs autour
            listeDeMur = cases[x][y].listeDesMursAutour();
            #Parcourir la liste de mur
            listeDeMur.each{ |m|
              #Si mur est REMPLI
              #puts "m.etat = #{m.etat}"
              if(m.etat == 1)
                puts "AIDE TECHNIQUE : Un zero est entourée de plusieurs murs: VRAI"
                PopupAide.creer("Aide Technique","Les zéros ne doivent pas être entourés de lignes", "Image/1254.gif", "Image/1255.gif")
                return true
              end
             }

          end
        end
      }
    }
    return false
  end

  #méthode adjacent0et3 recherche un 0 et 3 adjacent
  # => Si elle détecte une anomalie elle renvoie true
  def adjacent0et3()
    puts "RECHERCHE ADJACENT 0 et 3"
    checkFinal = false #Boolean qui sera mit à true si on trouve un cas à améliorer via cette technique
    taille = to_i(@partie.difficulte,NB_CASES_FACILE,NB_CASES_MOYEN,NB_CASES_DIFFICILE)
    cases = @partie.getCases
    plateau = @partie.plateau

    #Parcours du plateau
    0.upto(taille*2){ |x|
      0.upto(taille*2){ |y|
        if(x%2 != 0 && y%2 != 0)#Si on est sur une case
          if(cases[x][y].numero == 0)#Si la case est un 0
            puts "Traitement case 0 [#{x},#{y}]"
            #Recupérer une liste des cases adjacentes
            listeCasesAdjacentes = cases[x][y].casesAdjacentes()

            #Parcourir
            listeCasesAdjacentes.each{ |c|
              #Si cette case possède un 3 adjacent
              if(c.numero == 3) then
                puts("0 et 3 adjacents trouvés, 0:{#{x},#{y}}, 3:{#{c.x},#{c.y}}")
                pos_rel = cases[x][y].trouverPositionRelativeA(c)
                puts("Pos rel : #{pos_rel}")

                 #Selon la position du 3 par rapport au 0
                case(pos_rel)
                when SUD #Pour tester , lancer normal grille 2
                  #Objectif 1 : Déterminer si les murs autour du 3 sont tous bien placés
                  if(plateau.getMur(y+1,x+2).etat != REMPLI) then
                    puts("a: Erreur mur VIDE #{x+2},#{y+1}")
                    checkFinal = true
                  elsif(plateau.getMur(y+2,x+1).etat != REMPLI) then
                    puts("b: Erreur mur VIDE #{x+1},#{y+2}")
                    checkFinal = true
                  elsif(plateau.getMur(y+3,x).etat != REMPLI) then
                    puts("c: Erreur mur VIDE #{x},#{y+3}")
                    checkFinal = true
                  elsif(plateau.getMur(y+2,x-1).etat != REMPLI) then
                    puts("d: Erreur mur VIDE #{x-1},#{y+2}")
                    checkFinal = true
                  elsif(plateau.getMur(y+1,x-2).etat != REMPLI) then
                    puts("e: Erreur mur VIDE #{x-2},#{y+1}")
                    checkFinal = true
                  end

                  #Objectif 2 : Déterminer si des murs placés n'ont pas à être placés
                  if(plateau.murExiste?(y+3, x+2))then
                    if(plateau.getMur(y+3, x+2).etat == REMPLI) then
                      puts("w: Erreur mur REMPLI #{x+2},#{y+3}")
                      checkFinal = true
                    end
                  end
                  if(plateau.murExiste?(y+4, x+1))then
                    if(plateau.getMur(y+4, x+1).etat == REMPLI)then
                      puts("x: Erreur mur REMPLI #{x+1},#{y+4}")
                      checkFinal = true
                    end
                  end
                  if(plateau.murExiste?(y+4, x-1))then
                    if(plateau.getMur(y+4, x-1).etat == REMPLI)then
                      puts("y: Erreur mur REMPLI #{x-1},#{y+4}")
                      checkFinal = true
                    end
                  end
                  if(plateau.murExiste?(y+3, x-2))then
                    if(plateau.getMur(y+3, x-2).etat == REMPLI)then
                      puts("z: Erreur mur REMPLI #{x-2},#{y+3}")
                      checkFinal = true
                    end
                  end

                when NORD #Pour tester , lancer facile grille 4
                  #Objectif 1 : Déterminer si les murs autour du 3 sont tous bien placés
                  if(plateau.getMur(y-1,x+2).etat != REMPLI) then
                    puts("a: Erreur mur VIDE #{x+2},#{y-1}")
                    checkFinal = true
                  elsif(plateau.getMur(y-2,x+1).etat != REMPLI) then
                    puts("b: Erreur mur VIDE #{x+1},#{y-2}")
                    checkFinal = true
                  elsif(plateau.getMur(y-3,x).etat != REMPLI) then
                    puts("c: Erreur mur VIDE #{x},#{y+3}")
                    checkFinal = true
                  elsif(plateau.getMur(y-2,x-1).etat != REMPLI) then
                    puts("d: Erreur mur VIDE #{x-1},#{y-2}")
                    checkFinal = true
                  elsif(plateau.getMur(y-1,x-2).etat != REMPLI) then
                    puts("e: Erreur mur VIDE #{x-2},#{y-1}")
                    checkFinal = true
                  end


                  #Objectif 2 : Déterminer si des murs placés n'ont pas à être placés
                  if(plateau.murExiste?(y-3, x+2))then
                    if(plateau.getMur(y-3, x+2).etat == REMPLI) then
                      puts("w: Erreur mur REMPLI #{x+2},#{y-3}")
                      checkFinal = true
                    end
                  end
                  if(plateau.murExiste?(y-4, x+1))then
                    if(plateau.getMur(y-4, x+1).etat == REMPLI)then
                      puts("x: Erreur mur REMPLI #{x+1},#{y-4}")
                      checkFinal = true
                    end
                  end
                  if(plateau.murExiste?(y-4, x-1))then
                    if(plateau.getMur(y-4, x-1).etat == REMPLI)then
                      puts("y: Erreur mur REMPLI #{x-1},#{y-4}")
                      checkFinal = true
                    end
                  end
                  if(plateau.murExiste?(y-3, x-2))then
                    if(plateau.getMur(y-3, x-2).etat == REMPLI)then
                      puts("z: Erreur mur REMPLI #{x-2},#{y-3}")
                      checkFinal = true
                    end
                  end

                when EST #Pour tester , lancer normal grille 8
                  #Objectif 1 : Déterminer si les murs autour du 3 sont tous bien placés
                  if(plateau.getMur(y-2,x+1).etat != REMPLI) then
                    puts("a: Erreur mur VIDE #{x+1},#{y-2}")
                    checkFinal = true
                  elsif(plateau.getMur(y-1,x+2).etat != REMPLI) then
                    puts("b: Erreur mur VIDE #{x+2},#{y-1}")
                    checkFinal = true
                  elsif(plateau.getMur(y,x+3).etat != REMPLI) then
                    puts("c: Erreur mur VIDE #{x+3},#{y}")
                    checkFinal = true
                  elsif(plateau.getMur(y+1,x+2).etat != REMPLI) then
                    puts("d: Erreur mur VIDE #{x+2},#{y+1}")
                    checkFinal = true
                  elsif(plateau.getMur(y+2,x+1).etat != REMPLI) then
                    puts("e: Erreur mur VIDE #{x+1},#{y+2}")
                    checkFinal = true
                  end

                  #Objectif 2 : Déterminer si des murs placés n'ont pas à être placés
                  if(plateau.murExiste?(y-2, x+3))then
                    if(plateau.getMur(y-2, x+3).etat == REMPLI) then
                      puts("Erreur mur REMPLI #{x+3},#{y-2}")
                      checkFinal = true
                    end
                  end
                  if(plateau.murExiste?(y-1, x+4))then
                    if(plateau.getMur(y-1, x+4).etat == REMPLI)then
                      puts("Erreur mur REMPLI #{x+4},#{y-1}")
                      checkFinal = true
                    end
                  end
                  if(plateau.murExiste?(y+2, x+3))then
                    if(plateau.getMur(y+2, x+3).etat == REMPLI)then
                      puts("Erreur mur REMPLI #{x+3},#{y+2}")
                      checkFinal = true
                    end
                  end
                  if(plateau.murExiste?(y+1, x+4))then
                    if(plateau.getMur(y+1, x+4).etat == REMPLI)then
                      puts("Erreur mur REMPLI #{x+4},#{y+1}")
                      checkFinal = true
                    end
                  end

                when OUEST#Pour tester , lancer normal grille 10
                  #Objectif 1 : Déterminer si les murs autour du 3 sont tous bien placés
                  if(plateau.getMur(y-2,x-1).etat != REMPLI) then
                    puts("a: Erreur mur VIDE #{x-1},#{y-2}")
                    checkFinal = true
                  elsif(plateau.getMur(y-1,x-2).etat != REMPLI) then
                    puts("b: Erreur mur VIDE #{x-2},#{y-1}")
                    checkFinal = true
                  elsif(plateau.getMur(y,x-3).etat != REMPLI) then
                    puts("c: Erreur mur VIDE #{x-3},#{y}")
                    checkFinal = true
                  elsif(plateau.getMur(y+1,x-2).etat != REMPLI) then
                    puts("d: Erreur mur VIDE #{x-2},#{y+1}")
                    checkFinal = true
                  elsif(plateau.getMur(y+2,x-1).etat != REMPLI) then
                    puts("e: Erreur mur VIDE #{x-1},#{y+2}")
                    checkFinal = true
                  end

                  #Objectif 2 : Déterminer si des murs placés n'ont pas à être placés
                  if(plateau.murExiste?(y-2, x-3))then
                    if(plateau.getMur(y-2, x-3).etat == REMPLI) then
                      puts("Erreur mur REMPLI #{x-3},#{y-2}")
                      checkFinal = true
                    end
                  end
                  if(plateau.murExiste?(y-1, x-4))then
                    if(plateau.getMur(y-1, x-4).etat == REMPLI)then
                      puts("Erreur mur REMPLI #{x-4},#{y-1}")
                      checkFinal = true
                    end
                  end
                  if(plateau.murExiste?(y+2, x-3))then
                    if(plateau.getMur(y+2, x-3).etat == REMPLI)then
                      puts("Erreur mur REMPLI #{x-3},#{y+2}")
                      checkFinal = true
                    end
                  end
                  if(plateau.murExiste?(y+1, x-4))then
                    if(plateau.getMur(y+1, x-4).etat == REMPLI)then
                      puts("Erreur mur REMPLI #{x-4},#{y+1}")
                      checkFinal = true
                    end
                  end
                end
              end
            }
          end
        end
      }
    }

    #Affichage de la popup si une anomalie a été trouvée
    if(checkFinal == true) then
      PopupAide.creer("Aide Technique","Cas des 0 et 3 adjacents\n5 Murs sont placés en rouge\n4 murs sont toujours inexistants (croix rouges)", "Image/1256.gif", "Image/1257.gif")
    end
    return checkFinal
  end


  #diagonale0et3 ()
  # => retourne true lorsqu'une anomalie a été trouvée dans le modèle de cette technique
  def diagonale0et3()
    checkFinal = false #Boolean qui sera mit à true si on trouve un cas à améliorer via cette technique
    taille = to_i(@partie.difficulte,NB_CASES_FACILE,NB_CASES_MOYEN,NB_CASES_DIFFICILE)
    cases = @partie.getCases
    plateau = @partie.plateau

    #Parcours du plateau
    0.upto(taille*2){ |x|
      0.upto(taille*2){ |y|
        if(x%2 != 0 && y%2 != 0)#Si on est sur une case
          if(cases[x][y].numero == 0)#Si la case est un 0
            puts "Traitement case 0 [#{x},#{y}]"
            #Recupérer une liste des cases en diagonale
            listeCasesDiagonales = cases[x][y].casesDiagonales()
            #Parcourir
            listeCasesDiagonales.each{ |c|
              #Si cette case possède un 3 adjacent
              if(c.numero == 3) then
                puts "3 en diagonale trouvé : [#{c.x},#{c.y}]"
                pos_rel = cases[x][y].trouverPositionRelativeA(c)
                puts("Pos rel : #{pos_rel}")

                #Selon la position du 3 par rapport au 0
                case(pos_rel)
                when NORDOUEST#Test : FacileGrille5
                  if(plateau.getMur(y-1,x-2).etat != REMPLI) then
                    puts("a: Erreur mur VIDE #{x-2},#{y-1}")
                    checkFinal = true
                  elsif(plateau.getMur(y-2,x-1).etat != REMPLI) then
                    puts("b: Erreur mur VIDE #{x-1},#{y-2}")
                    checkFinal = true
                  end
                when NORDEST#Test: FacileGrille7
                  if(plateau.getMur(y-2,x+1).etat != REMPLI) then
                    puts("a: Erreur mur VIDE #{x+1},#{y-2}")
                    checkFinal = true
                  elsif(plateau.getMur(y-1,x+2).etat != REMPLI) then
                    puts("b: Erreur mur VIDE #{x+2},#{y-1}")
                    checkFinal = true
                  end
                when SUDEST #Test: Grille normale 1
                  if(plateau.getMur(y+1,x+2).etat != REMPLI) then
                    puts("a: Erreur mur VIDE #{x+2},#{y+1}")
                    checkFinal = true
                  elsif(plateau.getMur(y+2,x+1).etat != REMPLI) then
                    puts("b: Erreur mur VIDE #{x+1},#{y+2}")
                    checkFinal = true
                  end
                when SUDOUEST #TestFacileGrille3
                  if(plateau.getMur(y+2,x-1).etat != REMPLI) then
                    puts("a: Erreur mur VIDE #{x-1},#{y+2}")
                    checkFinal = true
                  elsif(plateau.getMur(y+1,x-2).etat != REMPLI) then
                    puts("b: Erreur mur VIDE #{x-2},#{y+1}")
                    checkFinal = true
                  end
                end
              end
            }
          end
        end
      }
    }
    #Affichage de la popup si une anomalie a été trouvée
    if(checkFinal == true) then
      PopupAide.creer("Aide Technique","Cas des 0 et 3 en diagonale \n2 Murs sont placés en rouge", "Image/1258.gif/", "Image/1259.gif")
    end
    return checkFinal
  end

  #adjacent3et3 ()
  # Recherche les cas de 3 adjacents
  # => retourne true lorsqu'une anomalie a été trouvée dans le modèle de cette technique
  def adjacent3et3()
    checkFinal = false #Boolean qui sera mit à true si on trouve un cas à améliorer via cette technique
    taille = to_i(@partie.difficulte,NB_CASES_FACILE,NB_CASES_MOYEN,NB_CASES_DIFFICILE)
    cases = @partie.getCases
    plateau = @partie.plateau

    #Parcours du plateau
    0.upto(taille*2){ |x|
      0.upto(taille*2){ |y|
        if(x%2 != 0 && y%2 != 0)#Si on est sur une case
          if(cases[x][y].numero == 3)#Si la case est un 3
            puts "Traitement case 3 [#{x},#{y}]"
            #Recupérer une liste des cases adjacentes
            listeCasesAdjacentes = cases[x][y].casesAdjacentes()
            #Parcourir
            listeCasesAdjacentes.each{ |c|
              #Si cette case possède un 3 adjacent
              if(c.numero == 3) then
                puts("3 et 3 adjacents trouvés, 3:{#{x},#{y}}, 3:{#{c.x},#{c.y}}")
                pos_rel = cases[x][y].trouverPositionRelativeA(c)
                puts("Pos rel : #{pos_rel}")

                #Selon la position du premier 3 trouvé avec le deuxième
                case(pos_rel)
                when SUD #Sud compte pour NORD , cela évite le traitement en double
                  #Objectif 1 : Déterminer si les murs autour du 3 sont tous bien placés
                  if(plateau.getMur(y-1,x).etat != REMPLI) then
                    puts("a: Erreur mur VIDE #{x},#{y-1}")
                    checkFinal = true
                  elsif(plateau.getMur(y+1,x).etat != REMPLI) then
                    puts("b: Erreur mur VIDE #{x},#{y+1}")
                    checkFinal = true
                  elsif(plateau.getMur(y+3,x).etat != REMPLI) then
                    puts("c: Erreur mur VIDE #{x},#{y+3}")
                    checkFinal = true
                  end

                  #Objectif 2 : Déterminer si des murs placés n'ont pas à être placés
                  if(plateau.murExiste?(y+1, x+2))then
                    if(plateau.getMur(y+1, x+2).etat == REMPLI) then
                      puts("w: Erreur mur REMPLI #{x+2},#{y+1}")
                      checkFinal = true
                    end
                  end
                  if(plateau.murExiste?(y+1, x-2))then
                    if(plateau.getMur(y+1, x-2).etat == REMPLI)then
                      puts("x: Erreur mur REMPLI #{x-2},#{y+1}")
                      checkFinal = true
                    end
                  end

                #Ici OUEST compte aussi pour EST sinon le traitement sera effectué en doublon
                when OUEST#Pour tester , lancer normal grille 2 ou 4
                  #Objectif 1 : Déterminer si les murs autour du 3 sont tous bien placés
                  if(plateau.getMur(y,x+1).etat != REMPLI) then
                    puts("a: Erreur mur VIDE #{x+1},#{y}")
                    checkFinal = true
                  elsif(plateau.getMur(y,x-1).etat != REMPLI) then
                    puts("b: Erreur mur VIDE #{x-1},#{y}")
                    checkFinal = true
                  elsif(plateau.getMur(y,x-3).etat != REMPLI) then
                    puts("c: Erreur mur VIDE #{x-3},#{y}")
                    checkFinal = true
                  end

                  #Objectif 2 : Déterminer si des murs placés n'ont pas à être placés
                  if(plateau.murExiste?(y+2, x-1))then
                    if(plateau.getMur(y+2, x-1).etat == REMPLI) then
                      puts("Erreur mur REMPLI #{x-1},#{y+2}")
                      checkFinal = true
                    end
                  end
                  if(plateau.murExiste?(y-2, x-1))then
                    if(plateau.getMur(y-2, x-1).etat == REMPLI)then
                      puts("Erreur mur REMPLI #{x-1},#{y-2}")
                      checkFinal = true
                    end
                  end
                end
              end
            }
          end
        end
      }
    }

    #Affichage de la popup si une anomalie a été trouvée
    if(checkFinal == true) then
      PopupAide.creer("Aide Technique","Cas des 3 et 3 adjacents \n3 Murs sont placés en rouge\n2 Murs ne sont jamais placés (croix en rouge)", "Image/1260.gif", "Image/1261.gif")
    end
    return checkFinal
  end

  #diagonale3et3 ()
  # Recherche les 3 en diagonales
  # => retourne true lorsqu'une anomalie a été trouvée dans le modèle de cette technique
  def diagonale3et3()
    checkFinal = false #Boolean qui sera mit à true si on trouve un cas à améliorer via cette technique
    taille = to_i(@partie.difficulte,NB_CASES_FACILE,NB_CASES_MOYEN,NB_CASES_DIFFICILE)
    cases = @partie.getCases
    plateau = @partie.plateau

    #Parcours du plateau
    0.upto(taille*2){ |x|
      0.upto(taille*2){ |y|
        if(x%2 != 0 && y%2 != 0)#Si on est sur une case
          if(cases[x][y].numero == 3)#Si la case est un 3
            puts "Traitement case 3 [#{x},#{y}]"
            #Recupérer une liste des cases en diagonale
            listeCasesDiagonales = cases[x][y].casesDiagonales()
            #Parcourir
            listeCasesDiagonales.each{ |c|
              #Si cette case possède un 3 dans sa diagonale
              if(c.numero == 3) then
                puts "3 en diagonale trouvé : [#{c.x},#{c.y}]"
                pos_rel = cases[x][y].trouverPositionRelativeA(c)
                puts("Pos rel : #{pos_rel}")

                #Selon la position du 3 par rapport au 0
                case(pos_rel)

                when SUDEST #Equivalent à NORDOUEST
                  #Objectif 1 : Déterminer si les murs autour du 3 sont tous bien placés
                  if(plateau.getMur(y,x-1).etat != REMPLI) then
                    puts("a: Erreur mur VIDE #{x-1},#{y}")
                    checkFinal = true
                  elsif(plateau.getMur(y-1,x).etat != REMPLI) then
                    puts("b: Erreur mur VIDE #{x},#{y-1}")
                    checkFinal = true
                  elsif(plateau.getMur(y+2,x+3).etat != REMPLI) then
                    puts("c: Erreur mur VIDE #{x+3},#{y+2}")
                    checkFinal = true
                  elsif(plateau.getMur(y+3,x+2).etat != REMPLI) then
                    puts("d: Erreur mur VIDE #{x+2},#{y+3}")
                    checkFinal = true
                  end

                  #Objectif 2 : Déterminer si des murs placés n'ont pas à être placés
                  if(plateau.murExiste?(y-1, x-2))then
                    if(plateau.getMur(y-1, x-2).etat == REMPLI) then
                      puts("w Erreur mur REMPLI #{x-2},#{y-1}")
                      checkFinal = true
                    end
                  end
                  if(plateau.murExiste?(y-2, x-1))then
                    if(plateau.getMur(y-2, x-1).etat == REMPLI) then
                      puts("x Erreur mur REMPLI #{x-1},#{y-2}")
                      checkFinal = true
                    end
                  end
                  if(plateau.murExiste?(y+4, x+3))then
                    if(plateau.getMur(y+4, x+3).etat == REMPLI) then
                      puts("y Erreur mur REMPLI #{x+3},#{y+4}")
                      checkFinal = true
                    end
                  end
                  if(plateau.murExiste?(y+3, x+4))then
                    if(plateau.getMur(y+3, x+4).etat == REMPLI) then
                      puts("z Erreur mur REMPLI #{x+4},#{y+3}")
                      checkFinal = true
                    end
                  end

                when SUDOUEST #equivalent à NORDEST
                  #Objectif 1 : Déterminer si les murs autour du 3 sont tous bien placés
                  if(plateau.getMur(y-1,x).etat != REMPLI) then
                    puts("a: Erreur mur VIDE #{x},#{y-1}")
                    checkFinal = true
                  elsif(plateau.getMur(y,x+1).etat != REMPLI) then
                    puts("b: Erreur mur VIDE #{x+1},#{y}")
                    checkFinal = true
                  elsif(plateau.getMur(y+3,x-2).etat != REMPLI) then
                    puts("c: Erreur mur VIDE #{x-2},#{y+3}")
                    checkFinal = true
                  elsif(plateau.getMur(y+2,x-3).etat != REMPLI) then
                    puts("d: Erreur mur VIDE #{x-3},#{y+2}")
                    checkFinal = true
                  end

                  #Objectif 2 : Déterminer si des murs placés n'ont pas à être placés
                  if(plateau.murExiste?(y-2, x+1))then
                    if(plateau.getMur(y-2, x+1).etat == REMPLI) then
                      puts("w Erreur mur REMPLI #{x+1},#{y-2}")
                      checkFinal = true
                    end
                  end
                  if(plateau.murExiste?(y-1, x+2))then
                    if(plateau.getMur(y-1, x+2).etat == REMPLI) then
                      puts("x Erreur mur REMPLI #{x+2},#{y-1}")
                      checkFinal = true
                    end
                  end
                  if(plateau.murExiste?(y+3, x-4))then
                    if(plateau.getMur(y+3, x-4).etat == REMPLI) then
                      puts("y Erreur mur REMPLI #{x-4},#{y+3}")
                      checkFinal = true
                    end
                  end
                  if(plateau.murExiste?(y+4, x-3))then
                    if(plateau.getMur(y+4, x-3).etat == REMPLI) then
                      puts("z Erreur mur REMPLI #{x-3},#{y+4}")
                      checkFinal = true
                    end
                  end
                end
              end
            }
          end
        end
      }
    }
    #Affichage de la popup si une anomalie a été trouvée
    if(checkFinal == true) then
      PopupAide.creer("Aide Technique","Cas des 3 en diagonale \n4 Murs sont placés en rouge\n4 Murs ne sont jamais placés (croix en rouge)", "Image/1262.gif", "Image/1263.gif")
    end
    return checkFinal
  end

  def coin()
    cases = @partie.getCases
    plateau = @partie.plateau
    if((cases[1][1].numero >= 0) || (cases[plateau.taille*2-1][1].numero >= 0) || (cases[1][plateau.taille*2-1].numero >= 0) || (cases[plateau.taille*2-1][plateau.taille*2-1].numero >= 0))
      if(cases[1][1].numero >= 0)
        listeDesMursLocal = cases[1][1].listeDesMursAutour()
        cpt =0
        for m in listeDesMursLocal
          if(m.etat == 1)
            cpt += 1
          end
        end
        if(cpt != cases[1][1].numero)
          PopupAide.creer("Aide", "Remplir les coins comme sur les images ci-dessous","Image/1264.gif", "Image/1265.gif")
          return true
        end
      end
      if(cases[plateau.taille*2-1][1].numero >= 0)
        listeDesMursLocal = cases[plateau.taille*2-1][1].listeDesMursAutour()
        cpt =0
        for m in listeDesMursLocal
          if(m.etat == 1)
            cpt += 1
         end
        end
        if(cpt != cases[plateau.taille*2-1][1].numero)
          PopupAide.creer("Aide", "Remplir les coins comme sur les images ci-dessous","Image/1264.gif", "Image/1265.gif")
          return true
        end
      end

      if(cases[1][plateau.taille*2-1].numero >= 0)
        listeDesMursLocal = cases[1][plateau.taille*2-1].listeDesMursAutour()
        cpt =0
        for m in listeDesMursLocal
          if(m.etat == 1)
            cpt += 1
         end
        end
        if(cpt != cases[1][plateau.taille*2-1].numero)
          PopupAide.creer("Aide", "Remplir les coins comme sur les images ci-dessous","Image/1264.gif", "Image/1265.gif")
          return true
        end
      end

      if(cases[plateau.taille*2-1][plateau.taille*2-1].numero >= 0)
        listeDesMursLocal = cases[plateau.taille*2-1][plateau.taille*2-1].listeDesMursAutour()
        cpt =0
        for m in listeDesMursLocal
          if(m.etat == 1)
            cpt += 1
         end
        end
        if(cpt != cases[plateau.taille*2-1][plateau.taille*2-1].numero)
          PopupAide.creer("Aide", "Remplir les coins comme sur les images ci-dessous","Image/1264.gif", "Image/1265.gif")
          return true
        end
      end
    end
  end

  #contrainte2()
  #Recherche d'un cas ou le deux est placé contre un mur ET une boucle atteint le 2
  # => retourne true si une anomalie est détectée
  def contrainte2()
    checkFinal = false #Boolean qui sera mit à true si on trouve un cas à améliorer via cette technique
    taille = to_i(@partie.difficulte,NB_CASES_FACILE,NB_CASES_MOYEN,NB_CASES_DIFFICILE)
    cases = @partie.getCases
    plateau = @partie.plateau

    #Parcours du plateau
    0.upto(taille*2){ |x|
      0.upto(taille*2){ |y|
        if(x%2 != 0 && y%2 != 0)#Si on est sur une case
          if(cases[x][y].numero == 2 && cases[x][y].estSurLeBord() != -1 && cases[x][y].estDansUnCoin() == -1)#Si la case est un 3
            puts "Traitement case 2 [#{x},#{y}]"
            case(cases[x][y].estSurLeBord())
              when NORD
                if(plateau.getMur(y+1,x-2).etat == REMPLI || plateau.getMur(y+2,x-1).etat == REMPLI) then
                  if(plateau.getMur(y-1,x+2).etat != REMPLI) then
                    checkFinal = true
                  end
                elsif(plateau.getMur(y+2,x+1).etat == REMPLI || plateau.getMur(y+1,x+2).etat == REMPLI) then
                  if(plateau.getMur(y-1,x-2).etat != REMPLI) then
                    checkFinal = true
                  end
                end
              when SUD
                if(plateau.getMur(y-1,x-2).etat == REMPLI || plateau.getMur(y-2,x-1).etat == REMPLI) then
                  if(plateau.getMur(y+1,x+2).etat != REMPLI) then
                    checkFinal = true
                  end
                elsif(plateau.getMur(y-2,x+1).etat == REMPLI || plateau.getMur(y-1,x+2).etat == REMPLI) then
                  if(plateau.getMur(y+1,x-2).etat != REMPLI) then
                    checkFinal = true
                  end
                end
              when EST
                if(plateau.getMur(y-1,x-2).etat == REMPLI || plateau.getMur(y-2,x-1).etat == REMPLI) then
                  if(plateau.getMur(y+2,x+1).etat != REMPLI) then
                    checkFinal = true
                  end
                elsif(plateau.getMur(y+1,x-2).etat == REMPLI || plateau.getMur(y+2,x-1).etat == REMPLI) then
                  if(plateau.getMur(y-2,x+1).etat != REMPLI) then
                    checkFinal = true
                  end
                end

              when OUEST
                if(plateau.getMur(y-1,x+2).etat == REMPLI || plateau.getMur(y-2,x+1).etat == REMPLI) then
                  if(plateau.getMur(y+2,x-1).etat != REMPLI) then
                    checkFinal = true
                  end
                elsif(plateau.getMur(y+1,x+2).etat == REMPLI || plateau.getMur(y+2,x+1).etat == REMPLI) then
                  if(plateau.getMur(y-2,x-1).etat != REMPLI) then
                    checkFinal = true
                  end
                end
            end
          end
        end
      }
    }

    #Affichage de la popup si une anomalie a été trouvée
    if(checkFinal == true) then
      PopupAide.creer("Aide Technique","Contraintes sur 2\nLorsque une boucle atteint un 2 et que ce 2 est positionné contre un mur, il y a toujours un mur en rouge", "Image/1272.gif", "Image/1273.gif")
    end
    return checkFinal
  end

  #contrainte3()
  #Recherche des cas ou le 3 est contre un mur et est atteint par une boucle
  # => retourne true si une anomalie a été détectée
  def contrainte3()
    checkFinal = false #Boolean qui sera mit à true si on trouve un cas à améliorer via cette technique
    taille = to_i(@partie.difficulte,NB_CASES_FACILE,NB_CASES_MOYEN,NB_CASES_DIFFICILE)
    cases = @partie.getCases
    plateau = @partie.plateau

    #Parcours du plateau
    0.upto(taille*2){ |x|
      0.upto(taille*2){ |y|
        if(x%2 != 0 && y%2 != 0)#Si on est sur une case
          if(cases[x][y].numero == 3 && cases[x][y].estSurLeBord() != -1 && cases[x][y].estDansUnCoin() == -1)#Si la case est un 3
            puts "Traitement case 3 [#{x},#{y}]"
            case(cases[x][y].estSurLeBord())
            when NORD
                if(plateau.getMur(y-1,x-2).etat == CROIX) then
                  if(plateau.getMur(y-1,x).etat !=  REMPLI || plateau.getMur(y,x-1).etat != REMPLI) then
                    checkFinal = true
                  end
                elsif(plateau.getMur(y-1,x+2).etat == CROIX) then
                  if(plateau.getMur(y-1,x).etat !=  REMPLI || plateau.getMur(y,x+1).etat != REMPLI) then
                    checkFinal = true
                  end
                end

              when SUD
                if(plateau.getMur(y+1,x-2).etat == CROIX) then
                  if(plateau.getMur(y+1,x).etat !=  REMPLI || plateau.getMur(y,x-1).etat != REMPLI) then
                    checkFinal = true
                  end
                elsif(plateau.getMur(y+1,x+2).etat == CROIX) then
                  if(plateau.getMur(y+1,x).etat !=  REMPLI || plateau.getMur(y,x+1).etat != REMPLI) then
                    checkFinal = true
                  end
                end

              when OUEST
                if(plateau.getMur(y+2,x-1).etat == CROIX) then
                  if(plateau.getMur(y,x-1).etat !=  REMPLI || plateau.getMur(y+1,x).etat != REMPLI) then
                    checkFinal = true
                  end
                elsif(plateau.getMur(y-2,x-1).etat == CROIX) then
                  if(plateau.getMur(y,x-1).etat !=  REMPLI || plateau.getMur(y-1,x).etat != REMPLI) then
                    checkFinal = true
                  end
                end

              when EST
                if(plateau.getMur(y+2,x+1).etat == CROIX) then
                  if(plateau.getMur(y,x+1).etat !=  REMPLI || plateau.getMur(y+1,x).etat != REMPLI) then
                    checkFinal = true
                  end
                elsif(plateau.getMur(y-2,x+1).etat == CROIX) then
                  if(plateau.getMur(y,x+1).etat !=  REMPLI || plateau.getMur(y-1,x).etat != REMPLI) then
                    checkFinal = true
                  end
                end

            end
          end
        end
      }
    }

    #Affichage de la popup si une anomalie a été trouvée
    if(checkFinal == true) then
      PopupAide.creer("Aide Technique","Contrainte sur 3\n Lorsqu'un 3 est contre un mur et qu'il est atteint par une boucle, 2 murs sont remplis de cette manière", "Image/1266.gif", "Image/1267.gif")
    end
    return checkFinal
  end

  #boucleAtteignant3()
  #Recherche d'une erreur liée à une boucle atteignant un 3
  # => retourne vrai si une erreur de ce type a été trouvée
  def boucleAtteignant3()
    checkFinal = false #Boolean qui sera mit à true si on trouve un cas à améliorer via cette technique
    taille = to_i(@partie.difficulte,NB_CASES_FACILE,NB_CASES_MOYEN,NB_CASES_DIFFICILE)
    cases = @partie.getCases
    plateau = @partie.plateau

    #Parcours du plateau
    0.upto(taille*2){ |x|
      0.upto(taille*2){ |y|
        if(x%2 != 0 && y%2 != 0)#Si on est sur une case
          if(cases[x][y].numero == 3)#Si la case est un 3
            puts "Traitement case 3 [#{x},#{y}]"
            #Boucle arrivant par le NORDOUEST*
            if(plateau.murExiste?(y-1,x-2)) then
              if(plateau.getMur(y-1,x-2).etat == REMPLI)then
                if(plateau.getMur(y,x+1).etat !=  REMPLI || plateau.getMur(y+1,x).etat != REMPLI) then
                  checkFinal = true
                end
              end
            end
            if(plateau.murExiste?(y-2,x-1)) then
              if(plateau.getMur(y-2,x-1).etat == REMPLI)then
                if(plateau.getMur(y,x+1).etat !=  REMPLI || plateau.getMur(y+1,x).etat != REMPLI) then
                  checkFinal = true
                end
              end
            end

            #Boucle arrivant par le NORDEST
            if(plateau.murExiste?(y-1,x+2)) then
              if(plateau.getMur(y-1,x+2).etat == REMPLI)then
                if(plateau.getMur(y,x-1).etat !=  REMPLI || plateau.getMur(y+1,x).etat != REMPLI) then
                  checkFinal = true
                end
              end
            end
            if(plateau.murExiste?(y-2,x+1)) then
              if(plateau.getMur(y-2,x+1).etat == REMPLI)then
                if(plateau.getMur(y,x-1).etat !=  REMPLI || plateau.getMur(y+1,x).etat != REMPLI) then
                  checkFinal = true
                end
              end
            end

            #Boucle arrivant par le SUDOUEST
            if(plateau.murExiste?(y+1,x-2)) then
              if(plateau.getMur(y+1,x-2).etat == REMPLI)then
                if(plateau.getMur(y,x+1).etat !=  REMPLI || plateau.getMur(y-1,x).etat != REMPLI) then
                  checkFinal = true
                end
              end
            end
            if(plateau.murExiste?(y+2,x-1)) then
              if(plateau.getMur(y+2,x-1).etat == REMPLI)then
                if(plateau.getMur(y,x+1).etat !=  REMPLI || plateau.getMur(y-1,x).etat != REMPLI) then
                  checkFinal = true
                end
              end
            end

            #Boucle arrivant par le SUDEST
            if(plateau.murExiste?(y+1,x+2)) then
              if(plateau.getMur(y+1,x+2).etat == REMPLI)then
                if(plateau.getMur(y,x-1).etat !=  REMPLI || plateau.getMur(y-1,x).etat != REMPLI) then
                  checkFinal = true
                end
              end
            end
            if(plateau.murExiste?(y+2,x+1)) then
              if(plateau.getMur(y+2,x+1).etat == REMPLI)then
                if(plateau.getMur(y,x-1).etat !=  REMPLI || plateau.getMur(y-1,x).etat != REMPLI) then
                  checkFinal = true
                end
              end
            end

          end
        end
      }
    }

    #Affichage de la popup si une anomalie a été trouvée
    if(checkFinal == true) then
      PopupAide.creer("Aide Technique","Boucle atteignant 3\n Une boucle atteignant un 3 implique toujours les 2 murs en rouge", "Image/1266.gif", "Image/1267.gif")
    end
    return checkFinal
  end

  #Méthode pour une boucle atteignant 1, retourne true si une erreur de ce type a été trouvée
  def boucleAtteignant1()
    checkFinal = false #Boolean qui sera mit à true si on trouve un cas à améliorer via cette technique
    taille = to_i(@partie.difficulte,NB_CASES_FACILE,NB_CASES_MOYEN,NB_CASES_DIFFICILE)
    cases = @partie.getCases
    plateau = @partie.plateau

    #Parcours du plateau
    0.upto(taille*2){ |x|
      0.upto(taille*2){ |y|
        if(x%2 != 0 && y%2 != 0)#Si on est sur une case
          if(cases[x][y].numero == 1 && cases[x][y].estSurLeBord() != -1 && cases[x][y].estDansUnCoin() == -1)#Si la case est un 3
            puts "Traitement case 1 [#{x},#{y}]"
            case(cases[x][y].estSurLeBord())
            when NORD
              if(plateau.getMur(y-1,x-2).etat == REMPLI) then
                if(plateau.getMur(y,x+1).etat ==  REMPLI || plateau.getMur(y+1,x).etat == REMPLI) then
                  checkFinal = true
                end
              elsif(plateau.getMur(y-1,x+2).etat == REMPLI) then
                if(plateau.getMur(y,x-1).etat ==  REMPLI || plateau.getMur(y+1,x).etat == REMPLI) then
                  checkFinal = true
                end
              end
            when SUD
              if(plateau.getMur(y+1,x-2).etat == REMPLI) then
                if(plateau.getMur(y,x+1).etat ==  REMPLI || plateau.getMur(y-1,x).etat == REMPLI) then
                  checkFinal = true
                end
              elsif(plateau.getMur(y+1,x+2).etat == REMPLI) then
                if(plateau.getMur(y,x-1).etat ==  REMPLI || plateau.getMur(y-1,x).etat == REMPLI) then
                  checkFinal = true
                end
              end
            when EST
              if(plateau.getMur(y-2,x+1).etat == REMPLI) then
                if(plateau.getMur(y,x-1).etat ==  REMPLI || plateau.getMur(y+1,x).etat == REMPLI) then
                  checkFinal = true
                end
              elsif(plateau.getMur(y+2,x+1).etat == REMPLI) then
                if(plateau.getMur(y,x-1).etat ==  REMPLI || plateau.getMur(y-1,x).etat == REMPLI) then
                  checkFinal = true
                end
              end
            when OUEST
              if(plateau.getMur(y-2,x-1).etat == REMPLI) then
                if(plateau.getMur(y,x+1).etat ==  REMPLI || plateau.getMur(y+1,x).etat == REMPLI) then
                  checkFinal = true
                end
              elsif(plateau.getMur(y+2,x-1).etat == REMPLI) then
                if(plateau.getMur(y,x+1).etat ==  REMPLI || plateau.getMur(y-1,x).etat == REMPLI) then
                  checkFinal = true
                end
              end
            end
          end
        end
      }
    }

    #Affichage de la popup si une anomalie a été trouvée
    if(checkFinal == true) then
      PopupAide.creer("Aide Technique", "Boucle atteignant 1\nUne boucle atteignant un 1 implique toujours 2 murs non remplis (croix en rouge)", "cheminimage/", "cheminimage/")
    end
    return checkFinal
  end


end
