extends HBoxContainer
@export var current_value:int
@export var min_value:int
@export var max_value:int
var enabled:bool = true
signal Changed(value:int)




func Stepper_pressed(index:int):
	
	if index == 1 and current_value != max_value:
		current_value += index
		Changed.emit(current_value)
	elif index == -1 and current_value != min_value:
		current_value += index
		Changed.emit(current_value)
	elif index == 1:
		current_value = min_value
		Changed.emit(current_value)
	elif index == -1:
		current_value = max_value
		Changed.emit(current_value)
	
	pass

func Enable():
	enabled = true
	$Decrement.disabled = false
	$Increment.disabled = false
func Disable():
	enabled = false
	$Decrement.disabled = true
	$Increment.disabled = true
