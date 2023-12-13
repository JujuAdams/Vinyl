// Feather disable all

/// @param [name]

function __VinylClassSnapshot(_name = __VinylGenerateUUID()) constructor
{
    currentTime = current_time;
    time        = date_datetime_string(date_current_datetime());
    name        = _name;
    
    __settingsDict    = {};
    __patternArray    = [];
    __emitterArray    = [];
    __panEmitterArray = [];
    __knobArray       = [];
    
    static toString = function()
    {
        return "<snapshot " + string(name) + ">";
    }
}