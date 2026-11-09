extends CharacterBody2D

#this declares a int variable and sets it equal to 300 (we will use this when moving)
const SPEED:int = 200
const JUMP_VELOCITY = -450
const GRAVITY = 600
const ACCELERATION = 700
const FRICTION = 1500

var START_POSITION

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	START_POSITION = global_position
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.

#inside of this function check the x velocity of the player and flip the sprite if the player is facing left and flip it back if player is facing right
func _process(delta: float) -> void:
	if velocity.x < 0 and $Image.flip_h == false:
		$Image.flip_h = true
	elif velocity.x > 0 and $Image.flip_h == true:
		$Image.flip_h = false
	pass

# This function is called automatically when a keyboard button is pressed.
func _input(event):
	# we need to figure out what action was pressed (hint look at input_examples in godot's documentation)
	# we need to also use the input map located in project settings to create our own custom action.
	# is_action_pressed needs a string parameter which is the name of the action
	
	#the method is_on_floor() returns true if the player is currently on the floor so you cant jump mid air
	if event.is_action_pressed("jump") and is_on_floor():
		#call your jump method here
		jump()
	if event.is_action_pressed("reset") and $"../Label".visible:
		global_position = START_POSITION
		$"../Label".visible = false
		

# this function is ran each frame so use this to check if a key is currently being pressed like the right arrow
# If the key is being pressed adjust the velocity of the character
# delta is the amount of time inbetween frames, any movement should be multiplied by delta before
func _physics_process(delta):
	var direction = Input.get_axis("move left", "move right")
	#if the player is currently not on the floor make the player fall by decreasing Y velocity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	# In here you adjust the velocity depending on which input is being pressed (the name of the action is the name you give it in your input map)
	# is_action_pressed needs a string parameter
	#look up the function move_toward (this helps the movement feel smooth)
	if Input.is_action_pressed("move right") or Input.is_action_pressed("move left"):
		velocity.x = move_toward(velocity.x,direction * SPEED,ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x,0,FRICTION * delta )
	
	#function to actually use the velocity
	move_and_slide()

func jump():
	# change player Y velocity using jump velocity variable
	velocity.y = JUMP_VELOCITY
	pass





#create a signal to hook into a visible on screen notifier node for when the player leaves the screen and reset its position to start

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	global_position = START_POSITION
	print("Player left screen!")
	print("Starting position: ", START_POSITION)
	#respawn player back at start
	pass # Replace with function body.


func _on_flag_body_entered(body: Node2D) -> void:
	print("You win!")
	$"../Label".visible = true
	#win screen
