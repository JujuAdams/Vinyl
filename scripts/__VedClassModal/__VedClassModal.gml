// Feather disable all

function __VedClassModal() constructor
{
    static _system = __VedSystem();
    
    __firstRun = true;
    __closed = false;
    
    static __Update = function()
    {
        if (__firstRun)
        {
            __firstRun = false;
            __FirstTime();
        }
        
        __BuildUI();
    }
    
    static __FirstTime = function()
    {
        
    }
    
    static __BuildUI = function()
    {
        
    }
    
    static __Close = function()
    {
        __closed = true;
        ImGui.CloseCurrentPopup();
    }
}