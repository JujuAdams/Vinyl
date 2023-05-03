function VinylSystemGetPoolInactiveCount()
{
    static _globalData = __VinylGlobalData();
    
    return _globalData.__poolAsset.__GetInactiveCount()
         + _globalData.__poolBasic.__GetInactiveCount()
         + _globalData.__poolQueue.__GetInactiveCount()
         + _globalData.__poolMulti.__GetInactiveCount()
         + _globalData.__poolEmitter.__GetInactiveCount()
         + _globalData.__poolPanEmitter.__GetInactiveCount();
}