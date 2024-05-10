function UINewline()
{
    global.__uiX = global.__uiStartX;
    global.__uiY += global.__uiLineHeight + 8;
    global.__uiLineHeight = global.__uiMinLineHeight;
}