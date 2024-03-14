// Feather disable all

/// @param json

function __VinylNetSendJSON(_json)
{
    static _sendBuffer = __VinylSystem().__sendBuffer;
    if (not VINYL_LIVE_EDIT) return;
    
    buffer_seek(_sendBuffer, buffer_seek_start, 0);
    buffer_write(_sendBuffer, buffer_string, "json");
    buffer_write(_sendBuffer, buffer_string, json_stringify(_json));
    network_send_packet(__VinylControllerObject.__socket, _sendBuffer, buffer_tell(_sendBuffer));
}