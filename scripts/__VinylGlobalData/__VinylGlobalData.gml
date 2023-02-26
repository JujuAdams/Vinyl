function __VinylGlobalData()
{
    static _struct = {
        __frame: 0,
        
        __liveUpdate: (VINYL_LIVE_UPDATE_PERIOD > 0),
        
        __listenerX: 0,
        __listenerY: 0,
        
        __idToInstanceDict: ds_map_create(),
        
        __transpose: 0,
        
        __poolAsset:      new __VinylClassPool(91000000, __VinylClassInstanceAsset),
        __poolBasic:      new __VinylClassPool(92000000, __VinylClassInstanceBasic),
        __poolQueue:      new __VinylClassPool(93000000, __VinylClassInstanceQueue),
        __poolMulti:      new __VinylClassPool(94000000, __VinylClassInstanceMulti),
        __poolEmitter:    new __VinylClassPool(95000000, __VinylClassEmitter),
        __poolPanEmitter: new __VinylClassPool(96000000, __VinylClassPanEmitter),
        
        __topLevelArray: [],
        
        __patternDict:  {},
        __patternArray: [],
        
        __labelDict:  {},
        __labelOrder: [],
        
        __effectChainDict:  {},
        __effectChainArray: [],
        
        __knobDict:  {},
        __knobArray: [],
    };
    
    return _struct;
}