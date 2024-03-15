// Feather disable all

function __VedClassModal() constructor
{
    static _system = __VedSystem();
    
    __handle = "";
    
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
        ImGui.OpenPopup(__handle);
        ImGui.SetNextWindowPos(window_get_width()/2, window_get_height ()/2, ImGuiCond.Appearing, 0.5, 0.5);
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