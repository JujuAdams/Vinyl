/// @param text
/// @param callback
/// @param [data=undefined]

function UIButtonInline(_text, _callback, _data = undefined)
{
    var _l = global.__uiX;
    var _t = global.__uiY - global.__uiPadding;
    
    global.__uiX += global.__uiPadding;
    UITextInline(_text);
    
    var _r = global.__uiX;
    var _b = _t + global.__uiLineHeight;
    
    draw_rectangle(_l, _t, _r, _b, true);
    
    if (is_method(_callback) && mouse_check_button_released(mb_left))
    {
        if (point_in_rectangle(mouse_x, mouse_y, _l, _t, _r, _b))
        {
            _callback(_data);
        }
    }
    
    global.__uiX += global.__uiPadding;
}