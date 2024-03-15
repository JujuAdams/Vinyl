if (async_load[? "id"] != __socket) return;

switch(async_load[? "type"])
{
    case network_type_non_blocking_connect:
        if (__connectionEstablished)
        {
            __VedWarning("Received connection to editor but we already have a link");
            return;
        }
        
        __VinylTrace("Established connection to editor");
        
        if (__VINYL_RUNNING_FROM_IDE)
        {
            if (VINYL_VERSIONED_IDENT == undefined)
            {
                __VinylNetSendJSON({
                    __type: "create project",
                    __yyPath: GM_project_filename,
                });
            }
            else
            {
                __VinylNetSendJSON({
                    __type: "load project",
                    __yyPath: GM_project_filename,
                });
            }
        }
        else
        {
            if (VINYL_VERSIONED_IDENT == undefined)
            {
                __VinylNetSendJSON({
                    __type: "no ident found",
                });
            }
            else
            {
                __VinylNetSendJSON({
                    __type: "identify project",
                    __ident: VINYL_VERSIONED_IDENT,
                });
            }
        }
    break;
    
    case network_type_data:
        __VinylNetReceiveBuffer(async_load[? "buffer"], 0, async_load[? "size"]);
    break;
}