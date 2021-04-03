/// @param value

function VinylIsSoundInstance(_value)
{
    var _instanceof = instanceof(_value);
    if ((_instanceof == "__VinyPlayerBasic" )
    ||  (_instanceof == "__VinyPlayerLoop"  )
    ||  (_instanceof == "__VinyPlayerRandom")
    ||  (_instanceof == "__VinyPlayerQueue" )
    ||  (_instanceof == "__VinyPlayerMulti" ))
    {
        return true;
    }
    else
    {
        return false;
    }
}