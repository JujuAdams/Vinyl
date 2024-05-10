/// @param text
/// @param callback
/// @param [data=undefined]

function UIButtonInline(_text, _callback, _data = undefined)
{
    var _l = global.__uiX - global.__uiPadding;
    var _t = global.__uiY - global.__uiPadding;
    
    global.__uiX += global.__uiPadding;
    UITextInline(_text);
    global.__uiX += global.__uiPadding;
    
    var _r = global.__uiX + global.__uiPadding;
    var _b = _t + global.__uiLineHeight;
    
    var _inside = point_in_rectangle(mouse_x, mouse_y, _l, _t, _r, _b);
    draw_rectangle(_l, _t, _r, _b, not (_inside && mouse_check_button(mb_left)));
    
    if (_inside && is_method(_callback) && mouse_check_button_released(mb_left))
    {
        _callback(_data);
    }
}