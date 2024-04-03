extends Node2D

var FishClass = preload("res://regular_fish.tscn")
var NarrowFishClass = preload("res://narrow_fish.tscn")
var MoonfishClass = preload("res://moonfish.tscn")
@onready
var player = get_node("PlayerFish")
var bank_list = []

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



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
	#print(get_viewport().get_visible_rect().size)
	pass
