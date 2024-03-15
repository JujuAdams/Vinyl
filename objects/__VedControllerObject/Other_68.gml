switch(async_load[? "type"])
{
    case network_type_connect:
        if (async_load[? "id"] == __socket)
        {
            if (__connectionEstablished)
            {
                __VedWarning("Received connection to game but we already have a link");
                return;
            }
            
            __connectionEstablished = true;
            __otherSocket = async_load[? "socket"];
            __VedLog("Established connection to game, other socket = ", __otherSocket);
        }
    break;
    
    case network_type_data:
        if (async_load[? "id"] == __otherSocket)
        {
            __VedNetReceiveBuffer(async_load[? "buffer"], 0, async_load[? "size"]);
        }
    break;
}