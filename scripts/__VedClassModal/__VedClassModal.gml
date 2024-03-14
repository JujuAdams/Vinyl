// Feather disable all

function __VedClassModal() constructor
{
    static _system = __VedSystem();
    
    __firstRun = true;
    
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
}