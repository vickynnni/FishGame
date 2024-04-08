extends Node2D

var FishClass = preload("res://regular_fish.tscn")
var NarrowFishClass = preload("res://narrow_fish.tscn")
var MoonfishClass = preload("res://moonfish.tscn")
var Predator = preload("res://predator.tscn")
@onready
var player = get_node("PlayerFish")
@onready
var predator_list = []
var bank_list = []
var points = 0
var points_multiplier = 1.0
var points_boost = 0
var points_boosting = false
var boost_lock = null


func create_normal_bank(num_fish):
	var fish_list = []
	var bank_pos = Vector2(randf_range(-2000.0,2000.0),randf_range(-2000.0,2000.0))
	for n in num_fish:
		var f = FishClass.instantiate()
		add_child(f)
		f.position = bank_pos
		f.position += Vector2(randf_range(-10.0,10.0),randf_range(-10.0,10.0))
		f.fish_name += "r" + str(n)
		fish_list.append(f)
		
	var bank = FishBank.new(fish_list)
	bank_list.append(bank)
		
func create_narrow_bank(num_fish):
	var fish_list = []
	var bank_pos = Vector2(randf_range(-2000.0,2000.0),randf_range(-2000.0,2000.0))
	for n in num_fish:
		var f = NarrowFishClass.instantiate()
		add_child(f)
		f.position = bank_pos
		f.position += Vector2(randf_range(-10.0,10.0),randf_range(-10.0,10.0))
		f.fish_name += "n" + str(n)
		fish_list.append(f)
	var bank = FishBank.new(fish_list)
	bank_list.append(bank)
	
func create_moonfish_bank(num_fish):
	var fish_list = []
	var bank_pos = Vector2(randf_range(-2000.0,2000.0),randf_range(-2000.0,2000.0))
	for n in num_fish:
		var f = MoonfishClass.instantiate()
		add_child(f)
		f.position = bank_pos
		f.position += Vector2(randf_range(-10.0,10.0),randf_range(-10.0,10.0))
		f.fish_name += "n" + str(n)
		fish_list.append(f)
	var bank = FishBank.new(fish_list)
	bank_list.append(bank)
# Called when the node enters the scene tree for the first time.
func _ready():
	for n in 10:
		create_narrow_bank(randi()%6 + 4)
	for n in 8:
		create_normal_bank(randi()%10 + 2)
	for n in 8:
		create_moonfish_bank(randi()%8 + 2)
	player.set_banks(bank_list)
	spawn_predator()
	pass # Replace with function body.


func boid_predators():
	for pred in predator_list:
		for other_pred in predator_list:
			if(pred == other_pred):
				continue
			var dist = pred.position - other_pred.position
			if dist.length() < 300:
				pred.velocity += dist.normalized()*0.0002 + dist*0.0005
				

func boid_banks(delta):
	for bank in bank_list:
		for other_bank in bank_list:
			var dist = bank.bank_position - other_bank.bank_position
			if(dist.length() <  300):
				bank.avoid_bank(dist)
		bank._process(delta)
	var avg_pos = Vector2(0.0,0.0)
	var n = 0
	for bank in bank_list:
		avg_pos += bank.bank_position
		n+=1
	avg_pos /= n
	for bank in bank_list:
		var goto = avg_pos - bank.bank_position 
		bank.gotoavg(goto)

func calc_points():
	points += player.velocity.length()*0.1*points_multiplier + 0.01
	$Camera2D/Points.text = str(floor(points))
	$Camera2D/Multiplier.text = "x%.1f" % float(points_multiplier)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(get_viewport().get_visible_rect().size)
	calc_points()
	boid_banks(delta)
	boid_predators()
	handle_bars()
	$points2d.position = player.position + Vector2(0,-80)
	for predator in predator_list:
		follow_player(predator)
	pass


func handle_bars():
	var bar1 = $Camera2D/Node2D/barra1
	var bar2 = $Camera2D/Node2D/barra2
	var bar3 = $Camera2D/Node2D/barra3
	var speed_timer = player.boost_timer
	var num_boosts = player.num_boosts
	var percent = ((speed_timer.wait_time-speed_timer.time_left) / speed_timer.wait_time) *100
	print(num_boosts)
	print(percent)
	if num_boosts == 0:
		bar1.value = percent
		bar2.value = 0
		bar3.value = 0
	elif num_boosts == 1:
		bar1.value = 100
		bar2.value = percent
		bar3.value = 0
	elif num_boosts == 2:
		bar1.value = 100
		bar2.value = 100
		bar3.value = percent
	elif num_boosts == 3:
		bar1.value = 100
		bar2.value = 100
		bar3.value = 100

func follow_player(predator):
	var dist = player.position - predator.position
	predator.follow(dist)
	
	if(dist.length() < 50.0):
		global.score = points
		get_tree().change_scene_to_file("res://game_over.tscn");
		
	elif(dist.length() < 200.0):
		if(boost_lock == null):
			boost_lock = predator
			$points2d.visible = true
			
			$AnimationPlayer.play("fade_in")
			$points2d/points_boost.scale = Vector2(1.0,1.0)
			$points2d/points_boost2.scale = Vector2(1.0,1.0)
			points_boost = 200
		if boost_lock == predator:
			points_boost += 0.5
		$points2d/points_boost.text = str(int(points_boost))
	else:
		if (boost_lock == predator):
			$AnimationPlayer.play("fade_out")
			boost_lock = null
			points += points_boost*points_multiplier
			points_boost = 0
			
var n_predators = 0
func spawn_predator():
	n_predators+=1
	if(n_predators > 1):
		points_multiplier += 1.0
	var p = Predator.instantiate()
	add_child(p)
	p.position = player.position + Vector2(randf_range(-2000,2000),randf_range(-2000,2000))
	predator_list.append(p)
	p.set_banks(bank_list)
	p.vel_multiplier *= 1.1+0.1*(n_predators-1)
	pass # Replace with function body.


func _on_animation_player_animation_finished(anim_name):
	if(anim_name == "fade_out"):
		$points2d/points_boost.scale = Vector2(1.0,1.0)
		$points2d/points_boost2.scale = Vector2(1.0,1.0)
	pass # Replace with function body.
