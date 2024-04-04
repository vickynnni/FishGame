class_name Fish
extends Area2D

var shadow_offset = Vector2(7,5)

var fish_name = "fish"
var fishType = "normal"
var velocity = Vector2(0.0,0.0)
var drag = 1
var close_d = Vector2(0.0,0.0)
var separation = 30
var avoidfactor = 0.003
var max_speed = 5
var neighboring_boids = 0
var vel_avg = Vector2(0.0,0.0)
var pos_avg = Vector2(0.0,0.0)
var visible_range = 200
var matching_factor = 0.0001
var centering_factor = 0.0005
var rand_move = 0.0

# max_velocity -> check
# bborders

var rightleft = false
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
		

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("animTimer").start(randf_range(0.0,0.5))
	#position = Vector2(300.0,300.0)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.

func calc_shadow():
	var shadow = get_node("Node/shadow")
	shadow.position = self.position + shadow_offset
	shadow.rotation = self.rotation

func _process(delta):
	#velocity *= drag
	#velocity += Vector2(randf_range(-rand_move,rand_move), randf_range(-rand_move,rand_move))
	rotation = velocity.angle()
	if(velocity.length() > max_speed):
		velocity = velocity.normalized()*max_speed
	position += velocity 
	calc_shadow()
	check_flip()
	pass


func _on_anim_timer_timeout():
	print("mola")
	$AnimatedSprite2D.play()
	pass # Replace with function body.


func _on_anim_timer_timeoutn():
	$AnimatedSprite2D.play()
	pass # Replace with function body.
