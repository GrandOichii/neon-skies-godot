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

#
# private vars
#

var _reached_zero: bool = false

#
# methods
#

func _create_drop(ih: ItemHolder, item: Item):
	get_tree().root.add_child(ih)
	ih.global_position = global_position
	ih.item = item

#
# signal connections
#

func _on_health_changed(to: int):
	# TODO add logic for multiple drops
	# TODO choose item
	
	if to > 0:
		return
	if _reached_zero:
		return
	_reached_zero = true
	if drop_table == null:
		queue_free()
		return
	var item = drop_table.single()
	if item == null:
		queue_free()
		return
	var item_holder = item_holder_ps.instantiate() as ItemHolder
	call_deferred('_create_drop', item_holder, item)
	
	queue_free()
