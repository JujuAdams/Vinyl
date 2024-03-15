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
                var _window = __windowsArray[_i];
                _window.__Update();
                
                if (_window.__closed)
                {
                    array_delete(__windowsArray, _i, 1);
                }
                else
                {
                    ++_i;
                }
            }
            
            var _i = 0;
            repeat(array_length(__modalsArray))
            {
                var _modal = __modalsArray[_i];
                _modal.__Update();
                
                if (_modal.__closed)
                {
                    array_delete(__modalsArray, _i, 1);
                }
                else
                {
                    ++_i;
                }
            }
        }
    }
}