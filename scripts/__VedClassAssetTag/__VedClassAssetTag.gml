// Feather disable all

function __VedClassAssetTag() constructor
{
    static _system = __VedSystem();
    
    __name = undefined;
    __soundNameArray = [];
    
    __parent = undefined;
    __childrenArray = [];
    
    static __Add = function(_name)
    {
        array_push(__soundNameArray, _name);
    }
    
    static __Remove = function(_name)
    {
        var _index = __VedArrayFindIndex(__soundNameArray, _name);
        if (_index != undefined) array_delete(__soundNameArray, _index, 1);
    }
    
    static __RemoveFromAll = function()
    {
        var _soundDict = _system.__project.__libSound.__GetDictionary();
        
        var _i = array_length(__soundNameArray)-1;
        repeat(array_length(__soundNameArray))
        {
            _soundDict[$ __soundNameArray[_i]].__SetAssetTag(__name, false);
            --_i;
        }
    }
    
    static __CopyAssetArrayTo = function(_array)
    {
        array_copy(_array, array_length(_array), __soundNameArray, 0, array_length(__soundNameArray));
    }
    
    static __BuildTreeUI = function(_multiselector, _dictionary, _rootAssetTag)
    {
        ImGui.Selectable(__name ?? "Master");
        
        if (__name != undefined)
        {
            if (ImGui.BeginDragDropSource())
            {
                ImGui.SetDragDropPayload("Asset Tag Move", __name);
                ImGui.EndDragDropSource();
            }
        }
            
        if (ImGui.BeginDragDropTarget())
        {
    		var _payload = ImGui.AcceptDragDropPayload("Asset Tag Move");
    		if (_payload != undefined)
            {
                var _source = _dictionary[$ _payload];
                
                var _oldParent = (_source.__parent == undefined)? _rootAssetTag : _dictionary[$ _source.__parent];
                if (_oldParent != undefined)
                {
                    var _index = __VinylArrayFindIndex(_oldParent.__childrenArray, _payload);
                    if (_index != undefined) array_delete(_oldParent.__childrenArray, _index, 1);
                }
                
                _source.__parent = __name;
                array_push(__childrenArray, _payload);
                array_sort(__childrenArray, true);
            }
            
            ImGui.EndDragDropTarget();
        }
        
        ImGui.TreePush();
        
        //Incredibly rare use of a for-loop in Juju's code
        for(var _i = 0; _i < array_length(__childrenArray); ++_i)
        {
            _dictionary[$ __childrenArray[_i]].__BuildTreeUI(_multiselector, _dictionary, _rootAssetTag);
        }
        
        ImGui.TreePop();
    }
}