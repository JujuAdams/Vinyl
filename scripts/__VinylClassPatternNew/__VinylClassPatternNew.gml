function __VinylClassPatternNew() constructor
{
    type          = "Basic";
    assets        = [];
    assetsWithTag = [];
    gain          = 1;
    pitch         = 1;
    transpose     = 0;
    loop          = false;
    stack         = "";
    stackPriority = 0;
    effectChain   = "";
    label         = [];
    persistent    = false;
    
    queueBehavior = "Play Once"; //Play Once, Replay Whole Queue, Replay Last Asset
    
    multiSync           = VINYL_DEFAULT_MULTI_SYNC;
    multiBlend          = 0;
    multiBlendCurveName = "";
}