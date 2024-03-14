// Feather disable all

function __VedUpdate()
{
    static _system = __VedSystem();
    
    if (not instance_exists(__VedControllerObject))
    {
        instance_create_depth(0, 0, 0, __VedControllerObject);
    }
    
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
            if (__project != undefined) __project.__Update();
            
            var _i = 0;
            repeat(array_length(__windowsArray))
            {
                __windowsArray[_i].__Update();
                ++_i;
            }
            
            var _i = 0;
            repeat(array_length(__modalsArray))
            {
                __modalsArray[_i].__Update();
                ++_i;
            }
        }
    }
}