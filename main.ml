(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   main.ml                                            :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: niccheva <niccheva@student.42.fr>          +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/27 11:27:36 by niccheva          #+#    #+#             *)
(*   Updated: 2015/06/27 18:58:00 by jerdubos         ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)
(*
let () =
  Sdlttf.init ();
  at_exit Sdlttf.quit;
  let screen = Sdlvideo.set_video_mode 1920 1080 [`DOUBLEBUF] in
  let image = Sdlloader.load_image "toto.jpg" in
  let position_of_image = Sdlvideo.rect 0 0 1920 1080 in
  let position_of_button = Sdlvideo.rect 0 0 200 200 in
  let position_of_text = Sdlvideo.rect 0 0 200 200 in
  let font = Sdlttf.open_font "arial.ttf" 24 in
  let text = Sdlttf.render_text_solid font "Enjoy!" ~fg:Sdlvideo.cyan in
  let text2 = Sdlttf.render_text_blended font "GG!" ~fg:Sdlvideo.magenta in
  let rec wait_for_escape () =
	match Sdlevent.wait_event () with
	  | Sdlevent.KEYDOWN { Sdlevent.keysym = Sdlkey.KEY_ESCAPE } -> print_endline "Bye."
	  | Sdlevent.MOUSEBUTTONDOWN ({ Sdlevent.mbe_button = Sdlmouse.BUTTON_LEFT } as c) when (c.mbe_x <= 200 && c.mbe_y <= 200) -> Sdlvideo.fill_rect ~rect:position_of_button screen (Int32.of_string "0xFFFF0000"); Sdlvideo.blit_surface ~dst_rect:position_of_text ~src:text2 ~dst:screen (); Sdlvideo.flip screen; wait_for_escape ()
	  | Sdlevent.MOUSEBUTTONDOWN ({ Sdlevent.mbe_button = Sdlmouse.BUTTON_LEFT } as c) when (c.mbe_x >= 300 && c.mbe_y <= 200) -> print_endline "Bye."
	  | Sdlevent.MOUSEBUTTONDOWN ({ Sdlevent.mbe_button = Sdlmouse.BUTTON_LEFT } as c) when (c.mbe_x <= 500 && c.mbe_y <= 100) -> print_endline "Bye."
	  | Sdlevent.MOUSEBUTTONDOWN ({ Sdlevent.mbe_button = Sdlmouse.BUTTON_LEFT } as c) when (c.mbe_x <= 800 && c.mbe_y <= 300) -> print_endline "Bye."
	  | Sdlevent.MOUSEBUTTONUP { Sdlevent.mbe_button = Sdlmouse.BUTTON_LEFT } -> Sdlvideo.fill_rect ~rect:position_of_button screen (Int32.of_string "0xFF00FF00"); Sdlvideo.blit_surface ~dst_rect:position_of_text ~src:text ~dst:screen (); Sdlvideo.flip screen; wait_for_escape ()
	  | event -> print_endline (Sdlevent.string_of_event event);
		wait_for_escape ()
  in
  let main () =
	Sdl.init [`VIDEO];
	at_exit Sdl.quit;
	Sdlvideo.blit_surface ~dst_rect:position_of_image ~src:image ~dst:screen ();
	Sdlvideo.fill_rect ~rect:position_of_button screen (Int32.of_string "0xFF00FF00");
	Sdlvideo.blit_surface ~dst_rect:position_of_text ~src:text ~dst:screen ();
	Sdlvideo.flip screen;
	wait_for_escape ()
  in main ()
*)

let rev_color = function
  | ((a, b, c):Sdlvideo.color) -> ((lnot a, lnot b, lnot c):Sdlvideo.color)

class text screen s font x y =
object (self)
  val pos = Sdlvideo.rect x y 100 50

  method private make_text color = Sdlttf.render_text_solid font s ~fg:color
  method draw color = Sdlvideo.blit_surface ~dst_rect:pos ~src:(self#make_text color ) ~dst:screen ()
end

class button screen s x y font color tcolor =
object (self)
  val _text = new text screen s font (((150 - (fst (Sdlttf.size_text font s))) / 2) + x) (((80 - (snd (Sdlttf.size_text font s))) / 2) + y)

  method x = x
  method y = y
  method private draw_button color = Sdlvideo.fill_rect ~rect:(Sdlvideo.rect x y 150 80) screen color
  method draw = self#draw_button color; _text#draw tcolor; Sdlvideo.flip screen
  method onclick = self#draw_button (Int32.lognot color); _text#draw (rev_color tcolor); Sdlvideo.flip screen
end

let () =
  Sdl.init [`VIDEO];
  at_exit Sdl.quit;
  Sdlttf.init ();
  at_exit Sdlttf.quit;
  let screen = Sdlvideo.set_video_mode 1920 1080 [`DOUBLEBUF] in
  let fond = Sdlloader.load_image "fond.jpg" in
  let sam = Sdlloader.load_image "sam.png" in
  let position_of_fond = Sdlvideo.rect 0 0 1920 1080 in
  let position_of_sam = Sdlvideo.rect 735 315 1920 1080 in (*************************************************)
  Sdlvideo.blit_surface ~dst_rect:position_of_fond ~src:fond ~dst:screen ();
  Sdlvideo.blit_surface ~dst_rect:position_of_sam ~src:sam ~dst:screen ();
  let font = Sdlttf.open_font "arial.ttf" 24 in
  let eat = new button screen "EAT" 585 900 font (Int32.of_string "0xFF00FF00") Sdlvideo.cyan in
  let thunder = new button screen "THUNDER" 785 900 font (Int32.of_string "0xFF00FF00") Sdlvideo.cyan in
  let bath = new button screen "BATH" 985 900 font (Int32.of_string "0xFF00FF00") Sdlvideo.cyan in
  let kill = new button screen "KILL" 1185 900 font (Int32.of_string "0xFF00FF00") Sdlvideo.cyan in
  eat#onclick;
  thunder#draw;
  bath#draw;
  kill#draw;
  Sdltimer.delay 3000
