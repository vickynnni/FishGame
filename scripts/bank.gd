class_name FishBank

var fish_list = []
var bank_position = Vector2(0.0,0.0)
var has_player = false
var bank_max_speed = 6
var bank_speed_boost = 8
var normal_speed = 6
var avg_velocity = Vector2(0.0,0.0)

func avoid_bank(dist):
	for fish in fish_list:
		fish.velocity += dist*0.00001

func gotoavg(pos):
	for fish in fish_list:
		fish.velocity += pos*0.00001

func teleport(_position:Vector2):
	#print("teleported to" + str(_position))
	var velocity = Vector2(randf_range(-20.0,20.0),randf_range(-20.0,20.0))
	for fish in fish_list:
		fish.position = _position + Vector2(randf_range(-30.0,30.0),randf_range(-30.0,30.0))
		fish.velocity = velocity

func _init(_fish_list:Array):
	fish_list = _fish_list
	var position = Vector2(randf_range(100,1000.0),randf_range(100,700.0))
	var velocity = Vector2(randf_range(-10.0,10.0),randf_range(-10.0,10.0))
	normal_speed = fish_list[0].max_speed
	for fish in fish_list:
		fish.position = position + Vector2(randf_range(-30.0,30.0),randf_range(-30.0,30.0))
		fish.velocity = velocity

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


func separation(list):
	for fish in list:
		fish.close_d = Vector2(0.0,0.0)
		var distance = Vector2(0.0,0.0)
		var threshold = fish.separation
		for other_fish in list:
			if(fish == other_fish):
				continue
			distance = fish.position - other_fish.position
			if (distance.length() <= threshold):
				fish.close_d += distance
			if(distance.length() < 0.5):
				fish.close_d += Vector2(randf_range(-20.0,20.0),randf_range(-20.0,20.0))
		if(fish.fishType == "player"):
			if(fish.no_external_forces):
				continue
		fish.velocity += fish.close_d * fish.avoidfactor
		#detect_wall_collisions(fish)

func add_player(player):
	if !has_player:
		fish_list.append(player)
		has_player = true
		#for fish in fish_list:
			#fish.max_speed += 2
			#bank_max_speed = bank_speed_boost

func remove_player(player):
	if has_player:
		fish_list.remove_at(fish_list.size() - 1)
		has_player = false
		#for fish in fish_list:
			#bank_max_speed = normal_speed
			#fish.max_speed -= 3
	
func alignment(list):
	for fish in list:
		fish.neighboring_boids = 0
		fish.vel_avg = Vector2(0.0,0.0)
		var distance = Vector2(0.0,0.0)
		var matching_factor = fish.matching_factor
		for other_fish in list:
			if(fish == other_fish):
				continue
			distance = fish.position - other_fish.position
			if(other_fish.fishType == "player"):
				#print("player")
				#fish.vel_avg -= other_fish.velocity #se cancelan?
				continue
			fish.vel_avg += other_fish.velocity
			fish.neighboring_boids += 1
			
		if (fish.neighboring_boids > 0):
			fish.vel_avg = fish.vel_avg/fish.neighboring_boids
		var multiplier = 1.0
		if(fish.fishType == "player"):
			multiplier = 1.4
			if(fish.no_external_forces):
				continue
		fish.velocity += (fish.vel_avg) * matching_factor * multiplier
		#detect_wall_collisions(fish)


func cohesion(list):
	var pos_avg = Vector2(0.0,0.0)
	var neighboring_boids = 0
	for fish in list:
		if(fish.fishType == "player"):
			continue #No tenemos en cuenta al jugador para que no pare a los peces si está detrás del banco
		pos_avg += fish.position
		neighboring_boids += 1
	if (neighboring_boids > 0):
		pos_avg = pos_avg/neighboring_boids
	for fish in list:
		if(fish.fishType == "player"):
			if(fish.no_external_forces):
				continue
		fish.velocity += (pos_avg - fish.position)*fish.centering_factor
		#detect_wall_collisions(fish)
	bank_position = pos_avg

func detect_wall_collisions(fish):
	var collision_factor = 5
	var rightmargin = 1280
	var bottommargin = 720
	var topmargin = 0
	var leftmargin = 0
	var dist_right_border = rightmargin - fish.position.x
	var dist_left_border = fish.position.x - leftmargin
	var dist_top_border =  fish.position.y - topmargin
	var dist_bottom_border = bottommargin - fish.position.y
	
	if (fish.position.x >= rightmargin):
		fish.velocity.x = -fish.velocity.x
	else:
		fish.velocity.x = fish.velocity.x + (-1/dist_right_border)*collision_factor
	
	if (fish.position.x <= leftmargin):
		fish.velocity.x = -fish.velocity.x
	else:
		fish.velocity.x = fish.velocity.x + (1/dist_left_border)*collision_factor
	
	if (fish.position.y <= topmargin):
		fish.velocity.y = -fish.velocity.y
	else:
		fish.velocity.y = fish.velocity.y + (1/dist_top_border)*collision_factor
	
	if (fish.position.y >= bottommargin):
		fish.velocity.y = -fish.velocity.y
	else:
		fish.velocity.y = fish.velocity.y + (-1/dist_bottom_border)*collision_factor
		
func calc_avg_velocity():
	var n = 0
	var avg = Vector2(0.0,0.0)
	for fish in fish_list:
		n+=1
		avg += fish.velocity
	if(n != 0):
		avg /= n
		return avg
	return Vector2(0.0,0.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	avg_velocity = calc_avg_velocity()
	separation(fish_list)
	alignment(fish_list)
	cohesion(fish_list)
	pass

