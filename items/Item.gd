extends Resource
class_name Item

#
# exports
#

@export var texture: Texture2D

#
# methods
#

func on_pickup(_player: Player):
	print('Pickup!')
