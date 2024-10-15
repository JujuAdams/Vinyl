draw_set_font(fntText);

UIStart(10, 10, undefined, undefined, true);
UIButtonInline("General Test", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestGeneral);
});
UINewline();
UINewline();
UIButtonInline("Set 0", function()
{
    VinylFadeOut(runtimeQueue);
    VinylQueueSetBottom(runtimeQueue, sndSync0);
});
UISpace(20);
UIButtonInline("Set 1", function()
{
    VinylFadeOut(runtimeQueue);
    VinylQueueSetBottom(runtimeQueue, sndSync1);
});
UISpace(20);
UIButtonInline("Set 2", function()
{
    VinylFadeOut(runtimeQueue);
    VinylQueueSetBottom(runtimeQueue, sndSync2);
});
UISpace(20);
UIButtonInline("Set 3", function()
{
    VinylFadeOut(runtimeQueue);
    VinylQueueSetBottom(runtimeQueue, sndSync3);
});
UISpace(20);
UIButtonInline("Set 1KHz", function()
{
    VinylFadeOut(runtimeQueue);
    VinylQueueSetBottom(runtimeQueue, snd1KHz);
});