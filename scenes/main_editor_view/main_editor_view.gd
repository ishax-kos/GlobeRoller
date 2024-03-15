extends Node

@export var default_continents :Array[Continent]
var continents :Array[Continent]
# At runtime its probably wise to use the data in TextureViewport as the
# single source of truth. Or maybe I should keep it in here?
var selected := -1

var names :Array[String]

var document_path : String = ""


signal continents_reload()
signal continent_changed(index: int)
signal continent_added(index: int)
signal continent_order_changed(from: int, to: int)
signal continent_change_visibility(index: int, state: bool)
signal continent_selected(index: int)
signal continent_removed(index: int)


func _ready() -> void:
    add_default_continents()
    get_window().connect("files_dropped", _drop_files_request)
    get_window().connect("close_requested", _close_window_request)


func _input(event: InputEvent) -> void:
    if event.is_action_pressed("delete_continent"):
        try_delete_continent()


func _continent_selected(index: int) -> void:
    print("bink")
    selected = index
    continent_selected.emit(index)


func try_delete_continent() -> void:
    if selected == -1: return
    $Confirmation.confirmed.connect(
        delete_continent.bind(selected), CONNECT_ONE_SHOT)
    $Confirmation.popup_with_message(
        "Are you sure you would like to delete %s?" % 
        [continents[selected].name])


func delete_continent(index: int) -> void:
    var name_pos := names.find(continents[index].name)
    if name_pos != -1:
        names.remove_at(name_pos)
    continents.remove_at(index)
    continent_removed.emit(index)
    if index == selected: selected = -1
        
        
#func init_continent(continent :Continent) -> void:

    
func random_globe_position() -> Vector3:
    return Vector3(
        randf_range(-0.25, 0.25), randf_range(0, 1), randf_range(0, 1)
    )


func _drop_files_request(files: PackedStringArray) -> void:    
    if files.size() > 1:
        $Confirmation.confirmed\
            .connect(add_multiple_continents.bind(files), CONNECT_ONE_SHOT)
        return
        $Confirmation.popup_with_message(
            "Are you sure you would like to add more than one image?"
        )
    add_multiple_continents(files)
    
    
func add_multiple_continents(files: PackedStringArray) -> void:
    for file_path in files:
        var cont := Continent.from_image(file_path)
        if cont:
            add_continent(cont)


func make_unique(s : String) -> String:
    var n := 0
    var string_out := s
    while names.find(string_out) != -1:
        n += 1
        string_out = s + ".%03d" % n
    return string_out


func add_continent(cont: Continent) -> void:
    if cont.name == "":
        cont.name = "continent"
    cont.name = make_unique(cont.name)
    names.append(cont.name)
    continents.append(cont)
    
    continent_added.emit(continents.size() - 1)


func rearrange_continent(from: int, to: int) -> void:
    if from == to: return
    var moved := continents[from]
    continents.insert(to, moved)
    continents.remove_at(from + int(to < from))
    continent_order_changed.emit(from, to)


func deselect() -> void:
    _continent_selected(-1)


func save_doc_with_dialog() -> void:
    var dialog :FileDialog= $FileDialog
    if document_path == "":
        dialog.current_path = "new_map.globe"
    else: 
        dialog.current_path = document_path
    dialog.filters = [
        "*.globe ; Globe Roller document",
        "* ; none"
    ]
    
    dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
    dialog.file_selected.connect(_save_file_selected, CONNECT_ONE_SHOT)
    dialog.popup_centered()
    
    
    
func _save_file_selected(path: String) -> void:
    document_path = path
    save_doc(document_path)
        
    
func save_doc(path: String) -> void:
    assert(path)
    var file := FileAccess.open(path, FileAccess.WRITE)
    if !file: 
        print_debug(FileAccess.get_open_error())
        return
    var buffer := Save.save_v3_0_0(continents)
    print(buffer.size())
    file.store_buffer(buffer)
    file.close()
    

func _on_save_pressed() -> void:
    if document_path == "":
        save_doc_with_dialog()
    else:
        save_doc(document_path)


func _on_save_as_pressed() -> void:
    save_doc_with_dialog()


func _on_export_image_pressed() -> void:
    export_image_dialog()


func export_image_dialog() -> void:
    var dialog :FileDialog= $FileDialog
    dialog.current_path = document_path
    dialog.filters = [
        "*.png ; PNG Image"
    ]
    
    dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
    dialog.file_selected.connect(export_image, CONNECT_ONE_SHOT)
    dialog.popup_centered()
    
    
func export_image(path: String) -> void:
    deselect()
    #%TextureViewport.ready.connect(export_image_2.bind(path), CONNECT_ONE_SHOT)
    %TextureViewport.update_image()
    print(path)
    RenderingServer.frame_post_draw.connect(
        export_image_2.bind(path), CONNECT_ONE_SHOT
    )

    #
    #
func export_image_2(path: String) -> void:
    var image :Image= %TextureViewport.get_texture().get_image()
    image.save_png(path)



func _on_delete_pressed() -> void:
    try_delete_continent()


func open_doc_with_dialog() -> void:
    var dialog :FileDialog= $FileDialog
    dialog.current_path = document_path
    dialog.filters = [
        "*.globe ; Globe Roller document"
    ]
    
    dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
    dialog.file_selected.connect(_open_file_selected, CONNECT_ONE_SHOT)
    dialog.popup_centered()
    
    
func _open_file_selected(path: String) -> void:
    document_path = path
    open_doc(document_path)
        
    
func open_doc(path: String) -> void:
    assert(path)
    var file := FileAccess.open(path, FileAccess.READ)
    if !file: 
        print_debug(FileAccess.get_open_error())
        return
    print(file.get_length())
    var buffer := file.get_buffer(file.get_length())
    var conts := Save.load_v3_0_0(buffer)
    names = []
    clear_project()
    for cont in conts:
        add_continent(cont)


func clear_project() -> void:
    document_path = ""
    var max_c := continents.size() - 1
    for c in continents.size():
        delete_continent(max_c - c)
    

func _on_open_pressed() -> void:
    open_doc_with_dialog()


func _on_speed_text_edit_text_changed(new_text: String) -> void:
    pass # Replace with function body.


func _on_new_pressed() -> void:
    $Confirmation.confirmed.connect(
        _new_document_confirmed, CONNECT_ONE_SHOT)
    $Confirmation.popup_with_message(
        "Any unsaved changes will be lost. "\
        +"Are you sure you would like to create a new document?")


func _new_document_confirmed() -> void:
    clear_project()
    add_default_continents()


func add_default_continents() -> void:
    for continent in default_continents:
        if !continent: continue
        add_continent(continent)


func _close_window_request() -> void:
    var message := "Any unsaved changes will be lost."
    if document_path == "":
        message = "The document has never been saved."
        
    $Confirmation.confirmed.connect(
        close_application, CONNECT_ONE_SHOT)
    $Confirmation.popup_with_message(message\
        +" Are you sure you would like to quit?")
    
func close_application() -> void:
    get_tree().quit()
