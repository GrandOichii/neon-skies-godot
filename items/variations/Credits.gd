extends Item
class_name Credits

#
# exports
#

@export var from: int
@export var to: int

#
# methods
#

func on_pickup(player: Player):
	super.on_pickup(player)
	player.credits += randi_range(from, to)
