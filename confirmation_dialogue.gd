extends ConfirmationDialog

var paths :Array[String]


func _ready() -> void:
    exclusive = true


func popup_with_message(message: String) -> void:
    dialog_text = message
    popup_centered()


