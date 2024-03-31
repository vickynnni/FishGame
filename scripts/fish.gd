class_name Fish
extends Area2D

var velocity = Vector2(5.0,5.0)
var drag = 1
var close_d = Vector2(0.0,0.0)
var separation = 10
var avoidfactor = 0.005
var max_speed = 5
var neighboring_boids = 0
var vel_avg = Vector2(0.0,0.0)
var pos_avg = Vector2(0.0,0.0)
var visible_range = 200
var matching_factor = 0.2
var centering_factor = 0.0004
var rand_move = 0.05

# max_velocity -> check
# bborders

# Called when the node enters the scene tree for the first time.
func _ready():
	#position = Vector2(300.0,300.0)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity *= drag
	velocity += Vector2(randf_range(-rand_move,rand_move), randf_range(-rand_move,rand_move))
	rotation = velocity.angle()
	if(velocity.length() > max_speed):
		velocity = velocity.normalized()*max_speed
	position += velocity 
	pass
