/// @param pan

function __VinylClassPan(_pan) constructor
{
    static _globalData = __VinylGlobalData();
    static _panArray   = _globalData.__panArray;
    array_push(_panArray, self);
    
    __pan = _pan;
    
    audio_falloff_set_model(audio_falloff_none);
    __emitter = audio_emitter_create();
    audio_emitter_position(__emitter, global.__vinylListener.x + _pan, global.__vinylListener.y, 0);
    audio_emitter_falloff(__emitter, 1, 1, 1);
    audio_falloff_set_model(audio_falloff_exponent_distance);
    
    static __UpdatePosition = function()
    {
        audio_emitter_position(__emitter, global.__vinylListener.x + __pan, global.__vinylListener.y, 0);
    }
    
    static __Pan = function(_pan)
    {
        if (_pan != __pan)
        {
            __pan = _pan;
            __UpdatePosition();
        }
    }
}