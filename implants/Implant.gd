extends Resource
class_name  Implant

enum Slot { Head, Torso, Arms, Legs }

#
# exports
#

@export var name: String
@export_multiline var desciption: String
@export var slot: Slot
@export var ablities: Array[PackedScene]
