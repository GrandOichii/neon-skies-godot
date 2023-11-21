extends Area2D
class_name SoundController


#
# nodes
#

@onready var collision_node: CollisionShape2D = %Collision
@onready var disable_timer_node: Timer = %DisableTimer
#
# methods
#

func _ready():
	_disable_collisions()

func _disable_collisions():
	collision_node.disabled = true
	

#
# signal connections
#

func fire():
	collision_node.disabled = false
	disable_timer_node.start()

func _on_attack_controller_gun_fired():
	collision_node.disabled = false
	disable_timer_node.start()

func _on_attack_controller_gun_equipped(gun: Gun):
	(%GunFired.shape as CircleShape2D).radius = gun.fire_sound_radius

func _on_disable_timer_timeout():
	_disable_collisions()
