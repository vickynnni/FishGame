extends ParallaxBackground


# Called when the node enters the scene tree for the first time.
func _ready():
	var sprite = get_node("ParallaxLayer/Sprite2D")
	var sprite_width = sprite.texture.get_width()*sprite.scale.x
	var sprite_length = sprite.texture.get_height()*sprite.scale.x
	var p_layer = get_node("ParallaxLayer")
	p_layer.set_mirroring(Vector2(sprite_width,sprite_length))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
