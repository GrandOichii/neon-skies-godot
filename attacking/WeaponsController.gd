extends Node
class_name WeaponsController

#
# sub classes
#

#
# signals
#

signal gun_equipped(gun_holder: GunHolder)
signal ammo_added(gun_holder: GunHolder)

#
# exports
#

@export var max_guns: int = 2
@export var max_melee: int = 1
@export var initial_guns: Array[Gun]

#
# vars
#

var guns: Array[GunHolder]

var current: int :
	get:
		return current
	set(value):
		# TODO add melee
		current = wrapi(value, 0, guns.size())
		gun_equipped.emit(guns[current])
#
# methods
#

func _ready():
	print('ready')
	for i in range(max_guns):
		guns.push_back(null)
	
	for i in range(min(initial_guns.size(), guns.size())):
		guns[i] = GunHolder.new(initial_guns[i])
		
	if guns[0] == null:
		return
		
	current = 0

func _input(event: InputEvent):
	if event.is_action_pressed('next-weapon'):
		# TODO scroll to next available gun
		current += 1

func add_ammo(gain_mult: int):
	for gh in guns:
		gh.ammo_count += gh.gun.ammo_gain * gain_mult
		ammo_added.emit(gh)
