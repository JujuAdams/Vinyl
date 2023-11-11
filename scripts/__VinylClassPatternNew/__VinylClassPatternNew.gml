function __VinylClassPatternNew() constructor
{
    type          = "Basic";
    assets        = [];
    assetsWithTag = [];
    
    gainOption       = "Inherit";
    gainKnob         = __VINYL_ASSET_NULL;
    gainKnobOverride = false;
    gain             = [1, 1];
    
    pitchOption   = "Inherit";
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