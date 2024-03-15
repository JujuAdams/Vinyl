// Feather disable all

function __VedClassLibrary() constructor
{
    __byName    = {};
    __orderName = [];
    __orderData = [];
    
    static __Add = function(_name, _data)
    {
        if (variable_struct_exists(__byName, _name))
        {
            __VedLog("Member called \"", _name, "\" already exists in library");
            return;
        }
        
        __byName[$ _name] = _data;
        array_push(__orderData, _data);
        array_push(__orderName, _name);
    }
    
    static __RemoveByName = function(_name)
    {
        var _member = __byName[$ _name];
        variable_struct_remove(__byName, _name);
        
        var _orderData = __orderData;
        var _orderName = __orderName;
        
        var _i = 0;
        repeat(array_length(_orderData))
        {
            if (_orderData[_i] == _member)
            {
                array_delete(_orderData, _i, 1);
                array_delete(_orderName, _i, 1);
                break;
            }
            
            ++_i;
        }
    }
    
    static __RemoveByIndex = function(_index)
    {
        var _name = __orderName[_index];
        variable_struct_remove(__byName, _name);
        array_delete(__orderData, _index, 1);
        array_delete(__orderName, _index, 1);
    }
    
    static __GetByName = function(_name)
    {
        return __byName[$ _name];
    }
    
    static __Exists = function(_name)
    {
        return variable_struct_exists(__byName, _name);
    }
    
    static __GetCount = function()
    {
        return array_length(__orderData);
    }
    
    static __GetDataByIndex = function(_index)
    {
        return __orderData[_index];
    }
    
    static __GetNameByIndex = function(_index)
    {
        return __orderName[_index];
    }
    
    static __ForEach = function(_function, _metadata)
    {
        var _orderData = __orderData;
        var _orderName = __orderName;
        
        var _i = 0;
        repeat(array_length(_orderData))
        {
            _function(_i, _orderName[_i], _orderData[_i], _metadata);
            ++_i;
        }
    }
}