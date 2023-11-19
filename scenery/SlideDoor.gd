extends Node2D

#
# enums
#

enum SlideDirection { Left, Right }

#
# exports
#

@export var length: int
@export var start_tex: Texture2D
@export var mid_tex: Texture2D
@export var end_tex: Texture2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var start_s = Sprite2D.new()
	start_s.texture = start_tex
	add_child(start_s)
	start_s.position = Vector2(0, 0)
	
	var acc = start_s.texture.get_width()
	
	for i in length - 2:
		var child = Sprite2D.new()
		child.position.x = acc
		child.texture = mid_tex
		add_child(child)
		
		acc += child.texture.get_width()
		
	var end_s = Sprite2D.new()
	end_s.texture = start_tex
	add_child(end_s)
	end_s.position.x = acc
	
		
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
