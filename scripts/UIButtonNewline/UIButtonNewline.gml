/// @param text
/// @param callback
/// @param [data=undefined]

function UIButtonNewline(_text, _callback, _data = undefined)
{
    UIButton(_text, _callback, _data);
    UINewline();
}