(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   main.ml                                            :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: niccheva <niccheva@student.42.fr>          +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/27 11:27:36 by niccheva          #+#    #+#             *)
(*   Updated: 2015/06/27 15:40:43 by niccheva         ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

let rec wait_for_escape () =
  match Sdlevent.wait_event () with
  | Sdlevent.KEYDOWN { Sdlevent.keysym = Sdlkey.KEY_ESCAPE } -> print_endline "Bye."
  | Sdlevent.MOUSEBUTTONDOWN { Sdlevent.mbe_button = Sdlmouse.BUTTON_LEFT } -> print_endline "Bye."
  | event -> print_endline (Sdlevent.string_of_event event);
			 wait_for_escape ()

let main () =
    Sdl.init [`VIDEO];
	at_exit Sdl.quit;
	let screen = Sdlvideo.set_video_mode 1920 1080 [`DOUBLEBUF] in
	let image = Sdlloader.load_image "toto.jpg" in
	let position_of_image = Sdlvideo.rect 0 0 1920 1080 in
	let position_of_button = Sdlvideo.rect 0 0 200 200 in
	Sdlvideo.blit_surface ~dst_rect:position_of_image ~src:image ~dst:screen ();
	Sdlvideo.fill_rect ~rect:position_of_button screen (Int32.of_string "0x00FF00FF");
	Sdlvideo.flip screen;
	wait_for_escape ()

let () = main ()
