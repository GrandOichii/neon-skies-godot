extends Node2D
class_name LaserPointer

#
# exports
#

@export var color: Color
@export var laser_range: float
@export var muzzle_point: Node2D

#
# nodes
#

@onready var line_node: Line2D = %Line
@onready var ray_cast_node: RayCast2D = %RayCast

#
# methods
#

func _ready():
	var start = to_local(muzzle_point.global_position)
	ray_cast_node.position = start
	ray_cast_node.target_position = start + Vector2(laser_range, 0)
	line_node.set_point_position(0, start)
#	line_node.set_point_position(1, start + Vector2(laser_range, 0))

func _process(delta: float):
	var point = ray_cast_node.target_position
	if ray_cast_node.is_colliding():
		point = to_local(ray_cast_node.get_collision_point())
	line_node.set_point_position(1, point)
	
	
