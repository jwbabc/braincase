# Output text onto the screen
puts "Hello, world. What is your name?"

# Get the user's name
myname = gets()
# Append the user's name into the string
puts "Well, hello there " + myname + "."

# Example of an inclusive range (48-81)
human_inclusive = 48..81
# Example of an exclusive range (48-80)
human_exclusive = 48...80
# Compare a range to a range
puts(human_inclusive === human_exclusive) #false

# Let's use a range to guess how many good cookies I have
good_cookies = 1...3
bad_cookies = 1..3
burnt_cookies = 1..3

puts(good_cookies == bad_cookies) #false
puts(good_cookies.eql?(burnt_cookies)) #false
puts(bad_cookies == burnt_cookies) #true

my_guess = 2
his_guess = 19

puts(good_cookies === my_guess) #true
puts(good_cookies.member?(my_guess)) #true
puts(good_cookies === his_guess) #false

#Lets put the burnt cookies into an array, since nobody will eat them
burnt_cookies_array = burnt_cookies.to_a
puts (burnt_cookies_array)

