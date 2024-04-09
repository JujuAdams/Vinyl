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
    
    static __AddChild = function(_assetTagName)
    {
        array_push(__childrenArray, _assetTagName);
        array_sort(__childrenArray, true);
    }
    
    static __RemoveChild = function(_assetTagName)
    {
        var _index = __VinylArrayFindIndex(__childrenArray, _assetTagName);
        if (_index != undefined) array_delete(__childrenArray, _index, 1);
    }
    
    static __ChangeParent = function(_assetTagName, _dictionary)
    {
        var _oldParent = _dictionary[$ __parent];
        var _newParent = _dictionary[$ _assetTagName];
        
        //Prevent infinite loops
        if ((_newParent != undefined) && _newParent.__HasAncestor(__name, _dictionary)) return;
        
        if (_oldParent != undefined) _oldParent.__RemoveChild(__name);
        __parent = _assetTagName
        if (_newParent != undefined) _newParent.__AddChild(__name);
    }
    
    static __HasAncestor = function(_assetTagName, _dictionary)
    {
        if (_assetTagName == __VED_ROOT_ASSET_TAG) return true;
        if (__parent == undefined) return false;
        if (__parent == _assetTagName) return true;
        return _dictionary[$ __parent].__HasAncestor(_assetTagName, _dictionary);
    }
    
    static __BuildTreeUI = function(_multiselector, _dictionary, _visibleArray)
    {
        var _selected = _multiselector.__IsSelected(__name, _visibleArray);
        if (((not _multiselector.__multiselect) || (_selected && _multiselector.__seeSelected) || ((not _selected) && _multiselector.__seeUnselected))) //Selected check
        {
            //Push the name of this visible sound to our array
            array_push(_visibleArray, __name);
            
            if (ImGui.Selectable(__name, _selected))
            {
                _multiselector.__SelectToggle(__name);
            }
            
            if (__name != __VED_ROOT_ASSET_TAG)
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
        		if (_payload != undefined) _dictionary[$ _payload].__ChangeParent(__name, _dictionary);
                ImGui.EndDragDropTarget();
            }
            
            ImGui.TreePush();
            
            //Incredibly rare use of a for-loop in Juju's code
            for(var _i = 0; _i < array_length(__childrenArray); ++_i)
            {
                _dictionary[$ __childrenArray[_i]].__BuildTreeUI(_multiselector, _dictionary, _visibleArray);
            }
            
            ImGui.TreePop();
        }
    }
}