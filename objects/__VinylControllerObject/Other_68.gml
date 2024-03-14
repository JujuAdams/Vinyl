if (async_load[? "id"] != __socket) return;
switch(async_load[? "type"])
{
    case network_type_non_blocking_connect:
        if (__otherSocket != undefined)
        {
            __VinylTrace("Received another connection but we already have a link");
            return;
        }
        
        __VinylTrace("Established connection to editor");
        __otherSocket = async_load[? "socket"];
    break;
    
    case network_type_data:
        __VinylTrace(json_encode(async_load));
    break;
}