#blackjack_app


#------- methods ------------

# print the hand in an easy to read way
# includes exceptions for face cards and aces
def print_the_hand player_deck

	player_deck.each do |card|
		if card[0] <= 10
			puts card[0].to_s + ' of ' + card[1].to_s
		elsif card[0] == 11
			puts 'Jack of ' + card[1].to_s
		elsif card[0] == 12
			puts 'Queen of ' + card[1].to_s
		elsif card[0] == 13
			puts 'King of ' + card[1].to_s
		elsif card[0] == 14
			puts 'Ace of ' + card[1].to_s
		end
	end
end

# calculate the score
# return the score and a boolean for the ace
def find_the_score deck_to_add

	hand_count = 0
	ace = false

	deck_to_add.each do |card|

		if card[0] <= 10
			hand_count += card[0]
	
		elsif card[0] <= 13
			hand_count += 10

		elsif card[0] > 13
			hand_count += 1
			ace = true
		end

	end

	return hand_count, ace

end

def print_final_scores hand_count, dealer_hand_count, name

	puts "The final score was:"
	puts "#{name}: " + hand_count.to_s
	puts "Dealer: " + dealer_hand_count.to_s
	puts ""

end

	

# ------- main program start ------------


#get the player's name
puts ""
puts "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
puts ""
puts "Welcome to Dave's Blackjack Game"
puts "What's your name so we can have a polite game?"
name = gets.chomp

#intialize play_again for while loop
play_again = 'y'

while play_again == 'y'

	#initialize variables and arrays

	# arrays to hold player and dealer cards
	playercards =[]
	dealercards = []

	# hand_counts for player and dealer
	hand_count = 0
	dealer_hand_count = 0

	# intialize play for the main player while loop
	play = 'h'

	#initialize bust booleans for player and dealer
	bust = false
	dealer_bust = false


	#create the deck with suit and shuffle
	deck = []
	cards = [2,3,4,5,6,7,8,9,10,11,12,13,14]
	suits = ['Clubs', 'Diamonds', 'Hearts', 'Spades']

	suits.each do |suit|
		cards.each do |cardnumber|
			deck.push([cardnumber, suit])
		end
	end

	deck.shuffle!

	#deal one card to the player and the dealer to initialize for the while loops
	playercards.push(deck[0])
	deck.delete_at(0)

	dealercards.push(deck[0])
	deck.delete_at(0)


	# blackjack game starts -------------------------


	# what's the dealer showing?
	puts ""
	puts 'The dealer is showing:'
	print_the_hand dealercards


	# start the game for the player
	# while the player does not bust they can keep hitting
	while bust == false and play != 's' 

		#give the player a card
		playercards.push(deck[0])
		deck.delete_at(0)

		#print the current cards
		puts ""
		puts "#{name}, you currently have: "
		print_the_hand playercards

		# find the total hand count as well as if they have an ace
		hand_count, ace = find_the_score playercards

		# handle all the ace cases
		if ace == false
			puts ""
			puts "Your score is " + hand_count.to_s
			puts ""
		elsif ace == true
			if (hand_count + 10) <= 21
				puts ""
				puts "Your score is either " + hand_count.to_s + " or " + (hand_count + 10).to_s
				puts ""
				puts "If you stay, we'll use the higher of the two scores!"
			elsif (hand_count + 10) > 21
				puts ""
				puts "Your score is " + hand_count.to_s
				puts ""
			end
		end

		#update bust
		if hand_count > 21 
			bust = true
			puts "Oh no!  Your hand is more than 21.  You busted."
			puts "  It might have just been a bad draw :("
		end
			
		# let the player take another card
		if bust == false	
			puts "Do you want to hit or stay?"
			puts "Enter 'h' to get another card or 's' to stay"
			play = gets.chomp
		end

		# adjust the score if the players stays with an ace and it should be counted as 11 instead of one
		if bust == false and play == 's' and ace == true
			if hand_count + 10 <= 21
				hand_count += 10
			end
		end
	end

	# have the dealer play if the player did not bust
	if bust == false
		#while loop for the dealer to continue taking cards
		while dealer_bust == false and dealer_hand_count <= 16

			#the dealer gets a new cards
			dealercards.push(deck[0])
			deck.delete_at(0)

			#find the score for the dealer
			dealer_hand_count, dealer_ace = find_the_score dealercards


			#print the dealer cards
			puts ""
			puts "The dealer has:"

			print_the_hand dealercards

			puts ""


			#handle the ace cases
			if dealer_ace == false
				puts "The dealer's total hand count is " + dealer_hand_count.to_s
			end

			if dealer_ace == true
				if (dealer_hand_count + 10) > 21
					puts "The dealer's total hand count is " + dealer_hand_count.to_s
				elsif (dealer_hand_count + 10) <= 21
					puts "The dealer's total hand count is either " + dealer_hand_count.to_s + " or " + (dealer_hand_count + 10).to_s
					if (dealer_hand_count + 10) >= 17
						dealer_hand_count += 10
					end
				end
			end

			#udpate dealer bust
			if dealer_hand_count > 21
				dealer_bust = true
			end

			#let the player go through the suspense of seeing the dealer get cards
			puts "Press return to continue"
			blank = gets.chomp
		end

		# end of game scenarios
		if dealer_bust == true
			puts "#{name}, you win!  The dealer busted."
			print_final_scores hand_count, dealer_hand_count, name
			puts "Congratulations #{name}"
		end

		#more end of game scenarios
		if dealer_bust == false
			if hand_count > dealer_hand_count
				print_final_scores hand_count, dealer_hand_count, name
				puts "Congratulations #{name}, you won!"

			elsif hand_count < dealer_hand_count
				print_final_scores hand_count, dealer_hand_count, name
				puts "#{name}, sorry.  The dealer had a higher score than you without going over 21."

			elsif hand_count == dealer_hand_count
				print_final_scores hand_count, dealer_hand_count, name
				puts "#{name}, you tied.  Your bet pushes to the next game.  Play again!"
			end
		end
	end

	# give the player the option to play again
	puts ""
	puts "If you want to play again enter 'y' !"
	play_again = gets.chomp

	if play_again != 'y'
		puts ""
		puts "Thanks for playing.  See you next time, #{name}"
		puts ""
	else
		puts ""
		puts "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
		puts "Great! Let's play again."
	end

end





