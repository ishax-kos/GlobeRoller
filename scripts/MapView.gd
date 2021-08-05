extends Control


#func _gui_input(event):
##    print("event")
#    if event is InputEventMouseButton:
#        match event.button_index:
#            BUTTON_WHEEL_UP:
##                if Input.is_key_pressed(KEY_CONTROL):
#                    scale_by(0.125, event.global_position)
#            BUTTON_WHEEL_DOWN:
##                if Input.is_key_pressed(KEY_CONTROL):
#                    scale_by(-0.125, event.global_position)



func scale_by(val : float, mouse_pos : Vector2):
    var oldscale = pow(2, Main.scaleMod)
#    print(val, " : ", pos)
    Main.scaleMod += val
    var newscale = pow(2, Main.scaleMod)
#    $ScrollContainer/TextureRect.rect_position += mouse_pos / oldscale
    $ScrollContainer/TextureRect.rect_scale = Vector2.ONE * newscale
    
#    $ScrollContainer/TextureRect.rect_position -= mouse_pos * newscale
    
    var offset = mouse_pos - $ScrollContainer/TextureRect.rect_position
#    $ScrollContainer/TextureRect.rect_position -= (offset * newscale) - offset

    
func pan_by(val : Vector2):
    Main.pan += val
    $ScrollContainer/TextureRect.rect_position = Vector2.ONE * Main.scaleMod 
    pass

