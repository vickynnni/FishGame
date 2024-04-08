extends Area2D

var velocity = Vector2(0.0,0.0);
var player = null;
var max_speed = 8;
var speed_multiplier = 0.00055
var bank_list = []
var vel_multiplier = 0.0004


func set_banks(b_list):
	bank_list = b_list
	for bank in bank_list:
		bank.addPredator(self)
# Called when the node enters the scene tree for the first time.
func _ready():
		player = get_tree().get_nodes_in_group("PlayerFish")[0];
		position = Vector2(-500.0,0.0);
		velocity = Vector2(0.0,0.0);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		#follow();
		if(velocity.length() > max_speed):
			velocity = velocity.normalized()*max_speed
		check_flip()
		update_anim_speed()
		position += velocity;

<<<<<<< HEAD
func update_anim_speed():
	var fps = floor(velocity)
	$AnimatedSprite2D.speed_scale = velocity.length()*0.1

var rightleft = false
func check_flip():
	var x_scale = $AnimatedSprite2D.scale.x
	var y_scale = $AnimatedSprite2D.scale.y
	if(velocity.x < 0):
		if(!rightleft):
			$AnimatedSprite2D.scale.y = -y_scale
			$AnimatedSprite2D.scale.x = x_scale
			rightleft=true
	else:
		if(rightleft):
			$AnimatedSprite2D.scale.y = -y_scale
			$AnimatedSprite2D.scale.x = x_scale
			rightleft = false

func follow(dist):
	velocity += dist*vel_multiplier;
	rotation = velocity.angle();
=======
func follow():
	if player != null:
		var dist_to_player = player.position - position;
		velocity += dist_to_player*speed_multiplier;
		rotation = velocity.angle();
>>>>>>> ea267ff791030aa661cea161b68fd489a7be1c27

func _on_area_entered(area):
	if area.get_name() == "PlayerFish":
		get_tree().change_scene_to_file("res://game_over.tscn");
