#This method is used to display the splash screen using the ruby gem 'Console_Spalash' 
def display_splash()
  #clears the terminal contents
  system "clear"
  require 'console_splash'
  #using the methods provided by the i ahve created a customized splashe screen
  splash = ConsoleSplash.new()
  splash = ConsoleSplash.new(15, 50)
  splash.write_header("Welcome to Flood-It", "Leon Singleton", "1.0")
  splash.write_center(-3, "<Press enter to continue>")
  splash.write_horizontal_pattern("=")
  splash.write_vertical_pattern("|")
  splash.splash
  #Waits for the user to press 'enter' before continuing
  gets()
end

#This method is used to generate a random board using the current board height and width
def get_board(width, height)
  #Here i have created a 2d array which will contain the contents of the board
  board = Array.new(height) { Array.new(width, ' ')}
  
  #Loops through the rows and columns of the board array and creates a random number which is used to set the colour of each position 
  #in the board array to one of the 6 random colours
  (0..height-1).each do |row|
	(0..width-1).each do |column| 
	  rand_num = rand(1..6)
	  if rand_num == 1 then
		board[row][column] = :red
	  elsif rand_num == 2 then
		board[row][column] = :blue
	  elsif rand_num == 3 then
		board[row][column] = :cyan
      elsif rand_num == 4 then
		board[row][column] = :magenta
      elsif rand_num == 5 then
		board[row][column] = :green
	  elsif rand_num == 6 then
		board[row][column] = :yellow
	  end  
	end
  end
   return board
end

#This method is used recursively for the duration of the game, to display and update the board as well as displaying the current completion 
#and the current number of turns taken
def create_board(board, board_checked, width, height, turns_taken, highest_score)
  #clears the terminal contents
  system "clear"
  #Sets the top left corner of the board_checked array to true as this block should automatically be completed
  board_checked[0][0] = "t"
  
  #Loops through the rows and columns of the board array and prints the contents of each position using the colorize gem
  (0..height-1).each do |row|
	(0..width-1).each do |column| 
	  print "  ".colorize(:background => board[row][column])
    end
	puts ""
  end
  
  #sets the number of completed board positions by looping through all the rows and columns of the board_checked array and incrementing by 1 
  #each time a "t" is detected
  completion_count = 0
  (0..height-1).each do |row|
	(0..width-1).each do |column|
	  if board_checked[row][column] == "t"
		completion_count +=1 
	  end
	end
  end
  
  #Calculates a percentage of the board completed
  completion_percentage = ((completion_count*100)/(width*height)).to_i
  #Everytime this method is called i run a completion check to see if the game has finished
  if (completion_percentage == 100) then
    #If the highest score has not already been set then it is set as the number of turns taken
	if highest_score == 0 then
	  highest_score = turns_taken
    #however if the high score has been set but it is lower than the current number of turns it is not set
    #as the latest number of turns taken
	elsif highest_score != 0 && turns_taken < highest_score then
	  highest_score = turns_taken
	end
    #a congratualtions message is dislayed and the main menu method is called after the player presses enter
	puts "You won after #{turns_taken} turns"
    #the main menu is then displayed after the user presses enter
    gets()
	display_main_menu(highest_score, width, height)
  end
		
  #outouts the turns taken and the completion percentage to the screen
  puts "Number of Turns: #{turns_taken}"
  puts "Game completion: #{completion_percentage}%"
  print "choose a colour: "
  #stores the users colour response
  colour_response = gets.chomp.downcase
  colour_block = ""
  
  #sets the value of the variable colourblock to the corresponding colorize value of the user's input
  if colour_response == "r" then
	colour_block = :red
  elsif colour_response == "b" then
	colour_block = :blue
  elsif colour_response == "c" then
	colour_block = :cyan
  elsif colour_response == "m" then
	colour_block = :magenta
  elsif colour_response == "g" then
	colour_block = :green
  elsif colour_response == "y" then
	colour_block = :yellow
  #if the user enters q they will return to the main menu
  elsif colour_response == "q" then
	display_main_menu(highest_score, width, height)
  else
  #If the user tyes any unaccepted values then this method is recalled and they will be asked to enter a choice again
    create_board(board, board_checked, width, height, turns_taken, highest_score) 
  end
   
  #loops through the board checked array to find any positions that are marked as completed
  (0..height-1).each do |row|
	(0..width-1).each do |column|
      #if a position is marked as completed then the contents of the board array position above, right, left and below of the completed array position are
      #checked to see if they match the colour the user has chosen as their input.
      #If they do match the users input choice then their board position is set as completed in the boardchecked array.
	  if board_checked[row][column] == "t"
		if board[row][column+1] == colour_block && column != (width-1) then
		  board_checked[row][column+1] = "t"
		end
		if board[(row-(height-1))][column] == colour_block && row != (height-1) then
		  board_checked[(row-(height-1))][column] = "t"
		end
		if board[row][column-1] == colour_block && column != 0 then
		  board_checked[row][column-1] = "t"
		end
		if board[row-1][column] == colour_block && row != 0 then
		  board_checked[row-1][column] = "t"
		end
	  end
	end
  end  

  #loops through the board checked array and sets the value of the corresponding board array position where there is a position marked as 
  #completed completed in the board checked array        
  (0..height-1).each do |row|
	(0..width-1).each do |column|
	  if board_checked[row][column] == "t"
	    board[row][column] = colour_block
	  end
	end
  end       
  #increments the run counter and re-calls this method      
  turns_taken +=1
  create_board(board, board_checked, width, height, turns_taken, highest_score) 
end
   
#This method is used to change the current width and height of the board
def change_board_size(highest_score, width, height)
  #Asks for the users input for both width and height and then sets them accordingly
  puts "Width (Currently #{width}), change it to?"
  width = gets.chomp.to_i
  puts "Height (Currently #{height}), change it to? "
  height = gets.chomp.to_i
  #Resets the high score when the user changes board size as you would expect to happen 
  highest_score = 0
  display_main_menu(highest_score, width, height)
end

#this method displays the main menu       
def display_main_menu(highest_score, width, height)
  #clears the terminal contents
  system "clear"
  #outputs the options available to the user
  puts "Main Menu: "
  puts "s = Start game "
  puts "c = Change size "
  puts "q = Quit "
  #outputs a message dependant on whether the high score has been set or not
  if highest_score == 0 then
	puts "No games played yet."
  else
	puts "Best Game: #{highest_score} turns"
  end
  #gets the users menu choice
  puts "Please enter your choice: "
  answer = gets.chomp.downcase
  #Calls the associated methods depending on the users menu choice
  if answer == "c" then
	change_board_size(highest_score, width, height)
  elsif answer == "q" then
	exit
  elsif answer == "s" then
    #initailises the counter which tracks the user's turns
    turns_taken = 0
    #Creates a new 2d array which is used to contain the postions of all positions that are completed
    board_checked = Array.new(height) { Array.new(width, ' ')}
    #gets the board array which is initialised with random colour positions from the get board method
	board = get_board(width, height)
    #Calls the create board method which is recursively falled for the duration of the game
    create_board(board, board_checked, width, height, turns_taken, highest_score)
  else
    #if the user enters an invalid choice then this method is simply recalled
    display_main_menu(highest_score, width, height)  
  end
end

#sets the default values of these variables
width = 14
height = 9
highest_score = 0

#Initialises the slash screen and then calls the display menu method
display_splash()
display_main_menu(highest_score, width, height)
