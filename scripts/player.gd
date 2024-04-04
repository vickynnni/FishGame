extends Fish



var rotation_velocity = 0.0
var max_rotation_speed = 1.0
var normal_max_vel = 4
var current_max_vel = 4
var min_max_vel = 3
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
var mouse_multiplier = 0.0001
var target_max_speed = normal_max_vel


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
					current_max_vel = 9
					velocity += dist_to_mouse*boost
					can_speedup = false
					speed_timer.start()
					num_boosts -= 1
					print("Mouse Click: ", event.position)
					

func dec_max_speed():
	if(current_max_vel > target_max_speed):
		current_max_vel -= 0.01

# Called whgen the node enters the scene tree for the first time.
func _ready():
	shadow_offset = Vector2(6,6)
	fish_name = "bipo"
	fishType = "player"
	separation = 1
	avoidfactor = 0.001
	matching_factor = 0.001
	centering_factor = 0.0013
	speed_timer = get_node("SpeedTimer")
	speed_timer.wait_time = 0.5
	
	
	pass # Replace with function body.

func check_flip():
	var shadow = get_node("Node/shadow")
	var x_scale = $AnimatedSprite2D.scale.x
	var y_scale = $AnimatedSprite2D.scale.y
	var s_x_scale = shadow.scale.x
	var s_y_scale = shadow.scale.y
	if(velocity.x < 0):
		if(!rightleft):
			$AnimatedSprite2D.scale.y = -y_scale
			$AnimatedSprite2D.scale.x = x_scale
			#shadow.scale.y = -s_y_scale
			#shadow.scale.x = s_x_scale
			#shadow_offset = shadow_offset + Vector2(5,0)
			rightleft=true
	else:
		if(rightleft):
			$AnimatedSprite2D.scale.y = -y_scale
			$AnimatedSprite2D.scale.x = x_scale
			#shadow.scale.y = -s_y_scale
			#shadow.scale.x = s_x_scale
			#shadow_offset = Vector2(6,6)
			rightleft = false
		
func calc_shadow():
	var shadow = get_node("Node/shadow")
	shadow.position = self.position + shadow_offset
	shadow.rotation = self.rotation

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#print(num_boosts)
	#print("max_vel: " + str(current_max_vel))
	#print("vel: " + str(velocity.length()))
	#calc_rotation()
	go_to_mouse()
	dec_max_speed()
	check_banks_proximity()
	check_flip()
	update_anim_speed()
	if(attached_to_bank != null):
		target_max_speed = attached_to_bank.avg_velocity.length()+0.5
		boost = 6
	else:
		boost = 2
		current_max_vel -= 0.05
	if(current_max_vel < target_max_speed):
		current_max_vel = target_max_speed
	velocity *= drag
	if(velocity.length() > current_max_vel):
		velocity = velocity.normalized()*current_max_vel
	position += velocity
	if(rotation_velocity > max_rotation_speed):
		rotation_velocity = max_rotation_speed
	
	rotation = velocity.angle()
	calc_shadow()
	print(velocity.length())
	pass

func calc_rotation():
	rotation_velocity = (local_mouse_position.angle())*0.07
	#print(rotation_velocity)

func go_to_mouse():
	global_mouse_position = get_global_mouse_position()
	local_mouse_position = get_local_mouse_position()
	dist_to_mouse = (global_mouse_position - position)
	mouse_multiplier = 0.0001
	if(dist_to_mouse.length() > 70):
		dist_to_mouse = dist_to_mouse.normalized()
		mouse_multiplier = 0.1
	elif(dist_to_mouse.length() < 70):
		mouse_multiplier = 0
	#if(attached_to_bank != null):
		#mouse_multiplier = 0.01
		
	velocity += dist_to_mouse*mouse_multiplier

func check_banks_proximity():
	for bank in bank_list:
		var dist_to_bank = (position - bank.bank_position).length()
		if(dist_to_bank < 150):
			#print("in bank")
			if(attached_to_bank == null):
				bank.add_player(self)
				attached_to_bank = bank
				target_max_speed = attached_to_bank.avg_velocity.length()
		else:
			if(bank == attached_to_bank):
				target_max_speed = normal_max_vel
				bank.remove_player(self)
				attached_to_bank = null
		
		
		if(dist_to_bank > 1500):
			var mult1 = 1
			var mult2 = 1
			if(randi()%2==0):
				mult1 = -1
			if(randi()%2==0):
				mult2 = -1
			bank.teleport(position + Vector2(mult1*randf_range(1000,1200),mult2*randf_range(1000,1500)))
				

func update_anim_speed():
	var fps = floor(velocity)
	$AnimatedSprite2D.speed_scale = velocity.length()*0.35

func _on_timer_timeout():
	can_speedup = true
	no_external_forces = false
	pass # Replace with function body.


func _on_boost_generator_timeout():
	if(num_boosts < max_num_boosts):
		num_boosts += 1
	pass # Replace with function body.
