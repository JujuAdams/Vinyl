/// @param value

function VinylIsPattern(_value)
{
    var _instanceof = instanceof(_value);
    if ((_instanceof == "__VinylPatternBasic" )
    ||  (_instanceof == "__VinylPatternLoop"  )
    ||  (_instanceof == "__VinylPatternRandom")
    ||  (_instanceof == "__VinylPatternQueue" )
    ||  (_instanceof == "__VinylPatternMulti" ))
    {
        return true;
    }
    else
    {
        return false;
    }
}