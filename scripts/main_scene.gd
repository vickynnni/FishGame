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

func create_normal_bank(num_fish):
	var fish_list = []
	var bank_pos = Vector2(randf_range(-1000.0,1000.0),randf_range(-1000.0,1000.0))
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
	var bank_pos = Vector2(randf_range(-1000.0,1000.0),randf_range(-1000.0,1000.0))
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
	var bank_pos = Vector2(randf_range(-1000.0,1000.0),randf_range(-1000.0,1000.0))
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
		create_narrow_bank(randi()%10 + 2)
	for n in 15:
		create_normal_bank(randi()%10 + 2)
	for n in 10:
		create_moonfish_bank(randi()%10 + 2)
	player.set_banks(bank_list)
	pass # Replace with function body.


func boid_predators():
	for pred in predator_list:
		for other_pred in predator_list:
			if(pred == other_pred):
				continue
			var dist = pred.position - other_pred.position
			if dist.length() < 200:
				pred.velocity += dist.normalized()*0.001 + dist*0.0001
				

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(get_viewport().get_visible_rect().size)
	calc_points()
	boid_banks(delta)
	boid_predators()
	pass

var n_predators = 0
func spawn_predator():
	n_predators+=1
	var p = Predator.instantiate()
	add_child(p)
	p.position = player.position + Vector2(randf_range(-2000,2000),randf_range(-2000,2000))
	predator_list.append(p)
	p.set_banks(bank_list)
	p.max_speed += 0.1*n_predators
	pass # Replace with function body.
