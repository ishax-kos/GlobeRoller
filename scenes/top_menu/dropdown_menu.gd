extends Button


@onready var sub_menu :PopupPanel= $PopupPanel

func _ready() -> void:
    action_mode = BaseButton.ACTION_MODE_BUTTON_PRESS
    for child in $PopupPanel/VBoxContainer.get_children():
        child.pressed.connect(sub_menu.hide)

func _pressed() -> void:
    var global_rect := get_global_rect()
    if sub_menu.visible:
        sub_menu.hide()
        return
    sub_menu.popup(Rect2(
        global_rect.position.x, global_rect.end.y, 0.0, 0.0
    ))
    
