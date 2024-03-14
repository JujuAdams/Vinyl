// Feather disable all

function __VedClassProject() constructor
{
    __projectPath = undefined;
    
    
    
    static __Update = function()
    {
        
    }
    
    static __Load = function(_projectPath)
    {
        __VedTrace("Loading \"", _projectPath, "\"");
        __projectPath = _projectPath;
        
        __VedModalOpen(__VedClassModalLoadSuccess).__path = __projectPath;
        __VedModalOpen(__VedClassModalLoadFailed).__path = __projectPath;
    }
    
    static __Unload = function()
    {
        __VedTrace("Unloading \"", __projectPath, "\"");
    }
}