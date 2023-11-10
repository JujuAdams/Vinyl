// Feather disable all

function __VinylEditorUpdate()
{
    static _editor = __VinylGlobalData().__editor;
    
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
    
    __VinylGlobalSettingsSaveNow();
    __VinylDocument().__SaveNow();
}