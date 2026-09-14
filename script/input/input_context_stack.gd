class_name InputContextStack
extends RefCounted

var contexts: Array[InputContext.Type] = []


func set_context(context: InputContext.Type) -> void:
	contexts = [context]


func push_context(context: InputContext.Type) -> void:
	contexts.push_back(context)


func pop_context() -> void:
	if contexts.is_empty():
		return

	contexts.pop_back()


func clear_contexts() -> void:
	contexts.clear()


func get_context() -> InputContext.Type:
	return contexts.back()

func is_empty() -> bool:
	return contexts.is_empty()
