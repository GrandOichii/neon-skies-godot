extends EnemyBehavior

#
# exports
#

@export var turn_speed: float
@export var range: float
@export var body: CharacterBody2D
@export var laser_pointer_start: Node2D

#
# nodes
#

@onready var laser_line_node: Line2D = %LaserLine
@onready var raycast_node: RayCast2D = %RayCast

#
# private vars
#

#
# methods
#

func eb_start():
	super.eb_start()
	
func eb_process(delta: float):
	super.eb_process(delta)
	var r = turn_speed * delta
	body.rotate(r)
#	laser_line_node.rotate(r)
	
func eb_stop():
	super.eb_stop()

func _process(delta: float):
	_point()

#func _ready():
#	_point()
	
func _point():
	laser_line_node.set_point_position(0, laser_pointer_start.global_position)
	laser_line_node.set_point_position(1, laser_pointer_start.global_position + Vector2(range, 0).rotated(body.rotation))
	
