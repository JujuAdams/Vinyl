draw_set_font(fntText);

UIStart(10, 10, undefined, undefined, true);
UIButtonInline("General Test", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestGeneral);
});
UINewline();
UINewline();
UIButtonInline("Stop Current", function()
{
    VinylStop(runtimeQueue);
});
UISpace(20);
UIButtonInline("Fade Out Current", function()
{
    VinylFadeOut(runtimeQueue);
});
UINewline();
UITextInline($"Behaviour = {VinylQueueGetBehaviour(runtimeQueue)}");
UISpace(20);
UIButtonInline("DONT_LOOP", function()
{
    VinylQueueSetBehaviour(runtimeQueue, VINYL_QUEUE.DONT_LOOP);
});
UISpace(20);
UIButtonInline("LOOP_EACH", function()
{
    VinylQueueSetBehaviour(runtimeQueue, VINYL_QUEUE.LOOP_EACH);
});
UISpace(20);
UIButtonInline("LOOP_ON_LAST", function()
{
    VinylQueueSetBehaviour(runtimeQueue, VINYL_QUEUE.LOOP_ON_LAST);
});
UINewline();
UIButtonInline("Play current sound once", function()
{
    VinylSetLoop(runtimeQueue, false);
});
UIButtonInline("Loop current sound", function()
{
    VinylSetLoop(runtimeQueue, true);
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
UINewline();
UIButtonInline("Push 0", function()
{
    VinylQueuePushBottom(runtimeQueue, sndSync0);
});
UISpace(20);
UIButtonInline("Push 1", function()
{
    VinylQueuePushBottom(runtimeQueue, sndSync1);
});
UISpace(20);
UIButtonInline("Push 2", function()
{
    VinylQueuePushBottom(runtimeQueue, sndSync2);
});
UISpace(20);
UIButtonInline("Push 3", function()
{
    VinylQueuePushBottom(runtimeQueue, sndSync3);
});
UISpace(20);
UIButtonInline("Push 1KHz", function()
{
    VinylQueuePushBottom(runtimeQueue, snd1KHz);
});
UINewline();
UINewline();
var _asset = VinylGetAsset(runtimeQueue);
UITextInline(audio_exists(_asset)? audio_get_name(_asset) : "<no sound playing>");
UISpace(20);
UITextInline(VinylGetLoop(runtimeQueue)? "(looping)" : "(playing once)");
UINewline();
UIText(json_stringify(VinylQueueGetArray(runtimeQueue), true));