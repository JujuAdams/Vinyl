/// @param text

function UITextInline(_text)
{
    _text = string(_text);
    
    var _width  = string_width(_text);
    var _height = string_height(_text);
    
    if (global.__uiTextBackground)
    {
        var _oldColour = draw_get_colour();
        draw_set_colour(c_black);
        draw_set_alpha(0.6);
        
        draw_rectangle(global.__uiX, global.__uiY, global.__uiX + _width, global.__uiY + _height, false);
        
        draw_set_colour(_oldColour);
        draw_set_alpha(1);
    }
    
    draw_text(global.__uiX, global.__uiY, _text);
    global.__uiX += _width;
    global.__uiLineHeight = max(global.__uiLineHeight, _height + 2*global.__uiPadding);
}