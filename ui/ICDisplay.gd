extends Label

#
# exports
#

@export var player: Player

#
# signal connections
#

func _on_implant_charges_changed(to: int):
	text = str(to)
