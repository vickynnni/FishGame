extends Fish

var rotation_velocity = 0.0
var max_rotation_speed = 1.0
var normal_max_vel = 6
var current_max_vel = 6
var min_max_vel = 1
var dist_to_mouse = Vector2(0.0,0.0)
var local_mouse_position = Vector2(0.0,0.0)
var global_mouse_position = Vector2(0.0,0.0)
var can_speedup = true
var speed_timer
var extra_speed = 1
var attached_to_bank = null
var boost = 2
var no_external_forces = false
var max_num_boosts = 3
var num_boosts = 3


var bank_list = []

func set_banks(banks):
	bank_list = banks

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if(can_speedup and num_boosts > 0):
					var boost_generator = get_node("BoostGenerator")
					boost_generator.start()
					no_external_forces = true
					current_max_vel = 10
					velocity += dist_to_mouse*boost
					can_speedup = false
					speed_timer.start()
					num_boosts -= 1
					print("Mouse Click: ", event.position)
					

func dec_max_speed():
	if(current_max_vel > normal_max_vel):
		current_max_vel -= 0.3

# Called whgen the node enters the scene tree for the first time.
func _ready():
	fish_name = "bipo"
	fishType = "player"
	separation = 1
	avoidfactor = 0.001
	matching_factor = 1
	centering_factor = 0.005
	speed_timer = get_node("SpeedTimer")
	speed_timer.wait_time = 0.5
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(num_boosts)
	#print(current_max_vel)
	#calc_rotation()
	go_to_mouse()
	dec_max_speed()
	check_banks_proximity()
	if(attached_to_bank != null):
		boost = 7
		current_max_vel = attached_to_bank.bank_max_speed
	else:
		boost = 2
		current_max_vel -= 0.023
	if(current_max_vel < min_max_vel):
		current_max_vel = min_max_vel
	velocity *= drag
	if(velocity.length() > current_max_vel):
		velocity = velocity.normalized()*current_max_vel
	position += velocity
	if(rotation_velocity > max_rotation_speed):
		rotation_velocity = max_rotation_speed
	
	rotation = velocity.angle()
	pass

func calc_rotation():
	rotation_velocity = (local_mouse_position.angle())*0.07
	#print(rotation_velocity)

func go_to_mouse():
	global_mouse_position = get_global_mouse_position()
	local_mouse_position = get_local_mouse_position()
	dist_to_mouse = (global_mouse_position - position)
	var multiplier = 0.0001
	if(dist_to_mouse.length() > 70):
		dist_to_mouse = dist_to_mouse.normalized()
		multiplier = 0.1
	elif(dist_to_mouse.length() < 70):
		multiplier = 0
		
	velocity += dist_to_mouse*multiplier

func check_banks_proximity():
	
	for bank in bank_list:
		var dist_to_bank = (position - bank.bank_position).length()
		if(dist_to_bank < 100):
			#print("in bank")
			if(attached_to_bank == null):
				bank.add_player(self)
				attached_to_bank = bank
				current_max_vel = 6
		else:
			if(bank == attached_to_bank):
				bank.remove_player(self)
				current_max_vel = attached_to_bank.bank_max_speed
				attached_to_bank = null
				

func _on_timer_timeout():
	can_speedup = true
	no_external_forces = false
	pass # Replace with function body.


func _on_boost_generator_timeout():
	if(num_boosts < max_num_boosts):
		num_boosts += 1
	pass # Replace with function body.
