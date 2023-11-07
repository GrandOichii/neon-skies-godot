extends CharacterBody2D
class_name Enemy

#
# exports
#

@export var controller: EnemyController
@export var drop_table: LootTable

#
# signal connections
#

func _on_health_lost_health(amount):
	pass # Replace with function body.


func _on_health_reached_zero():
	queue_free()
	# TODO drop items
