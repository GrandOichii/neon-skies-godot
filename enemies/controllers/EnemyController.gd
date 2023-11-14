extends Node
class_name EnemyController

#
# exports
#

@export var initial_state: String
@export var speed: float
@export var nav_agent: NavigationAgent2D
@export var body: CharacterBody2D
@export var sprite: Sprite2D

#
# nodes
#

@onready var behaviors_container: Node = %Behaviors

#
# vars
#

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
		
	set_state(initial_state)
	
func _process(delta):
	_behaviors[_current].eb_process(delta)
	
func _physics_process(delta):
	_behaviors[_current].eb_physics_process(delta)

func set_state(state: String):
	if _current.length() != 0:
		_behaviors[_current].eb_stop()
	_current = state
	_behaviors[_current].eb_start()

func move_towards_target():
	var loc = nav_agent.get_next_path_position()
	var dir = body.to_local(loc).normalized()
	var vel = dir * speed
	
	body.velocity = vel
	sprite.look_at(move_target)
	body.move_and_slide()
