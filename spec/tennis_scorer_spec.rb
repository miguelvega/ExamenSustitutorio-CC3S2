require_relative '../lib/tennis_scorer.rb'

RSpec.describe "TennisScorer" do
    describe "puntuación básica" do
      it "empieza con un marcador de 0-0" do
        scorer = TennisScorer.new
        expect(scorer.score).to eq("0-0")
      end
  
      it "hace que el marcador sea 15-0 si el sacador gana un punto" do
        scorer = TennisScorer.new
        scorer.sacador_gana_punto
        expect(scorer.score).to eq("15-0")
      end
  
      it "hace que el marcador sea 0-15 si el receptor gana un punto" do
        scorer = TennisScorer.new
        scorer.receptor_gana_punto
        expect(scorer.score).to eq("0-15")
      end
  
      it "hace que el marcador sea 15-15 después de que ambos ganen un punto" do
        scorer = TennisScorer.new
        scorer.sacador_gana_punto
        scorer.receptor_gana_punto
        expect(scorer.score).to eq("15-15")
      end

      
    end

    
  end
  