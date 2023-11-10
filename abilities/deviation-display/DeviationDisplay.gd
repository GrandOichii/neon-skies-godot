extends StaticAbility
class_name DeviationDisplay

#
# exports
#

@export var range: int
@export var lines_color: Color

#
# nodes
#

@onready var line1: Line2D = %Line1
@onready var line2: Line2D = %Line2

#
# methods
#

func _ready():
	line1.default_color = lines_color
	line2.default_color = lines_color

func activate():
	super.activate()
	
func deactivate():
	super.deactivate()

func _process(_delta: float):
	# TOOD bad, can't use in AI
	var p = parent as Player
	var start = p.global_position
	var h = deg_to_rad(p.attack_controller_node.deviation / 2)
	line1.set_point_position(0, start)
	line2.set_point_position(0, start)
	line1.set_point_position(1, start + Vector2(range, 0).rotated(p.sprite_node.rotation - h))
	line2.set_point_position(1, start + Vector2(range, 0).rotated(p.sprite_node.rotation + h))
	
