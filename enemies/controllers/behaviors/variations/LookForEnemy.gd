extends EnemyBehavior

#
# signals
#

signal lost_target
signal found_target

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

var _found: bool = false

#
# methods
#

func eb_start():
	super.eb_start()
	_found = false
	
func eb_stop():
	super.eb_stop()
	
func eb_process(delta: float):
	super.eb_process(delta)
	var r = turn_speed * delta
	body.rotate(r)

func _process(delta: float):
	var p1 = laser_pointer_start.global_position
	var p2 = laser_pointer_start.global_position + Vector2(range, 0).rotated(body.rotation)
	raycast_node.position = p1
	raycast_node.target_position = Vector2(range, 0).rotated(body.rotation)
	laser_line_node.set_point_position(0, p1)
	laser_line_node.set_point_position(1, p2)
	if raycast_node.is_colliding():
		laser_line_node.set_point_position(1, raycast_node.get_collision_point())
		var body = raycast_node.get_collider() as Node
		var is_player = body.is_in_group('player')
		if is_player and not _found:
			controller.data['enemy'] = body
			found_target.emit()
			_found = true
		if _found and not is_player:
			lost_target.emit()
			_found = false
			return

#
# signal connections
#

func _on_sound_listener_heard_sound(area: Area2D):
	print('Huh?')
