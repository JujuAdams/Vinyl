function VinylSystemEndStep()
{
    var _i = 0;
    repeat(ds_list_size(global.__vinylGroupsList))
    {
        with(global.__vinylGroupsList[| _i]) __Tick();
        ++_i;
    }
    
    var _i = 0;
    repeat(ds_list_size(global.__vinylPlaying))
    {
        with(global.__vinylPlaying[| _i])
        {
            __Tick();
            
            if (__finished)
            {
                if (VINYL_DEBUG) __VinylTrace("Deleted ", self);
                ds_list_delete(global.__vinylPlaying, _i);
            }
            else
            {
                ++_i;
            }
        }
    }
}