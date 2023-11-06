extends Resource
class_name Gun


enum FireMode { AUTO, FULL_AUTO, PUMP_ACTION }

#
# exports
#

@export var name: String
@export_multiline var description: String
@export var bullet_template: PackedScene
@export var fire_mode: FireMode
@export var fire_interval: float
@export var magazine_size: int

@export_group('Deviation')
@export var max_deviation: float
@export var deviation_decrease_per_second: float
@export var deviation_per_bullet: float

@export_group('Reloading')
@export var eject_time: float
@export var reload_time: float
@export var hot_reload_interval_start: float
@export var hot_reload_interval_end: float

@export_group('Pump-action')
@export var min_pellets_per_shot: float = 1
@export var max_pellets_per_shot: float = 1
@export var pellet_deviation: float = 0

@export_group('Sound')
@export var fire_sound_radius: float = 400
