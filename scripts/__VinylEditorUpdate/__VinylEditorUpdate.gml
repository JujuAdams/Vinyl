// Feather disable all

function __VinylEditorUpdate()
{
    static _editor = __VinylGlobalData().__editor;
    
    if (VinylEditorIsShowing())
    {
        ImGui.__Update();
        
        struct_foreach(_editor.__windowDict, function(_name, _childStruct)
        {
            if (_childStruct.__open)
            {
                _childStruct.__function();
            }
        });
    }
    
    __VinylGlobalSettingsSaveNow();
    __VinylDocument().__SaveNow();
}