extends VBoxContainer



@export var entry_scene :PackedScene
#= preload("res://scenes/continent_list_entry.tscn")
@onready var base :Node= get_tree().current_scene

func _ready() -> void:
    assert(entry_scene)

func add_entry_continent(cont: Continent) -> void:
    var entry := entry_scene.instantiate()
    entry.continent = cont
    add_child(entry)
    entry.moved_entry.connect(_moved_entry)
    entry.change_entry_visibility.connect(_change_entry_visibility)
    entry.entry_selected.connect(_entry_selected)
    
func _moved_entry(from: int, to: int) -> void:
    base.rearrange_continent(from, to)
    move_child(get_child(from), to)

func _change_entry_visibility(entry: int, state: bool) -> void:
    base.continent_change_visibility.emit(entry, state)
    
func _entry_selected(cont: Continent, entry: int) -> void:
    base._continent_selected(entry)

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
    return data is int

func _drop_data(at_position: Vector2, data: Variant) -> void:
    get_child(get_child_count()-1)._drop_data(at_position,data)


func _on_continent_added(index: int) -> void:
    add_entry_continent(base.continents[index])


func _on_base_continent_removed(index: int) -> void:
    remove_child(get_child(index))


func _on_base_continents_reload() -> void:
    pass # Replace with function body.


func _on_base_continent_changed(index: int) -> void:
    get_child(index).data_update()
