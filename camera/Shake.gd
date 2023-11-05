extends Node

#
# exports
#

@export var camera: Camera

# TODO? use the gun to figure out these values
@export_group('Player shooting')
@export var player_fired_duration: float
@export var player_fired_frequency: float
@export var player_fired_amplitude: float

@export_group('Player getting hit')
@export var player_hit_duration: float
@export var player_hit_frequency: float
@export var player_hit_amplitude: float

#
# signal connections
#

func _on_health_lost_health(amount):
	camera.shake(player_hit_duration, player_hit_frequency, player_hit_amplitude)

func _on_attack_controller_gun_fired():
	camera.shake(player_fired_duration, player_fired_frequency, player_fired_amplitude)
