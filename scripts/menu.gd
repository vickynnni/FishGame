extends Node2D

var FishClass = preload("res://regular_fish.tscn")
var NarrowFishClass = preload("res://narrow_fish.tscn")
var MoonfishClass = preload("res://moonfish.tscn")
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
		f.z_index = 0
		fish_list.append(f)
		
	var bank = FishBank.new(fish_list)
	bank.has_menu = true
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
		f.z_index = 0
	var bank = FishBank.new(fish_list)
	bank.has_menu = true
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
		f.z_index = 0
	var bank = FishBank.new(fish_list)
	bank.has_menu = true
	bank_list.append(bank)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	for n in 3:
		create_narrow_bank(randi()%10 + 2)
	for n in 4:
		create_normal_bank(randi()%10 + 2)
	for n in 3:
		create_moonfish_bank(randi()%10 + 2)
	pass

func _process(delta):
	for bank in bank_list:
		bank._process(delta)
	pass

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://main_scene.tscn");


func _on_quit_button_pressed():
	get_tree().quit();
