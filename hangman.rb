require 'yaml'

class Game
attr_reader :game_word, :blanks, :guesses, :name

	def initialize (name)
		@name = name
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

#until defined? current_game
	puts "load game or new game?"
	answer = gets.chomp 

	if answer == "new" 
		puts "name? "
		current_name = gets.chomp
		current_game = Game.new(current_name)
		puts current_game
	elsif answer == "load"
		puts "name? "
		load_name = gets.chomp
		current_game = YAML.load_file("saved_games/#{load_name}")
		puts "#{load_name} does not exist!!!" unless defined? current_game
	else
		puts "invalid option!!!"
	end
#end

current_game.display
while (current_game.guesses > 0) & !(current_game.win)
	puts "save game? (y/n)"
	answer = gets.chomp
	if answer == "y"
		if File.exist? ("saved_games/#{current_game.name}")
			f = File.open("saved_games/#{current_game.name}", "w")
		else
			f = File.new("saved_games/#{current_game.name}", "w")
		end
		f.puts current_game.to_yaml
		f.close
	end
	print "guess: "
	
	current_game.play(gets.chomp.upcase)
	puts ""
	puts ""
end

puts "Congrats!! you win, you winner!!!" if current_game.win
puts "You Lose!! the answer is #{current_game.game_word}" unless current_game.win