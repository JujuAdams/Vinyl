function __VinylClassSoundNew() constructor
{
    gainOption       = "Unset";
    gainKnob         = __VINYL_ASSET_NULL;
    gainKnobOverride = false;
    gain             = [1, 1];
    
    pitchOption       = "Unset";
    pitchKnob         = __VINYL_ASSET_NULL;
    pitchKnobOverride = false;
    pitch             = [1, 1];
    
    loopOption = "Unset";
    loop       = false;
    
    loopPointsOption = "Unset";
    loopPoints       = [0, 0];
    
    transposeOption       = "Unset";
    transposeKnob         = __VINYL_ASSET_NULL;
    transposeKnobOverride = false;
    transpose             = [0, 0];
    
    bpmOption = "Unset";
    bpm       = 120;
    
    stackOption   = "Unset";
    stack         = __VINYL_ASSET_NULL;
    stackPriority = 0;
    
    effectChainOption = "Unset";
    effectChain       = __VINYL_ASSET_NULL;
    
    labelsOption = "Unset";
    labels       = [];
    
    persistentOption = "Unset";
    persistent       = false;
    
    queueBehavior = "Play Once"; //Play Once, Replay Whole Queue, Replay Last Asset
    
    multiSync           = VINYL_DEFAULT_MULTI_SYNC;
    multiBlend          = 0;
    multiBlendCurveName = "";
}