extends Item
class_name Ammo

#
# exports
#

@export var gain_mult: int = 1

#
# methods
#

func on_pickup(player: Player):
	super.on_pickup(player)
	player.weapons_controller_node.add_ammo(gain_mult)
