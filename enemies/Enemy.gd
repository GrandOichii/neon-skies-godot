extends CharacterBody2D
class_name Enemy

#
# exports
#

@export var controller: EnemyController

#
# signal connections
#

func _on_health_lost_health(amount):
	pass # Replace with function body.


func _on_health_reached_zero():
	queue_free()
