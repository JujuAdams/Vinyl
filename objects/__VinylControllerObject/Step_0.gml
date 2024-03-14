if ((not __connectionStarted) && (current_time - __createTime > 500))
{
    __connectionStarted = true;
    network_connect_async(__socket, "127.0.0.1", __VINYL_NETWORKING_PORT);
}