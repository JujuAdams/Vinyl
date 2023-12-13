// Feather disable all

function __VinylGenerateUUID()
{
    return string(ptr(__VinylRandom(0x7FFF_FFFF_FFFF_FFFF)));
}