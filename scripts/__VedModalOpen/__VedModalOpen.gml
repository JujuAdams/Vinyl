// Feather disable all

/// @param constructor

function __VedModalOpen(_constructor)
{
    static _modalsArray = __VedSystem().__modalsArray;
    var _modal = new _constructor();
    array_push(_modalsArray, _modal);
    return _modal;
}