extends StaticBody2D

#
# enums
#

enum SlideDirection { Left, Right }

#
# signals
#

signal opened
signal closed

#
# exports
#

@export var slide_direction: SlideDirection = SlideDirection.Left
@export var close_timeout: float = 0

#
# nodes
#

@onready var close_timer_node: Timer = %CloseTimer

#
# private vars
#

var _start_x: float
var _open: bool = false
@onready var _rect: RectangleShape2D = %Collision.shape as RectangleShape2D

#
# methods
#

func _ready():
	_start_x = position.x

func open(_body: Node2D):
	if _open:
		return
	_open = true
	var k = 2 * slide_direction - 1
	create_tween().tween_property(self, 'position', Vector2(_start_x + k * _rect.size.x, position.y), .2).finished.connect(_start_close)
	
func _start_close():
	opened.emit()
	
	if close_timeout <= 0:
		return
	close_timer_node.start(close_timeout)
	
func close():
	_open = false
	closed.emit()
	# TODO? move to finished
	create_tween().tween_property(self, 'position', Vector2(_start_x, position.y), .2)

#
# signal connections
#

func _on_close_timer_timeout():
	close()
