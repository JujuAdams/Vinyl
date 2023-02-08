/// @param emitter

function VinylEmitterExists(_emitter)
{
    return (is_struct(_emitter) && (instanceof(_emitter) == "__VinylClassEmitterRef"));
}