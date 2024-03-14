__socket = network_create_socket(network_socket_tcp);

__connectionStarted = false;
__createTime = current_time;
__connectionEstablished = false;

__VinylTrace("Created socket ", __socket);