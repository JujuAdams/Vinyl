/// @param emitter

function VinylEmitterExists(_emitter)
{
    return (is_struct(_emitter) && is_instanceof(_emitter, __VinylClassEmitterRef));
}