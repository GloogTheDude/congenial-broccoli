class_name Player
extends CharacterBody2D


var direction : Vector2
var orientation: DataType.orientation = DataType.orientation.S
var destination: Vector2 = global_position
const DEADZONE:float = 5
var target:InteractableComponent = null

func _ready() -> void:
	MyEventBus.clicked_on_ground.connect(on_clicked_on_ground)
	MyEventBus.clicked_on_interactable.connect(on_clicked_on_interactable)
	MyEventBus.lmb_released.connect(on_lmb_button_released)
	
	
func _process(delta: float) -> void:
	if target:
		if destination.distance_squared_to(target.global_position) > 9:
			destination = target.global_position

func define_player_orientation()->void:
	#calcule de la direction non normaliser.
	direction = destination - global_position
	
	if direction.length()<=DEADZONE:
		return
	
	#snap en -1/0/1 par composante du vecteur
	var x:int = 0
	var y:int = 0
	if absf(direction.x) > DEADZONE:
		x = 1 if direction.x > 0.0 else -1
	if absf(direction.y) > DEADZONE:
		y = 1 if direction.y > 0.0 else -1
	var d := Vector2(x, y)
	direction = direction.normalized()
	#print("this is direction: ", direction)
	
	# map Vector2 -> code orientation
	
	match d:
		Vector2( 1,  0): orientation =  DataType.orientation.E
		Vector2( 1, -1): orientation = DataType.orientation.NE
		Vector2( 0, -1): orientation = DataType.orientation.N
		Vector2(-1, -1): orientation = DataType.orientation.NW
		Vector2(-1,  0): orientation = DataType.orientation.W
		Vector2(-1,  1): orientation = DataType.orientation.SW
		Vector2( 0,  1): orientation = DataType.orientation.S
		Vector2( 1,  1): orientation = DataType.orientation.SE
	return

func has_reached_destination()->bool:
	if global_position.distance_squared_to(destination) <= DEADZONE*DEADZONE:
		return true
	else:
		return false

func get_orientation()->String:
	return DataType.orientation.find_key(orientation)

func on_clicked_on_ground(a_destination:Vector2)->void:
	destination = a_destination
	print("destination received")
	target = null
	
func on_clicked_on_interactable(a_target: Object)->void:
	target = a_target
	destination = target.global_position
	print("target_aquiered")
	
func on_lmb_button_released()->void:
	destination = global_position
	target = null
	
