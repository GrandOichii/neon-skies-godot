extends CharacterBody2D
class_name EnemyController

#
# packed scenes
#

@export var item_holder_ps: PackedScene

#
# exports
#

@export var drop_table: LootTable
@export var consider_reached: float
@export var initial_state: String

#
# nodes
#

@onready var sprite = %Sprite
@onready var nav_agent_node: NavigationAgent2D = %NavAgent
@onready var behaviors_container: Node = %Behaviors

#
# private vars
#

var _reached_zero: bool = false
var _behaviors: Dictionary = {}

#
# vars
#

var speed: float

var current_state: String = '' :
	get:
		return current_state
	set(value):
		if current_state.length() != 0:
			_behaviors[current_state].eb_stop()
		current_state = value
		_behaviors[current_state].eb_start()
	

var data: Dictionary = {}
var move_target: Vector2 :
	get:
		return move_target
	set(value):
		move_target = value
		nav_agent_node.target_position = move_target

var rot_with_move: bool = true

var rot_speed: float = 5

var _old_angle: float
var _rot_target: float
var _rot_elapsed: float
var rot_target: Vector2 :
	get:
		return rot_target
	set(value):
		rot_target = value
		_old_angle = sprite.global_rotation
		_rot_target = (rot_target - sprite.global_position).angle()
		_rot_elapsed = 0
#
# methods
#

func _create_drop(ih: ItemHolder, item: Item):
	get_tree().root.add_child(ih)
	ih.global_position = global_position
	ih.item = item

func _ready():
	for b in behaviors_container.get_children():
		var beh = b as EnemyBehavior
		beh.controller = self
		_behaviors[beh.state] = beh
		
	call_deferred('_setup_agent')

func _setup_agent():
	await get_tree().process_frame # TODO? found online, is ok
	current_state = initial_state

func _process(delta):
	if current_state.length() == 0:
		return
	_behaviors[current_state].eb_process(delta)

func _physics_process(delta):
	if current_state.length() == 0:
		return
	_behaviors[current_state].eb_physics_process(delta)

func rotate_towards_target(delta: float):
	if reached_rotation():
		return
	var dir = rot_target - global_position
	var a = sprite.transform.x.angle_to(dir)
	sprite.rotate(sign(a) * min(delta * rot_speed, abs(a)))
	
func move_towards_target(delta: float):
	
	var loc = nav_agent_node.get_next_path_position()
	if rot_with_move:
		rot_target = loc
	var dir = to_local(loc).normalized()
	
	var vel = dir * speed
	
	rotate_towards_target(delta)

	nav_agent_node.set_velocity(vel)

func reset_target():
	nav_agent_node.set_velocity(Vector2.ZERO)
	
func reached_target() -> bool:
	return not nav_agent_node.is_target_reachable() or nav_agent_node.is_target_reached() or nav_agent_node.distance_to_target() < consider_reached

func reached_rotation() -> bool:
	return abs(sprite.transform.x.angle_to(rot_target - global_position)) < 0.00001

#
# signal connections
#

func _on_health_changed(to: int):
	# TODO add logic for multiple drops
	
	if to > 0:
		return
	if _reached_zero:
		return
	_reached_zero = true
	if drop_table == null:
		queue_free()
		return
	var item = drop_table.single()
	if item == null:
		queue_free()
		return
	var item_holder = item_holder_ps.instantiate() as ItemHolder
	call_deferred('_create_drop', item_holder, item)
	
	queue_free()

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()
	reset_target()
