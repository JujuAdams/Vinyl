function VinylEndStep()
{
    var _i = 0;
    repeat(array_length(global.__vinylGroupsArray))
    {
        with(global.__vinylGroupsArray[_i]) __Tick();
        ++_i;
    }
    
    var _i = 0;
    repeat(array_length(global.__vinylPlaying))
    {
        with(global.__vinylPlaying[_i])
        {
            __Tick();
            
            if (__finished)
            {
                if (VINYL_DEBUG) __VinylTrace("Deleted ", self);
                array_delete(global.__vinylPlaying, _i, 1);
            }
            else
            {
                ++_i;
            }
        }
    }
}