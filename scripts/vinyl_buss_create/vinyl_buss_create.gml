/// @param bussName

function vinyl_buss_create(_name)
{
    switch(_name)
    {
        case "master":
        case "gain":
        case "gain_target":
        case "gain_rate":
        case "pitch":
        case "pitch_target":
        case "pitch_rate":
            __vinyl_error("Buss name \"", _name, "\" not permitted");
        break;
    }
    
    with(new __vinyl_class_buss())
    {
        if (!variable_struct_exists(global.__vinyl_busses, _name))
        {
            variable_struct_set(global.__vinyl_busses, _name, self);
            
            if (typeof(other) == "__vinyl_class_buss")
            {
                variable_struct_set(other, _name, self);
            }
            else
            {
                variable_struct_set(vinyl_master, _name, self);
            }
        }
        else
        {
            __vinyl_error("Buss \"", _name, "\" already exists\nBuss names must be globally unique");
        }
        
        return self;
    }
}

function __vinyl_class_buss() constructor
{
    gain         = 1.0;
    gain_target  = 1.0;
    gain_rate    = 0.1;
    
    pitch        = 1.0;
    pitch_target = 1.0;
    pitch_rate   = 0.1;
    
    __gain  = 1.0;
    __pitch = 1.0;
}