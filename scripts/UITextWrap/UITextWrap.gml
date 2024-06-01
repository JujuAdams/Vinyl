/// @param text
/// @param screenWidth

function UITextWrap(_text, _screenWidth)
{
    _text = string(_text);
    var _width = _screenWidth - global.__uiX;
    draw_text_ext(global.__uiX, global.__uiY, _text, -1, _width);
    global.__uiX += string_width_ext(_text, -1, _width);
    global.__uiLineHeight = max(global.__uiLineHeight, string_height_ext(_text, -1, _width) + 2*global.__uiPadding);
    UINewline();
}