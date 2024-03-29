extends Node2D

var FishClass = preload("res://regular_fish.tscn")
var num_fish = 10
var fish_list = []
#var leftmargin = 2000
#var rightmargin = 2000
#var topmargin = 4000
#var bottommargin = 3000	
var turnfactor = 0.2
@onready
var player = get_node("PlayerFish")

# Called when the node enters the scene tree for the first time.
func _ready():
	for n in num_fish:
		var f = FishClass.instantiate()
		add_child(f)
		f.position += Vector2(randf_range(-10.0,10.0),randf_range(-10.0,10.0))

		fish_list.append(f)
	pass # Replace with function body.

func separation():
	for fish in fish_list:
		fish.close_d = Vector2(0.0,0.0)
		var distance = Vector2(0.0,0.0)
		var threshold = fish.separation
		for other_fish in fish_list:
			if fish == other_fish:
				break
			distance = fish.position - other_fish.position
			if (distance.length() <= threshold):
				fish.close_d += distance
		fish.velocity += fish.close_d * fish.avoidfactor
		detect_wall_collisions(fish)


func alignment():
	for fish in fish_list:
		fish.neighboring_boids = 0
		fish.vel_avg = Vector2(0.0,0.0)
		var distance = Vector2(0.0,0.0)
		for other_fish in fish_list:
			distance = fish.position - other_fish.position
			if (distance.length() < fish.visible_range):
				fish.vel_avg += other_fish.vel_avg
				fish.neighboring_boids += 1
		if (fish.neighboring_boids > 0):
			fish.vel_avg = fish.vel_avg/fish.neighboring_boids
		fish.velocity += (fish.vel_avg)* fish.matching_factor
		detect_wall_collisions(fish)


func cohesion():
	for fish in fish_list:
		fish.pos_avg = Vector2(0.0,0.0)
		fish.neighboring_boids = 0
		for other_fish in fish_list:
			fish.pos_avg += other_fish.position
			fish.neighboring_boids += 1
		if (fish.neighboring_boids > 0):
			fish.pos_avg = fish.pos_avg/fish.neighboring_boids
		fish.velocity += (fish.pos_avg - fish.position)*fish.centering_factor
		detect_wall_collisions(fish)

func detect_wall_collisions(fish):
	var rightmargin = 1280
	var bottommargin = 720
	var topmargin = 0
	var leftmargin = 0
	var dist_right_border = rightmargin - fish.position.x
	var dist_left_border = leftmargin - fish.position.x
	var dist_top_border =  fish.position.y - topmargin
	var dist_bottom_border = bottommargin - fish.position.y
	
	if (fish.position.x >= rightmargin):
		fish.velocity.x = -fish.velocity.x
	else:
		fish.velocity.x = fish.velocity.x + (-1/dist_right_border)
	
	if (fish.position.x <= 0):
		fish.velocity.x = -fish.velocity.x
	else:
		fish.velocity.x = fish.velocity.x + (1/dist_left_border)
	
	if (fish.position.y <= 0):
		fish.velocity.y = -fish.velocity.y
	else:
		fish.velocity.y = fish.velocity.y + (1/dist_top_border)
	
	if (fish.position.y >= bottommargin):
		fish.velocity.y = -fish.velocity.y
	else:
		fish.velocity.y = fish.velocity.y + (-1/dist_bottom_border)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(get_viewport().get_visible_rect().size)
	separation()
	alignment()
	cohesion()
	pass
