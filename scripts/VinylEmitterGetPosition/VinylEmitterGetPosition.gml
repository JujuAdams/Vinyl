/// Returns a struct that contains the position for a Vinyl emitter (created by
/// `VinylEmitterCreate()`). The struct will contain three variables: `.x` `.y` `.z`. If the
/// emitter provided to the function is invalid the three variables in the struct will be set
/// to `undefined`.
/// 
/// @param emitter

function VinylEmitterGetPosition(_emitter)
{
    static _result = {};
    with(_result)
    {
        if (is_struct(_emitter) && is_instanceof(_emitter, __VinylClassEmitter))
        {
            x = _emitter.x;
            y = _emitter.y;
            z = _emitter.z;
        }
        else
        {
            x = undefined;
            y = undefined;
            z = undefined;
        }
        
        return self;
    }
}