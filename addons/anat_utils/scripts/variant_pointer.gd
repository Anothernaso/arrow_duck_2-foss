## An immutable wrapper around `Variant`, allowing it to be shared by reference.
class_name AUtils_VariantPointer
extends RefCounted

var _value: Variant
var value: Variant:
	get():
		return _value
		
	

func _init(value_p: Variant) -> void:
	
	_value = value_p
	
