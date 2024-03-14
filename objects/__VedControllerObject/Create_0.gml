__socket = network_create_server(network_socket_tcp, __VED_NETWORKING_PORT, 1);
__otherSocket = undefined;

__connectionEstablished = false;

__VedTrace("Created socket ", __socket);