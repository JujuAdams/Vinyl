/// @param name

function VinylStackMaxVoiceGet(_name, _priority)
{
    return VinylStackGet(_name, VinylStackMaxPriorityGet(_name));
}