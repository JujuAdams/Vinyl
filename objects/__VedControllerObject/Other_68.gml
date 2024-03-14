if (async_load[? "id"] != __socket) return;
switch(async_load[? "type"])
{
    case network_type_connect:
        if (__otherSocket != undefined)
        {
            __VedTrace("Received another connection but we already have a link");
            return;
        }
        
        __VedTrace("Established connection to runtime");
        __otherSocket = async_load[? "socket"];
    break;
    
    case network_type_data:
        __VedTrace(json_encode(async_load));
    break;
}