/// @param [x=self.x]
/// @param [y=self.y]
/// @param [padding=3]
/// @param [minLineHeight]
/// @param [textBackground=false]

function UIStart(_x = x, _y = y, _padding = 3, _minLineHeight = string_height("\n"), _textBackground = false)
{
    global.__uiPadding = _padding;
    
    global.__uiStartX = _x + global.__uiPadding;
    global.__uiX = global.__uiStartX;
    global.__uiY = _y + global.__uiPadding;
    
    global.__uiMinLineHeight = _minLineHeight + 2*global.__uiPadding;
    global.__uiLineHeight = global.__uiMinLineHeight;
    global.__uiTextBackground = _textBackground;
}