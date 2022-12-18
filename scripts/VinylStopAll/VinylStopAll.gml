/// Immediately stops all playback instances

function VinylStopAll()
{
    var _i = 0;
    repeat(array_length(global.__vinylPlaying))
    {
        global.__vinylPlaying[_i].__Stop();
        ++_i;
    }
}