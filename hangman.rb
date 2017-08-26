require 'yaml'

class Game
attr_reader :game_word, :blanks, :guesses

	def initialize
		@guesses = 7
		@blanks ||= []
		@game_word = set_word
		@game_word.split("").each {@blanks << false}
	end

	def set_word
		words = []
		File.open("5desk.txt").readlines.each do |line|
			words << line
		end

		word = ""
		until (word.length < 12) & (word.length > 5)
			word = words[rand(61405)].chomp.upcase
		end
		word
	end

	def win
		winner = true
		for i in 0...@game_word.length
			winner = winner & blanks[i]
		end
		winner
	end

	def display
		for i in 0...@game_word.length 
			print "_ " unless @blanks[i]
			print "#{@game_word[i]} " if @blanks[i] 
		end
		puts ""
		puts "#{@guesses} guesses remaining"
	end

	def play(char)
		for i in 0...@game_word.length
			blanks[i] = true if @game_word[i] == char
		end
		@guesses -=1 unless @game_word.include? char
		display
	end
end

game = Game.new

game.display
while (game.guesses > 0) & !(game.win)
	print "guess: "
	game.play(gets.chomp.upcase)
	puts ""
	puts ""
end

puts "Congrats!! you win, you winner!!!" if game.win
puts "You Lose!! the answer is #{game.game_word}" unless game.win