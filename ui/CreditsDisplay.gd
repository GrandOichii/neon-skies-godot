extends Label

#
# signal connections
#

func _on_player_credits_changed(value: int):
	text = str(value)
