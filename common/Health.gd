extends Node
class_name Health

#
# signals
#

signal changed(to: int)
signal max_changed(to: int)
signal lost_health(amount: int)
signal reached_zero()

#
# exports
#

@export var initial_value: int
@export var initial_max: int
@export var immortal: bool = false

#
# vars
#

var health: int :
	get:
		return health
	set(value):
		var prev = health
		health = value
		if health > max_health: health = max_health
		if health <= 0 and not immortal:
			health = 0
			reached_zero.emit()
		changed.emit(health)
		if prev > health: lost_health.emit(prev - health);
		
var max_health: int :
	get:
		return max_health
	set(value):
		var old = max_health;
		var diff = value - max_health;
		max_health = value;
		if health > max_health: health = max_health;
		if diff > 0:
			health += diff;
		
		max_changed.emit(max_health);

#
# methods
#

func _ready():
	max_health = initial_max
	health = initial_value
