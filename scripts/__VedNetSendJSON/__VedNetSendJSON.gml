// Feather disable all

/// @param json

function __VedNetSendJSON(_json)
{
    static _sendBuffer = __VedSystem().__sendBuffer;
    
    buffer_seek(_sendBuffer, buffer_seek_start, 0);
    buffer_write(_sendBuffer, buffer_string, "json");
    buffer_write(_sendBuffer, buffer_string, json_stringify(_json));
    network_send_packet(__VedControllerObject.__otherSocket, _sendBuffer, buffer_tell(_sendBuffer));
}