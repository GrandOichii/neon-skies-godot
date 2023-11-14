extends Node2D
class_name VisionCone

#
# signals
#

signal spotted(body: Node2D)
signal lost(body: Node2D)

#
# exports
#

@export var range: float
@export var degree: float
@export var precision: int = 2
@export var look_for_group: String

#
# nodes
#

@onready var collision_node: CollisionPolygon2D = %Collision
@onready var ray_cast_node: RayCast2D = %Raycast

#
# private vars
#

var _target: Node2D = null
var _spotted: bool = false

#
# methods
#

func _ready():
	# set up cone
	var full = deg_to_rad(degree)
	var step = full / (precision)
	var p = PackedVector2Array()
	p.resize(precision + 2)
	p[0] = Vector2(0, 0)
	var deg = -step * precision / 2
	for i in range(precision + 1):
		p[i + 1] = Vector2(range, 0).rotated(deg)
		deg += step
	collision_node.polygon = p
	
func _process(_delta: float):
	if _target == null:
		return
	ray_cast_node.target_position = ray_cast_node.to_local(_target.global_position)
	if not ray_cast_node.is_colliding():
		return
	var coll = ray_cast_node.get_collider()
	if coll != _target:
		if _spotted:
			_spotted = false
			lost.emit(_target)
		return
	_spotted = true
	spotted.emit(_target)

#
# signal connections
#

func _on_area_2d_body_entered(body: Node2D):
	if not body.is_in_group(look_for_group):
		return
	_target = body

func _on_area_2d_body_exited(body):
	if not body.is_in_group(look_for_group):
		return
	if body != _target:
		return
	
	_target = null
	if _spotted:
		_spotted = false
		lost.emit(body)
