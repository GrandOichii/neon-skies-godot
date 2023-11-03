extends HBoxContainer

#
# nodes
#

@onready var magazine_display: Label = %Magazine
@onready var total_display: Label = %Total

#
# signal connections
#



func _on_attack_controller_magazine_ammo_count_changed(new_value: int):
	magazine_display.text = str(new_value)


func _on_attack_controller_total_ammo_count_changed(new_value: int):
	total_display.text = str(new_value)
