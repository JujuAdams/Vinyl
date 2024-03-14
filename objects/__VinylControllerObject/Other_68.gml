__VinylTrace(json_encode(async_load));
if (async_load[? "id"] != __socket) return;

switch(async_load[? "type"])
{
    case network_type_non_blocking_connect:
        __VinylTrace("Established connection to editor");
        
        if (__VINYL_RUNNING_FROM_IDE)
        {
            __VinylNetSendJSON({
                __type: "load project",
                __path: __VinylSystem().__projectPath,
            });
        }
    break;
    
    case network_type_data:
        __VinylNetReceiveBuffer(async_load[? "buffer"], 0, async_load[? "size"]);
    break;
}