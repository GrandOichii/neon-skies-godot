extends Label

#
# methods
#

func _ready():
	visible = false

#
# signal connections
#
	
func _on_player_died():
	visible = true
