extends CharacterBody2D
class_name Enemy

#
# packed scenes
#

@export var item_holder_ps: PackedScene

#
# exports
#

@export var controller: EnemyController
@export var drop_table: LootTable

func _create_drop(ih: ItemHolder, item: Item):
	get_tree().root.add_child(ih)
	ih.global_position = global_position
	ih.item = item

#
# signal connections
#

func _on_health_lost_health(amount):
	pass # Replace with function body.


func _on_health_reached_zero():
	# TODO add logic for multiple drops
	# TODO choose item
	var item = drop_table.single()
	if item == null:
		queue_free()
		return
	var item_holder = item_holder_ps.instantiate() as ItemHolder
	call_deferred('_create_drop', item_holder, item)
	
	queue_free()
