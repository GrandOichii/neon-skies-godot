extends Label
class_name CreditsModLabel

#
# exports
#

@export var duration: float
@export var gain_color: Color
@export var lose_color: Color

#
# methods
#

func begin(amount: int):
	var c = gain_color
	var s = '+' + str(amount)
	if amount < 0:
		c = lose_color
		s = '-' + str(amount)
	text = s
	modulate = Color(c, 1)
	create_tween().tween_property(self, 'modulate', Color(c, 0), duration).finished.connect(_dissapear)
	
func _dissapear():
	queue_free()
