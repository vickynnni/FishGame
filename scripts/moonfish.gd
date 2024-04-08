extends Fish


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("animTimer").start(randf_range(0.0,0.5))
	shadow_offset = Vector2(3,2)
	separation = 25
	avoidfactor = 0.003
	max_speed = 5.5
	visible_range = 200
	matching_factor = 0.0001
	centering_factor = 0.0004
	rand_move = 0.05
	pass # Replace with function body.




func _on_anim_timer_timeoutd():
	#print("hola")
	$AnimatedSprite2D.play()
	pass # Replace with function body.
