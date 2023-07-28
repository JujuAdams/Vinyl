// Feather disable all
/// @param text

function UITextInline(_text)
{
    _text = string(_text);
    draw_text(global.__uiX, global.__uiY, _text);
    global.__uiX += string_width(_text) + global.__uiPadding;
    global.__uiLineHeight = max(global.__uiLineHeight, string_height(_text) + 2*global.__uiPadding);
}
