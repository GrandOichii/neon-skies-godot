extends EnemyBehavior

enum PatrolType { Clockwise, CounterClockwise, FlipFlop }

# when enabled, find the closest spot to the patrol line and walk there
#

#
# exports
#

@export var patrol_speed: float
@export var initial_patrol_type: PatrolType = PatrolType.Clockwise
@export var patrol_line: PatrolLine

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
	controller.speed = patrol_speed
	
	var d = 0
	for i in patrol_line.get_point_count():
		var ppos = patrol_line.get_point_position(i)
		var pd = controller.global_position.distance_to(ppos)
		if pd < d or i == 0:
			d = pd
			_current = i
	controller.move_target = patrol_line.global_position + patrol_line.get_point_position(_current)
	
func eb_physics_process(delta: float):
	super.eb_physics_process(delta)
	
	controller.move_towards_target(delta)
	if not controller.reached_target():
		return
	var switch = false
	_current += _step
	var s = patrol_line.get_point_count()
	if _pt != PatrolType.FlipFlop:
		_current = wrap(_current, 0, s)
	else:
		# is flip flop
		if _current < 0 or _current >= s:
			_step *= -1
			_current += 2 * _step
	controller.move_target = patrol_line.global_position + patrol_line.get_point_position(_current)
