extends Area2D

var rotation_velocity = 0.0
var max_rotation_speed = 1.0
var velocity = Vector2(0.0,0.0)
var drag = 0.99
var normal_max_vel = 4
var max_vel = 4
var dist_to_mouse = Vector2(0.0,0.0)
var local_mouse_position = Vector2(0.0,0.0)
var global_mouse_position = Vector2(0.0,0.0)
var can_speedup = true
var speed_timer
var extra_speed = 1

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if(can_speedup):
					max_vel = 10
					velocity += dist_to_mouse*2
					can_speedup = false
					speed_timer.start()
					print("Mouse Click: ", event.position)
					

func dec_max_speed():
	if(max_vel > normal_max_vel):
		max_vel -= 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	speed_timer = get_node("SpeedTimer")
	speed_timer.wait_time = 0.5
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(max_vel)
	calc_rotation()
	go_to_mouse()
	dec_max_speed()
	velocity *= drag
	if(velocity.length() > max_vel):
		velocity = velocity.normalized()*max_vel
	position += velocity
	if(rotation_velocity > max_rotation_speed):
		rotation_velocity = max_rotation_speed
	
	rotation += rotation_velocity
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


func _on_timer_timeout():
	can_speedup = true
	pass # Replace with function body.
