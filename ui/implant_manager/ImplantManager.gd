extends Control

#
# exports
#

@export var stored_implants: Array[Implant]
@export var implants: ImplantsController

#
# packed scenes
#

@export var implant_display_ps: PackedScene
@export var implant_slot_display_ps: PackedScene

#
# nodes
#

@onready var stored_node: Container = %Stored

#
# private vars
#

var _slot_map: Dictionary = {}

#
# methods
#

func _ready():
	# create slot dictionary and populate slot displays with implants
	for child in %Slots.get_children():
		var slot_display = child as ImplantSlotDisplay
		_slot_map[slot_display.slot] = slot_display
	
	# when slots are initialized, populate display slots with implants
	implants.slots_initialized.connect(
		func _si():
			for slot in _slot_map:
				var implant = implants.slots[slot]
				if implant == null: continue
				
				var slot_display = _slot_map[slot]
				var display = _create_display(implant)
				slot_display.display_holder.add_child(display)
				display.implant = implant
				display.installed = true
	)

	# populate initial implants in grid
	for implant in stored_implants:
		var display = _create_display(implant)
		stored_node.add_child(display)
		display.implant = implant

func _create_display(implant: Implant):
	var result = implant_display_ps.instantiate() as ImplantDisplay
	result.pressed.connect(func _pressed(): _pressed_display(result))
	return result

# TODO remove
func _input(event):
	if event.is_action_pressed('dev-quit'):
		get_tree().quit()

func _pressed_display(display: ImplantDisplay):
	if display.installed:
		_move_to_stored(display)
		return
		
	var slot = display.implant.slot
	var display_slot = _slot_map[slot]
	if display_slot.has_installed_implant():
		_move_to_stored(display_slot.display_holder.get_child(0) as ImplantDisplay)
		
	display.installed = true
	display.reparent(display_slot.display_holder)
	implants.install(display.implant.slot, display.implant)
		

func _move_to_stored(display: ImplantDisplay):
	display.installed = false
	display.reparent(stored_node)
	implants.uninstall(display.implant.slot)
#
# signal connections
#

func _on_slide_from_top_toggled(value: bool):
	get_tree().paused = value
