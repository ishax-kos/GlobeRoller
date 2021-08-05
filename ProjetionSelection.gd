extends OptionButton


func _ready():
    var descriptiveText = $Description.text.split("\n#\n")
    for i in descriptiveText.size():
        get_popup().set_item_tooltip(i, descriptiveText[i])
    $Description.queue_free(); 
    #call_deferred("remove_child", $Description)
