extends Node2D
class_name ItemHolder

#
# vars
#

var item: Item :
	get:
		return item
	set(value):
		item = value
		# TODO set texture

#
# signal connections
#

func _on_area_2d_body_entered(body: Node2D):
	if not body.is_in_group('player'):
		return
	item.on_pickup(body as Player)
	queue_free()
