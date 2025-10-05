class_name InteractableData
extends Resource

const uuid_util = preload("res://addons/uuid/uuid.gd")

@export var interactable_name:String
@export var type:DataType.type_interactable #enum
@export var interraction_radius:float
@export var interaction_point: Vector2
@export var _is_permanent: bool = false : set = set_is_permanent, get = get_is_permanent


var id:String = ""

func gen_permanent_id():
	if id=="":
		id = uuid_util.v4()
		
func set_is_permanent(value: bool) -> void:
	_is_permanent = value
	if value and id == "":
		gen_permanent_id()
	else: id =""

func get_is_permanent() -> bool:
	return _is_permanent
