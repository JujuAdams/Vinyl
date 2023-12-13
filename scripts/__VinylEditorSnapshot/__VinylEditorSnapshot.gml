// Feather disable all

/// @param [name]

function __VinylEditorSnapshot(_name = undefined)
{
    static _globalData    = __VinylGlobalData();
    var _topLevelArray = _globalData.__topLevelArray;
    
    var _snapshot = new __VinylClassSnapshot(_name);
    __VinylDocument().__PushSnapshot(_snapshot);
    
    var _i = 0;
    repeat(array_length(_topLevelArray))
    {
        _topLevelArray[_i].__Snapshot(_snapshot);
        ++_i;
    }
    
    //TODO - Knobs, labels, stacks, and global settings
    
    __VinylEditorSetStatusText("Snapshot taken!  ", _snapshot);
}