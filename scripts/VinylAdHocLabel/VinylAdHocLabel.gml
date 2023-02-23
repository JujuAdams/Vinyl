/// @param name
/// @param dataStruct

function VinylAdHocLabel(_name, _dataStruct)
{
    var _struct = new __VinylClassLabel(_name, undefined, true);
    _struct.__Initialize(_dataStruct, undefined);
    return _struct;
}