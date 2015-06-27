(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   main.ml                                            :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: niccheva <niccheva@student.42.fr>          +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/27 11:27:36 by niccheva          #+#    #+#             *)
(*   Updated: 2015/06/27 21:20:04 by jerdubos         ###   ########.fr       *)
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
  val pos = Sdlvideo.rect x y 150 80

  method private make_text color = Sdlttf.render_text_solid font s ~fg:color
  method draw color = Sdlvideo.blit_surface ~dst_rect:pos ~src:(self#make_text color ) ~dst:screen ()
end

class virtual button screen s x y font color tcolor =
object (self)
  val _text = new text screen s font (((150 - (fst (Sdlttf.size_text font s))) / 2) + x) (((80 - (snd (Sdlttf.size_text font s))) / 2) + y)

  method x = x
  method y = y
  method private draw_button color = Sdlvideo.fill_rect ~rect:(Sdlvideo.rect x y 150 80) screen color
  method draw = self#draw_button color; _text#draw tcolor; Sdlvideo.flip screen
  method onclick = self#draw_button (Int32.lognot color); _text#draw (rev_color tcolor); Sdlvideo.flip screen ; self#action
  method virtual action : unit
end

class eat_button screen s x y font color tcolor =
object (self)
  inherit button screen s x y font color tcolor
  method action = print_endline "eat"
end

class thunder_button screen s x y font color tcolor =
object (self)
  inherit button screen s x y font color tcolor
  method action = print_endline "thunder"
end

class bath_button screen s x y font color tcolor =
object (self)
  inherit button screen s x y font color tcolor
  method action = print_endline "bath"
end

class kill_button screen s x y font color tcolor =
object (self)
  inherit button screen s x y font color tcolor
  method action = print_endline "kill"
end

class sam health energy hygiene happiness =
object (self)
  val health = health
  val energy = energy
  val hygiene = hygiene
  val happiness = happiness

  method health = health
  method energy = energy
  method hygiene = hygiene
  method happiness = happiness

  method private draw_health screen x y font color tcolor = Sdlvideo.fill_rect ~rect:(Sdlvideo.rect x y (self#health * 2) 30) screen color ; let text = Sdlttf.render_text_solid font "Health" ~fg:tcolor in Sdlvideo.blit_surface ~dst_rect:(Sdlvideo.rect (x + ((200 - (fst (Sdlttf.size_text font "Health"))) / 2)) (y - 30) 200 30) ~src:text ~dst:screen ()
  method private draw_energy screen x y font color tcolor = Sdlvideo.fill_rect ~rect:(Sdlvideo.rect x y (self#energy * 2) 30) screen color ; let text = Sdlttf.render_text_solid font "Energy" ~fg:tcolor in Sdlvideo.blit_surface ~dst_rect:(Sdlvideo.rect (x + ((200 - (fst (Sdlttf.size_text font "Energy"))) / 2)) (y - 30) 200 30) ~src:text ~dst:screen ()
  method private draw_hygiene screen x y font color tcolor = Sdlvideo.fill_rect ~rect:(Sdlvideo.rect x y (self#hygiene * 2) 30) screen color ; let text = Sdlttf.render_text_solid font "Hygiene" ~fg:tcolor in Sdlvideo.blit_surface ~dst_rect:(Sdlvideo.rect (x + ((200 - (fst (Sdlttf.size_text font "Hygiene"))) / 2)) (y - 30) 200 30) ~src:text ~dst:screen ()
  method private draw_happiness screen x y font color tcolor = Sdlvideo.fill_rect ~rect:(Sdlvideo.rect x y (self#happiness * 2) 30) screen color ; let text = Sdlttf.render_text_solid font "Happiness" ~fg:tcolor in Sdlvideo.blit_surface ~dst_rect:(Sdlvideo.rect (x + ((200 - (fst (Sdlttf.size_text font "Happiness"))) / 2)) (y - 30) 200 30) ~src:text ~dst:screen ()
  method draw screen x y font color tcolor = self#draw_health screen x y font color tcolor; self#draw_energy screen (x + 250) y font color tcolor; self#draw_hygiene screen (x + 500) y font color tcolor; self#draw_happiness screen (x + 750) y font color tcolor; Sdlvideo.flip screen
  method action (button:button) = print_endline "sam does a barrel roll" ; button#onclick ;
	match button with
	  | eat_button -> {< health = self#health + 25; energy = self#energy - 10; hygiene = self#hygiene - 20; happiness = self#happiness + 5 >}
	  | thunder_button -> {< health = self#health - 20; energy = self#energy + 25; hygiene = self#hygiene; happiness = self#happiness - 20 >}
	  | bath_button -> {< health = self#health - 20; energy = self#energy - 10; hygiene = self#hygiene + 25; happiness = self#happiness + 5 >}
	  | kill_button -> {< health = self#health - 20; energy = self#energy - 10; hygiene = self#hygiene; happiness = self#happiness + 20 >}
	  | _ -> {< health = self#health; energy = self#energy; hygiene = self#hygiene; happiness = self#happiness >}
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
  let position_of_sam = Sdlvideo.rect 735 315 1920 1080 in
  Sdlvideo.blit_surface ~dst_rect:position_of_fond ~src:fond ~dst:screen ();
  Sdlvideo.blit_surface ~dst_rect:position_of_sam ~src:sam ~dst:screen ();
  let font = Sdlttf.open_font "arial.ttf" 24 in
  let eat = new eat_button screen "EAT" 585 900 font (Int32.of_string "0xFF00FF00") Sdlvideo.cyan in
  let thunder = new thunder_button screen "THUNDER" 785 900 font (Int32.of_string "0xFF00FF00") Sdlvideo.cyan in
  let bath = new bath_button screen "BATH" 985 900 font (Int32.of_string "0xFF00FF00") Sdlvideo.cyan in
  let kill = new kill_button screen "KILL" 1185 900 font (Int32.of_string "0xFF00FF00") Sdlvideo.cyan in
  let samrows = new sam 80 10 57 23 in
  eat#draw;
  thunder#draw;
  bath#draw;
  kill#draw;
  samrows#draw screen 485 200 font (Int32.of_string "0x0000FF00") (Sdlvideo.red);
  let rec wait_for_escape () =
	match Sdlevent.wait_event () with
	  | Sdlevent.KEYDOWN { Sdlevent.keysym = Sdlkey.KEY_ESCAPE } -> print_endline "Bye."
	  | Sdlevent.MOUSEBUTTONDOWN ({ Sdlevent.mbe_button = Sdlmouse.BUTTON_LEFT } as c) when (c.mbe_x >= eat#x && c.mbe_x <= eat#x + 150 && c.mbe_y >= eat#y && c.mbe_y <= eat#y + 80) -> eat#onclick ; wait_for_escape ()
	  | Sdlevent.MOUSEBUTTONDOWN ({ Sdlevent.mbe_button = Sdlmouse.BUTTON_LEFT } as c) when (c.mbe_x >= thunder#x && c.mbe_x <= thunder#x + 150 && c.mbe_y >= thunder#y && c.mbe_y <= thunder#y + 80) -> thunder#onclick ; wait_for_escape ()
	  | Sdlevent.MOUSEBUTTONDOWN ({ Sdlevent.mbe_button = Sdlmouse.BUTTON_LEFT } as c) when (c.mbe_x >= bath#x && c.mbe_x <= bath#x + 150 && c.mbe_y >= bath#y && c.mbe_y <= bath#y + 80) -> bath#onclick ; wait_for_escape ()
	  | Sdlevent.MOUSEBUTTONDOWN ({ Sdlevent.mbe_button = Sdlmouse.BUTTON_LEFT } as c) when (c.mbe_x >= kill#x && c.mbe_x <= kill#x + 150 && c.mbe_y >= kill#y && c.mbe_y <= kill#y + 80) -> kill#onclick ; wait_for_escape ()
	  | Sdlevent.MOUSEBUTTONUP { Sdlevent.mbe_button = Sdlmouse.BUTTON_LEFT } -> eat#draw ; thunder#draw ; bath#draw ; kill#draw ; print_endline "draw" ; wait_for_escape ()
	  | event -> print_endline (Sdlevent.string_of_event event);
		wait_for_escape ()
  in
  wait_for_escape ()
(*  Sdltimer.delay 3000*)
