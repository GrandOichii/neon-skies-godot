extends EnemyBehavior

enum PatrolType { Clockwise, CounterClockwise, FlipFlop }

# when enabled, find the closest spot to the patrol line and walk there
#

#
# exports
#

@export var initial_patrol_type: PatrolType = PatrolType.Clockwise

#
# nodes
#

@onready var patrol_line_node: Line2D = %PatrolLine

#
# private vars
#


var _pt: PatrolType :
	get:
		return _pt
	set(value):
		_pt = value
		_step = 1
		if _pt == PatrolType.CounterClockwise:
			_step = -1
			
var _step: int

var _current: int

#
# methods
#

func _ready():
#	patrol_line_node.visible = false
	_pt = initial_patrol_type

func eb_start():
	super.eb_start()
	var d = 0
	for i in patrol_line_node.get_point_count():
		var ppos = patrol_line_node.get_point_position(i)
		var pd = controller.body.global_position.distance_to(ppos)
		if pd < d or i == 0:
			d = pd
			_current = i
	controller.move_target = patrol_line_node.global_position + patrol_line_node.get_point_position(_current)
	
func eb_physics_process(delta: float):
	super.eb_physics_process(delta)
	
	controller.move_towards_target(delta)
	if not controller.reached_target():
		return
	var switch = false
	_current += _step
	var s = patrol_line_node.get_point_count()
	if _pt != PatrolType.FlipFlop:
		_current = wrap(_current, 0, s)
	else:
		# is flip flop
		if _current < 0 or _current >= s:
			_step *= -1
			_current += 2 * _step
	controller.move_target = patrol_line_node.global_position + patrol_line_node.get_point_position(_current)
