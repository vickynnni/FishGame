extends Fish


# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = Vector2(-5.0,-5.0)
	#position = Vector2(300.0,300.0)
	drag = 1
	close_d = Vector2(0.0,0.0)
	separation = 10
	avoidfactor = 0.004
	max_speed = 7
	vel_avg = Vector2(0.0,0.0)
	pos_avg = Vector2(0.0,0.0)
	visible_range = 200
	matching_factor = 0.2
	centering_factor = 0.0003
	rand_move = 0.05
	pass # Replace with function body.


