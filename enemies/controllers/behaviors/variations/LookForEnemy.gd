extends EnemyBehavior

#
# signals
#

signal lost_target
signal found_target

#
# exports
#

@export var turn_speed: float
@export var range: float
@export var body: CharacterBody2D
@export var laser_pointer_start: Node2D

@export_group('Sound')
@export var sound_track_turn_speed: float
@export var sound_track_duration: float

#
# nodes
#

@onready var laser_line_node: Line2D = %LaserLine
@onready var raycast_node: RayCast2D = %RayCast
@onready var end_sound_track_timer_node: Timer = %EndSoundTrackTimer

#
# private vars
#

var _found: bool = false

var _sound_distracted: bool = false
var _sound_loc: Vector2

#
# methods
#

func _ready():
	end_sound_track_timer_node.wait_time = sound_track_duration

func eb_start():
	super.eb_start()
	_sound_distracted = false
	_found = false
	
func eb_stop():
	super.eb_stop()
	
func eb_process(delta: float):
	super.eb_process(delta)
	
	if not end_sound_track_timer_node.is_stopped():
		return
	
	if _sound_distracted:
		var prev = body.rotation
		var dir = (_sound_loc - body.global_position)
		var a = body.transform.x.angle_to(dir)
		body.rotate(sign(a) * min(delta * sound_track_turn_speed, abs(a)))
#
		if prev - body.rotation == 0:
			end_sound_track_timer_node.start()
		return
	
	var r = turn_speed * delta
	body.rotate(r)

func _process(_delta: float):
	var p1 = laser_pointer_start.global_position
	var p2 = laser_pointer_start.global_position + Vector2(range, 0).rotated(body.rotation)
	raycast_node.position = p1
	raycast_node.target_position = Vector2(range, 0).rotated(body.rotation)
	laser_line_node.set_point_position(0, p1)
	laser_line_node.set_point_position(1, p2)
	if raycast_node.is_colliding():
		laser_line_node.set_point_position(1, raycast_node.get_collision_point())
		var b = raycast_node.get_collider() as Node
		if b == null:
			return
		var is_player = b.is_in_group('player')
		if is_player and not _found:
			controller.data['enemy'] = b
			found_target.emit()
			_found = true
		if _found and not is_player:
			lost_target.emit()
			_found = false
			return

#
# signal connections
#

func _on_sound_listener_heard_sound(area: Area2D):
	if not end_sound_track_timer_node.is_stopped():
		end_sound_track_timer_node.stop()
		
	_sound_distracted = true
	_sound_loc = area.global_position


func _on_end_sound_track_timer_timeout():
	_sound_distracted = false
