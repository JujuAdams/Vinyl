// Feather disable all

function __VedGenerateUUID()
{
    return string(ptr(__VinylRandom(0x7FFF_FFFF_FFFF_FFFF)));
}