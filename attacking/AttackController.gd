extends Node2D
class_name AttackController

#
# signals
#
signal magazine_ammo_count_changed(new_value: int)
signal total_ammo_count_changed(new_value: int)
signal gun_fired
signal gun_equipped(gun: Gun)

#
# exports
# 

@export var is_player: bool = false
@export var starting_gun: Gun
@export var rotation_controller: Node2D
@export var initial_total_ammo: int
@export var reload_meter: ReloadMeter

#
# nodes
#

@onready var muzzle: Node2D = %Muzzle
@onready var firerate_timer: Timer = %FirerateTimer

#
# vars
#

var total_ammo_count: int = 0 :
	get:
		return total_ammo_count
	set(value):
		total_ammo_count = value
		total_ammo_count_changed.emit(total_ammo_count)
		
var magazine_ammo_count: int = 0 :
	get:
		return magazine_ammo_count
	set(value):
		magazine_ammo_count = value
		magazine_ammo_count_changed.emit(magazine_ammo_count)
		
#
# private vars
#

var _can_fire: bool = true
var _deviation: float = 0
var _rng = RandomNumberGenerator.new()
var _loaded: bool = true
var _can_advance_reload: bool = true

#
# methods
#

var gun: Gun :
	get:
		return gun
	set(value):
		gun = value
		
		firerate_timer.wait_time = gun.fire_interval
		if reload_meter != null:
			reload_meter.gun = gun
		gun_equipped.emit(gun)
		
func _ready():
	gun = starting_gun
	magazine_ammo_count = gun.magazine_size
	total_ammo_count = initial_total_ammo
		
func fire():
	if not _can_fire: return
	
	if magazine_ammo_count == 0: return
	
	var pellets = _rng.randi_range(gun.min_pellets_per_shot, gun.max_pellets_per_shot)
	var diff = deg_to_rad(_deviation / 2)
	var dev = _rng.randf_range(-diff, diff)
	var p_diff = deg_to_rad(gun.pellet_deviation / 2)
	for i in pellets:
		var bullet = gun.bullet_template.instantiate() as Node2D
		get_tree().root.add_child(bullet)
		bullet.position = muzzle.global_position
		
		bullet.rotation = rotation_controller.rotation + dev + _rng.randf_range(-p_diff, p_diff)
	
	_deviation += gun.deviation_per_bullet
	_deviation = min(_deviation, gun.max_deviation)
	_can_fire = false
	
	magazine_ammo_count -= 1
	gun_fired.emit()
	firerate_timer.start()
	
func _process(delta):
	_check_fire()
	
	_deviation -= gun.deviation_decrease_per_second * delta
	_deviation = max(0, _deviation)

func _check_fire():
	# TODO could be better, move the whole fire logic to Player.gd
	if not is_player:
		return
	if gun.fire_mode == Gun.FireMode.FULL_AUTO and Input.is_action_pressed('fire'):
		fire()
		return
	if Input.is_action_just_pressed('fire'):
		fire()
		
func _input(event):
	if not is_player: return
	
	if event.is_action_pressed('reload'):
		_advance_reload()
		
func _advance_reload():
	if gun.fire_mode == Gun.FireMode.PUMP_ACTION:
		if magazine_ammo_count == gun.magazine_size or total_ammo_count <= 0:
			return
		reload_meter.reload()
		return
			
	if not _can_advance_reload:
		return
		
	if _loaded:
		_can_advance_reload = false
		magazine_ammo_count = 0
		reload_meter.eject()
		return
	if total_ammo_count <= 0:
		return
	reload_meter.reload()

#
# signal connections
#

func _on_firerate_timer_timeout():
	_can_fire = true

func _on_reload_meter_ejected():
	_can_advance_reload = true
	_loaded = false

func _on_reload_meter_reloaded(reload_type):
	if gun.fire_mode == Gun.FireMode.PUMP_ACTION:
		var amount = min(1, total_ammo_count)
		magazine_ammo_count += amount
		total_ammo_count -= amount
		return
	_loaded = true
	magazine_ammo_count = min(gun.magazine_size, total_ammo_count)
	total_ammo_count -= magazine_ammo_count
