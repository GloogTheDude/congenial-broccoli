class_name InteractableComponent
extends Area2D
@export var interactable_data:InteractableData

signal enter_hovered
signal exit_hovered
signal selected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
