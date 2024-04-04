extends Area2D

var velocity = Vector2(0.0,0.0);
var player = null;
var r;

# Called when the node enters the scene tree for the first time.
func _ready():
		player = get_tree().get_nodes_in_group("PlayerFish")[0];
		position = Vector2(-500.0,0.0);
		velocity = Vector2(4.0,4.0);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		follow();

func follow():
	if player != null:
		r = position.direction_to(player.position) * velocity;
		rotation = r.angle();
		position += r;

func _on_area_entered(area):
	if area.get_name() == "PlayerFish":
		get_tree().change_scene_to_file("res://game_over.tscn");
