extends Node

var source_image := ImageTexture.new()

var scaleMod := 0.0
var pan := Vector2(0,0)
var filterFlag := 1;
var image = Image.new()
export var defaultImage : Resource


func _ready():
    image.create(256, 128, false, Image.FORMAT_RGBAF)
    $MapView2/OptionButton.selected = 1
    
    var args = OS.get_cmdline_args()
    var file := File.new()
    if len(args) > 0:
        load_image_path(args[0])
    else:
        load_image_path(defaultImage.resource_path)
        defaultImage = null
    $ConfirmationDialog.set_save_size($MapView1/ScrollContainer/TextureRect.texture.get_size())
    get_tree().connect("files_dropped", self, "load_image_dragdrop")
    $MapView1/OptionButton.connect("item_selected", self, "_on_OptionButton1_item_selected")
    $MapView2/OptionButton.connect("item_selected", self, "_on_OptionButton2_item_selected")
    



func load_image_dragdrop(files_dropped : PoolStringArray, screen : int):
    print("go")
    for a in files_dropped: print(a)
    load_image_path(files_dropped[0])
    


func load_image_path(path : String):
    image.load(path)
    reload_image()
    $ConfirmationDialog.set_save_size(image.get_size())



#func load_image(newImage : Image):
#    image.copy_from(newImage)
#    reload_image()
#    $ConfirmationDialog.set_save_size(image.get_size())



func reload_image():
    if (image.get_width() <= image.get_height()):
        if (image.get_width() < image.get_height()):
            image.resize( image.get_height(), image.get_height() )
        $MapView1/OptionButton.selected = MapRect.Proj.POLAR
        image.crop( image.get_height() * 2.0,  image.get_height() )
        
    else:
        if (image.get_width() == 2.0 * image.get_height()):
            pass
        else:
            image.resize( image.get_height() * 2.0, image.get_height() )
    
    print(source_image.create_from_image(image, Texture.FLAG_FILTER if filterFlag else 0 ))
    $MapView1/ScrollContainer/TextureRect.texture = source_image
    $MapView2/ScrollContainer/TextureRect.texture = source_image
    
    update_projections()



func update_projections():
    $MapView2/ScrollContainer/TextureRect.set_projection_mode(
        $MapView1/OptionButton.selected, 
        $MapView2/OptionButton.selected
    )



func _on_OptionButton1_item_selected(index):
    update_projections()
func _on_OptionButton2_item_selected(index):
    update_projections()



func _input(event):
    if event.is_action_pressed("context_menu"):
        $RightClickMenu.visible = true
        $RightClickMenu.rect_position = event.position
        


func _on_CheckBox_toggled(button_pressed : bool):
    filterFlag = button_pressed
    reload_image()
