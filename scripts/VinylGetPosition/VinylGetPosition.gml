// Feather disable all

/// @param voice

function VinylGetPosition(_voice)
{
    static _result = {
        x: 0,
        y: 0,
        z: 0,
    };
    
    with(_result)
    {
        var _emitter = VinylGetEmitter(_voice);
        if (_emitter == undefined)
        {
            x = 0;
            y = 0;
            z = 0;
        }
        else
        {
            x = audio_emitter_get_x(_emitter);
            y = audio_emitter_get_y(_emitter);
            z = audio_emitter_get_z(_emitter);
        }
    }
    
    return _result;
}