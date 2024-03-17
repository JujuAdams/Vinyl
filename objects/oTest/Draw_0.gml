shader_set(shdJujuverse);
shader_set_uniform_f(shader_get_uniform(shdJujuverse, "u_fTime"), current_time/11000);
draw_primitive_begin(pr_trianglestrip);
draw_vertex_texture_color(0, 0, 0, 0, c_white, 0.1);
draw_vertex_texture_color(room_width, 0, -room_width/room_height, 0, c_white, 0.1);
draw_vertex_texture_color(0, room_height, 0, 1, c_black, 0.2);
draw_vertex_texture_color(room_width, room_height, -room_width/room_height, 1, c_black, 0.2);
draw_primitive_end();
shader_reset();