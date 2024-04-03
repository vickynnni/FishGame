extends Camera2D

var velocity = Vector2(0.0,0.0)
@onready
var player = get_node("../PlayerFish")
var speed_factor = 0.001
var dist_threshold = 0
var drag = 0.99
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dist_to_player = player.position - position
	var multiplier = 1
	if(player.velocity.length() > 5 or player.attached_to_bank!=null):
		dist_to_player=dist_to_player*50+(player.velocity/speed_factor)*1.5
		
		velocity = dist_to_player*speed_factor
	else:
		velocity += dist_to_player*speed_factor*1
			
	velocity *= drag
	position += velocity
	pass
