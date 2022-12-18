function __VinylValidateMacros()
{
    if not (is_numeric(VINYL_LIVE_UPDATE_PERIOD))
    {
        __VinylError("VINYL_LIVE_UPDATE_PERIOD must be a number");
    }
    
    if not (is_numeric(VINYL_STEP_DURATION) && (VINYL_STEP_DURATION >= 0))
    {
        __VinylError("VINYL_STEP_DURATION must be a number greater than or equal to zero");
    }
    
    if not (is_numeric(VINYL_DEFAULT_GAIN_RATE) && (VINYL_DEFAULT_GAIN_RATE > 0))
    {
        __VinylError("VINYL_DEFAULT_GAIN_RATE must be a number greater than zero");
    }
    
    if not (is_numeric(VINYL_DEFAULT_PITCH_RATE) && (VINYL_DEFAULT_PITCH_RATE > 0))
    {
        __VinylError("VINYL_DEFAULT_PITCH_RATE must be a number greater than zero");
    }
    
    if not (is_bool(VINYL_DEBUG))
    {
        __VinylError("VINYL_DEBUG must be a boolean (<true> or <false>)");
    }
    
    if not (is_numeric(VINYL_SYSTEM_HEADROOM) && (VINYL_SYSTEM_HEADROOM >= 0) && (VINYL_SYSTEM_HEADROOM <= 30))
    {
        __VinylError("VINYL_SYSTEM_HEADROOM must be a number greater than or equal to zero, and less than or equal to 30");
    }
    
    if not (is_numeric(VINYL_SILENCE) && (VINYL_SILENCE >= -60) && (VINYL_SILENCE < 0))
    {
        __VinylError("VINYL_SILENCE must be a number greater than or equal to -60, and less than 0");
    }
    
    if not (is_numeric(VINYL_YAML_TAB_SIZE) && (VINYL_YAML_TAB_SIZE == floor(VINYL_YAML_TAB_SIZE)) && (VINYL_YAML_TAB_SIZE > 0))
    {
        
        __VinylError("VINYL_YAML_TAB_SIZE must be an integer greater than zero");
    }
}