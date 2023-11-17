// Feather disable all

function __VinylEditorUpdate()
{
    static _editor = __VinylGlobalData().__editor;
    
    static _inFocus = window_has_focus();
    if (_inFocus != window_has_focus())
    {
        _inFocus = window_has_focus();
        if (_inFocus)
        {
            __VinylDocument().__ProjectLoad();
            __VinylEditorSetStatusText("Reloaded \"", __VinylDocument().__projectPath, "\"");
        }
    }
    
    if (VinylEditorIsShowing())
    {
        ImGui.__Update();
        
        struct_foreach(_editor.__windowStates, function(_name, _stateStruct)
        {
            if (_stateStruct.__open)
            {
                _stateStruct.__function(_stateStruct);
            }
        });
    }
    
    //Reset the status bar after 5 seconds
    if (current_time > _editor.__statusTextLastSet + 500)
    {
        _editor.__statusText = undefined;
    }
    
    __VinylGlobalSettingsSaveNow();
    __VinylDocument().__SaveIfNecessary();
}