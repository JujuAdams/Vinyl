__VedTrace(json_encode(async_load));
switch(async_load[? "type"])
{
    case network_type_connect:
        if (async_load[? "id"] == __socket)
        {
            if (__otherSocket != undefined)
            {
                __VedTrace("Received another connection but we already have a link");
                return;
            }
            
            __otherSocket = async_load[? "socket"];
            __VedTrace("Established connection to runtime, other socket = ", __otherSocket);
        }
    break;
    
    case network_type_data:
        if (async_load[? "id"] == __otherSocket)
        {
            __VedNetReceiveBuffer(async_load[? "buffer"], 0, async_load[? "size"]);
        }
    break;
}