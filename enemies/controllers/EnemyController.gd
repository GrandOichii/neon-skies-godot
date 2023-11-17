extends Node
class_name EnemyController

#
# exports
#

@export var initial_state: String
@export var nav_agent: NavigationAgent2D
@export var consider_reached_distance: float
@export var body: CharacterBody2D
@export var sprite: Sprite2D

#
# nodes
#

@onready var behaviors_container: Node = %Behaviors

#
# vars
#

var speed: float

var data: Dictionary = {}
var move_target: Vector2 :
	get:
		return move_target
	set(value):
		move_target = value
		nav_agent.target_position = move_target

#
# private vars
#

var _behaviors: Dictionary = {}
var _current: String = ''

#
# methods
#

func _ready():
	for b in behaviors_container.get_children():
		var beh = b as EnemyBehavior
		beh.controller = self
		_behaviors[beh.state] = beh
		
	call_deferred('_setup_agent')
	
func _setup_agent():
	await get_tree().process_frame # TODO? found online, is ok
	set_state(initial_state)
	
func _process(delta):
	if _current.length() == 0:
		return
	_behaviors[_current].eb_process(delta)
	
func _physics_process(delta):
	if _current.length() == 0:
		return
	_behaviors[_current].eb_physics_process(delta)

func set_state(state: String):
	if _current.length() != 0:
		_behaviors[_current].eb_stop()
	_current = state
	_behaviors[_current].eb_start()

func move_towards_target(delta: float):
	var loc = nav_agent.get_next_path_position()
	var dir = body.to_local(loc).normalized()
	
	var vel = dir * speed
	
#	var t = create_tween()
	var target = (loc - sprite.global_position).angle()
	var lr = lerp_angle(sprite.global_rotation, target, .1)
	
	sprite.global_rotation = lr
#	create_tween().tween_method(sprite.rotate, sprite.rotation, r, .1)
#	create_tween().tween_property()

	nav_agent.set_velocity(vel)
#	body.velocity = vel
#	body.move_and_slide()

func reset_target():
	nav_agent.set_velocity(Vector2.ZERO)
	
func reached_target() -> bool:
	return nav_agent.is_target_reached() or nav_agent.distance_to_target() < consider_reached_distance
#
# signal connections
#

# TODO not yet in use, has to be used with obstacles, although they don't seem to be working for me
func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2):
	body.velocity = safe_velocity
	body.move_and_slide()
	reset_target()
