extends Item
class_name ImplantResource

#
# exports
#

@export var from: int = 1
@export var to: int = 1

#
# methods
#

func on_pickup(player: Player):
	super.on_pickup(player)
	player.implant_consumable_node.value += randi_range(from, to)

