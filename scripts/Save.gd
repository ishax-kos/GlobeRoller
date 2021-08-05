extends ConfirmationDialog


#export var texNodePath : NodePath; onready var view := get_node(texNodePath)
#export var saveNodePath : NodePath; onready var save := get_node(saveNodePath)

onready var res_x := find_node("ResX")
onready var res_y := find_node("ResY")

#var dataImage := Image.new()


func _ready():
    res_x.text = String($SaveViewport.size.x)
    res_y.text = String($SaveViewport.size.y)


func set_save_size(size : Vector2):
    res_x.text = String(size.x)
    res_y.text = String(size.y)



func _on_ConfirmationDialog_confirmed():
    var size = Vector2(int(res_x.text), int(res_y.text))
    $SaveViewport.size = size
    var tex : TextureRect = $"../MapView2/ScrollContainer/TextureRect"
    $SaveViewport/TextureRect.material = tex.material
    $SaveViewport/TextureRect.texture = tex.texture
    $SaveViewport/TextureRect.rect_size = size

    update()
    yield(VisualServer, 'frame_post_draw')
    var dataImage : Image = $SaveViewport.get_texture().get_data()

    var saveNode : FileDialog = $"../SaveFileDialog"
    saveNode.visible = true
    print("completed")
    yield(saveNode, "confirmed")
    print("completed")
#    save.visible = false
    dataImage.save_png(saveNode.current_file)
    
