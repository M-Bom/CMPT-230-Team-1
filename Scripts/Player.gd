extends CharacterBody2D

#Movement Variables
var speed = 5000
var input = Vector2.ZERO

#The player main function
func _physics_process(delta):
	player_movement(delta)

func get_input():
	#Get a 1 or -1 for the x and y direction
	input.x = Input.get_action_strength("Move_Right") - Input.get_action_strength("Move_Left")
	input.y = Input.get_action_strength("Move_Down") - Input.get_action_strength("Move_Up")
	
	#Update the player animation
	player_animation(input.x, input.y)
	
	#Returns the vector normalized
	return input.normalized()
	
func player_movement(delta):
	#Call input function
	input = get_input()
	
	#Stop Player Down
	if input == Vector2.ZERO:
		velocity = Vector2.ZERO
	#Player Runs
	else:
		velocity = (input * delta * speed)
	
	#In-built function to move
	move_and_slide()
	
	
func player_animation(dir_x, dir_y):
	#Function variables
	var animated_sprite_2d = $AnimatedSprite2D
	
	#Flip along the player sprite
	if dir_x > 0:
		animated_sprite_2d.flip_h = false
	elif dir_x < 0:
		animated_sprite_2d.flip_h = true
	
	#Play animation
	if dir_x == 0 and dir_y == 0:
		animated_sprite_2d.play("Idle")
	else:
		animated_sprite_2d.play("Running")
		
# Easy Debug Escape
func _input(_ev):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
