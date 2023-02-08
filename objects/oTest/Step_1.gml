VinylListenerSet(mouse_x, mouse_y);
//VinylPanSet(instance, dsin(current_time/20));

if (keyboard_check_pressed(ord("G")))
{
    emitter = undefined;
    gc_collect();
}