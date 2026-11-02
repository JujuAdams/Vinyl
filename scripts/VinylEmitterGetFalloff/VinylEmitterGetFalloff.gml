/// Returns a struct that contains the falloff properties for a Vinyl emitter (created by
/// `VinylEmitterCreate()`). This will contain three variables: `.refDist` `.maxDist` `factor`.
/// These variables correlate with the parameters that are provided to `VinylEmitterSetFalloff()`.
/// If the emitter provided to the function is invalid the three variables in the struct will be
/// set to `undefined`.
/// 
/// @param emitter

function VinylEmitterGetFalloff(_emitter)
{
    static _result = {};
    with(_result)
    {
        if (is_struct(_emitter) && is_instanceof(_emitter, __VinylClassEmitter))
        {
            refDist = _emitter.__refDist;
            maxDist = _emitter.__maxDist;
            factor  = _emitter.__factor;
        }
        else
        {
            refDist = undefined;
            maxDist = undefined;
            factor  = undefined;
        }
        
        return self;
    }
}