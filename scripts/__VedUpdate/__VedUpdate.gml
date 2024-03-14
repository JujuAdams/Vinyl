// Feather disable all

function __VedUpdate()
{
    static _system = __VedSystem();
    
    static _inFocus = window_has_focus();
    if (_inFocus != window_has_focus())
    {
        _inFocus = window_has_focus();
        if (_inFocus)
        {
            __VedTrace("Back in focus");
        }
    }
    
    if (VedIsShowing())
    {
        ImGui.__Update();
        
        with(_system)
        {
            var _i = 0;
            repeat(array_length(__windowsArray))
            {
                __windowsArray[_i].__Build();
                ++_i;
            }
        }
    }
}