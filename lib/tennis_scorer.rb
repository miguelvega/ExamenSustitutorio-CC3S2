
class TennisScorer

    def initialize
      @score = { sacador: 0, receptor: 0 }
    end
  
    def sacador_gana_punto
      @score[:sacador] += 1
    end
  
    def receptor_gana_punto
      @score[:receptor] += 1
    end
  
    def score
      "#{puntuacion(@score[:sacador])}-#{puntuacion(@score[:receptor])}"
    end
  
    private
  
    def puntuacion(puntos)
      case puntos
      when 0 then "0"
      when 1 then "15"
      when 2 then "30"
      when 3 then "40"
      end
    end
  end
  