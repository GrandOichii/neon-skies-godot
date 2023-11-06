extends Area2D
class_name SoundListener

#
# signals
#

signal heard_sound(area: Area2D)

#
# exports
#

@export var radius: float = 400

#
# nodes
#

@onready var collision_node: CollisionShape2D = %Collision

#
# methods
#

func _ready():
	(%Collision.shape as CircleShape2D).radius = radius


func _on_area_entered(area: Area2D):
	heard_sound.emit(area)
