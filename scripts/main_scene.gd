extends Node2D

var FishClass = preload("res://regular_fish.tscn")
var NarrowFishClass = preload("res://narrow_fish.tscn")
@onready
var player = get_node("PlayerFish")
var bank_list = []

func create_normal_bank(num_fish):
	var fish_list = []
	for n in num_fish:
		var f = FishClass.instantiate()
		add_child(f)
		f.position += Vector2(randf_range(-10.0,10.0),randf_range(-10.0,10.0))
		f.fish_name += "r" + str(n)
		fish_list.append(f)
		
	var bank = FishBank.new(fish_list)
	bank_list.append(bank)
		
func create_narrow_bank(num_fish):
	var fish_list = []
	for n in num_fish:
		var f = NarrowFishClass.instantiate()
		add_child(f)
		f.position += Vector2(randf_range(-10.0,10.0),randf_range(-10.0,10.0))
		f.fish_name += "n" + str(n)
		fish_list.append(f)
	var bank = FishBank.new(fish_list)
	bank_list.append(bank)

# Called when the node enters the scene tree for the first time.
func _ready():
	for n in 1:
		create_narrow_bank(5)
	for n in 1:
		create_normal_bank(10)
	player.set_banks(bank_list)
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for bank in bank_list:
		bank._process(delta)
	#print(get_viewport().get_visible_rect().size)
	pass
