extends Node2D

#
# exports
#

@export var speed: float
@export var dissapear_after: float

#
# private vars
#

@onready var _left: float = dissapear_after

#
# methods
#

func _physics_process(delta: float):
	position += transform.x * speed * delta

func _process(delta):
	_left -= delta
	if _left < 0:
		queue_free()

#
# signal connections
#

func _on_body_entered(body):
	print(body)
