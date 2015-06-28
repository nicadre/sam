(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   main.ml                                            :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: niccheva <niccheva@student.42.fr>          +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/27 11:27:36 by niccheva          #+#    #+#             *)
(*   Updated: 2015/06/28 19:25:31 by jerdubos         ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

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
  method draw = self#draw_button color; _text#draw tcolor
  method onclick = self#draw_button (Int32.lognot color); _text#draw (rev_color tcolor)
  method virtual name : string
  method virtual action : Sdlmixer.chunk -> unit
end

class eat_button screen s x y font color tcolor =
object (self)
  inherit button screen s x y font color tcolor
  method name = "eat"
  method action sound = Sdlmixer.play_sound sound
end

class thunder_button screen s x y font color tcolor =
object (self)
  inherit button screen s x y font color tcolor
  method name = "thunder"
  method action sound = Sdlmixer.play_sound sound
end

class bath_button screen s x y font color tcolor =
object (self)
  inherit button screen s x y font color tcolor
  method name = "bath"
  method action sound = Sdlmixer.play_sound sound
end

class kill_button screen s x y font color tcolor =
object (self)
  inherit button screen s x y font color tcolor
  method name = "kill"
  method action sound = Sdlmixer.play_sound sound
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

  method private draw_health screen x y font =
	Sdlvideo.fill_rect ~rect:(Sdlvideo.rect x y (self#health * 2) 30) screen (Int32.of_string "0x00FF0000") ;
	let text = Sdlttf.render_text_solid font ("Health : " ^ string_of_int self#health) ~fg:Sdlvideo.green in
	Sdlvideo.blit_surface ~dst_rect:(Sdlvideo.rect (x + ((200 - (fst (Sdlttf.size_text font ("Health : " ^ string_of_int self#health)))) / 2)) (y - 30) 200 30) ~src:text ~dst:screen ()

  method private draw_energy screen x y font =
	Sdlvideo.fill_rect ~rect:(Sdlvideo.rect x y (self#energy * 2) 30) screen (Int32.of_string "0x00FFFF00") ;
	let text = Sdlttf.render_text_solid font ("Energy : " ^ string_of_int self#energy) ~fg:Sdlvideo.yellow in
	Sdlvideo.blit_surface ~dst_rect:(Sdlvideo.rect (x + ((200 - (fst (Sdlttf.size_text font ("Energy : " ^ string_of_int self#energy)))) / 2)) (y - 30) 200 30) ~src:text ~dst:screen ()

  method private draw_hygiene screen x y font =
	Sdlvideo.fill_rect ~rect:(Sdlvideo.rect x y (self#hygiene * 2) 30) screen (Int32.of_string "0xFFFF0000") ;
	let text = Sdlttf.render_text_solid font ("Hygiene : " ^ string_of_int self#hygiene) ~fg:Sdlvideo.cyan in
	Sdlvideo.blit_surface ~dst_rect:(Sdlvideo.rect (x + ((200 - (fst (Sdlttf.size_text font ("Hygiene : " ^ string_of_int self#hygiene)))) / 2)) (y - 30) 200 30) ~src:text ~dst:screen ()

  method private draw_happiness screen x y font =
	Sdlvideo.fill_rect ~rect:(Sdlvideo.rect x y (self#happiness * 2) 30) screen (Int32.of_string "0x0000FF00") ;
	let text = Sdlttf.render_text_solid font ("Happiness : " ^ string_of_int self#happiness) ~fg:Sdlvideo.red in
	Sdlvideo.blit_surface ~dst_rect:(Sdlvideo.rect (x + ((200 - (fst (Sdlttf.size_text font ("Happiness : " ^ string_of_int self#happiness)))) / 2)) (y - 30) 200 30) ~src:text ~dst:screen ()

  method draw screen x y font =
	self#draw_health screen x y font ;
	self#draw_energy screen (x + 250) y font ;
	self#draw_hygiene screen (x + 500) y font ;
	self#draw_happiness screen (x + 750) y font ;
	Sdlvideo.flip screen

  method action (button:button) sound = print_endline "sam does a barrel roll" ; button#onclick ; button#action sound;
	match button#name with
	  | "eat" -> {<
		health = if (self#health < 75) then self#health + 25 else 100;
		energy = if (self#energy > 10) then self#energy - 10 else 0;
		hygiene = if (self#hygiene > 20) then self#hygiene - 20 else 0;
		happiness = if (self#happiness < 95) then self#happiness + 5 else 100 >}
	  | "thunder" -> {<
		health = if (self#health > 20) then self#health - 20 else 0;
		energy = if (self#energy < 75) then self#energy + 25 else 100;
		hygiene = self#hygiene;
		happiness = if (self#happiness > 20) then self#happiness - 20 else 0 >}
	  | "bath" -> {<
		health = if (self#health > 20) then self#health - 20 else 0;
		energy = if (self#energy > 10) then self#energy - 10 else 0;
		hygiene = if (self#hygiene < 75) then self#hygiene + 25 else 100;
		happiness = if (self#happiness < 95) then self#happiness + 5 else 100 >}
	  | "kill" -> {<
		health = if (self#health > 20) then self#health - 20 else 0;
		energy = if (self#energy > 10) then self#energy - 10 else 0;
		hygiene = self#hygiene;
		happiness = if (self#happiness < 80) then self#happiness + 20 else 100 >}
	  | _ -> {< health = self#health; energy = self#energy; hygiene = self#hygiene; happiness = self#happiness >}
end

let rec timer_loop (flag, callback) =
  if !flag then
	Thread.exit
  else
	(Thread.delay 1.; callback (); (timer_loop (flag, callback)))


let () =
  let exec samrows =
	try
	  Sdl.init [`VIDEO; `AUDIO];
	  at_exit Sdl.quit;
	  Sdlttf.init ();
	  at_exit Sdlttf.quit;
	  Sdlmixer.open_audio ();
      at_exit Sdlmixer.close_audio;
	  let screen = Sdlvideo.set_video_mode 1920 1080 [`DOUBLEBUF] in
	  let fond = Sdlloader.load_image "fond.jpg" in
	  let samimg = Sdlloader.load_image "sam.png" in
	  let eat_sound = Sdlmixer.loadWAV "eatsam.wav" in
	  let thunder_sound = Sdlmixer.loadWAV "thundersam.wav" in
	  let bath_sound = Sdlmixer.loadWAV "bathsam.wav" in
	  let kill_sound = Sdlmixer.loadWAV "killsam.wav" in
	  let position_of_fond = Sdlvideo.rect 0 0 1920 1080 in
	  let position_of_sam = Sdlvideo.rect 735 315 1920 1080 in
	  let timer_flag = ref false in
	  let timer_cb () = Sdlevent.add [Sdlevent.USER 0] in
	  let timer_thread = Thread.create timer_loop (timer_flag, timer_cb) in
	  let font = Sdlttf.open_font "arial.ttf" 24 in
	  let eat = new eat_button screen "EAT" 585 900 font (Int32.of_string "0xFF00FF00") Sdlvideo.cyan in
	  let thunder = new thunder_button screen "THUNDER" 785 900 font (Int32.of_string "0xFF00FF00") Sdlvideo.cyan in
	  let bath = new bath_button screen "BATH" 985 900 font (Int32.of_string "0xFF00FF00") Sdlvideo.cyan in
	  let kill = new kill_button screen "KILL" 1185 900 font (Int32.of_string "0xFF00FF00") Sdlvideo.cyan in
	  let redraw sam b button =
		Sdlvideo.blit_surface ~dst_rect:position_of_fond ~src:fond ~dst:screen ();
		Sdlvideo.blit_surface ~dst_rect:position_of_sam ~src:samimg ~dst:screen ();
		eat#draw;
		thunder#draw;
		bath#draw;
		kill#draw;
		if b then button#onclick;
		sam#draw screen 485 200 font
	  in
	  let save sam =
		let fout = open_out "save.itama" in
		if (sam#health = 0 || sam#energy = 0 || sam#hygiene = 0 || sam#happiness = 0)
		then (output_string fout ((string_of_int 100) ^ "\n") ;
			  output_string fout ((string_of_int 100) ^ "\n") ;
			  output_string fout ((string_of_int 100) ^ "\n") ;
			  output_string fout ((string_of_int 100) ^ "\n"))
		else
		  (output_string fout ((string_of_int sam#health) ^ "\n") ;
		   output_string fout ((string_of_int sam#energy) ^ "\n") ;
		   output_string fout ((string_of_int sam#hygiene) ^ "\n") ;
		   output_string fout ((string_of_int sam#happiness) ^ "\n")) ;
		close_out fout
	  in
	  let rec wait_for_escape sam =
		if sam#health = 0 || sam#energy = 0 || sam#hygiene = 0 || sam#happiness = 0 then (print_endline "You lose !"; save sam)
		else
		  match Sdlevent.wait_event () with
			| Sdlevent.KEYDOWN { Sdlevent.keysym = Sdlkey.KEY_ESCAPE } -> print_endline "Bye."; save sam

			| Sdlevent.MOUSEBUTTONDOWN ({ Sdlevent.mbe_button = Sdlmouse.BUTTON_LEFT } as c)
				when (c.Sdlevent.mbe_x >= eat#x && c.Sdlevent.mbe_x <= eat#x + 150 && c.Sdlevent.mbe_y >= eat#y && c.Sdlevent.mbe_y <= eat#y + 80) ->
			  let tmp = sam#action eat eat_sound in redraw tmp true eat; wait_for_escape tmp

			| Sdlevent.MOUSEBUTTONDOWN ({ Sdlevent.mbe_button = Sdlmouse.BUTTON_LEFT } as c)
				when (c.Sdlevent.mbe_x >= thunder#x && c.Sdlevent.mbe_x <= thunder#x + 150 && c.Sdlevent.mbe_y >= thunder#y && c.Sdlevent.mbe_y <= thunder#y + 80) ->
			  let tmp = sam#action thunder thunder_sound in redraw tmp true thunder; wait_for_escape tmp

			| Sdlevent.MOUSEBUTTONDOWN ({ Sdlevent.mbe_button = Sdlmouse.BUTTON_LEFT } as c)
				when (c.Sdlevent.mbe_x >= bath#x && c.Sdlevent.mbe_x <= bath#x + 150 && c.Sdlevent.mbe_y >= bath#y && c.Sdlevent.mbe_y <= bath#y + 80) ->
			  let tmp = sam#action bath bath_sound in redraw tmp true bath; wait_for_escape tmp

			| Sdlevent.MOUSEBUTTONDOWN ({ Sdlevent.mbe_button = Sdlmouse.BUTTON_LEFT } as c)
				when (c.Sdlevent.mbe_x >= kill#x && c.Sdlevent.mbe_x <= kill#x + 150 && c.Sdlevent.mbe_y >= kill#y && c.Sdlevent.mbe_y <= kill#y + 80) ->
			  let tmp = sam#action kill kill_sound in redraw tmp true kill; wait_for_escape tmp

			| Sdlevent.MOUSEBUTTONUP { Sdlevent.mbe_button = Sdlmouse.BUTTON_LEFT } ->
			  eat#draw ; thunder#draw ; bath#draw ; kill#draw ; Sdlvideo.flip screen ; wait_for_escape sam

			| Sdlevent.USER 0 ->
			  print_endline "SAM NE MEURT JAMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIS !!";
			  let tmp = new sam (if (sam#health > 1) then sam#health - 1 else 0) sam#energy sam#hygiene sam#happiness in
			  redraw tmp false eat; wait_for_escape tmp

			| _ -> wait_for_escape sam
	  in
	  redraw samrows false eat;
	  wait_for_escape samrows;
	  timer_flag := true;
	  Thread.join timer_thread
	with
	  | _ -> print_endline "An error occured."
  in
  try
	let fin = open_in "save.itama" in
	let health = int_of_string (input_line fin) in
	let energy = int_of_string (input_line fin) in
	let hygiene = int_of_string (input_line fin) in
	let happiness = int_of_string (input_line fin) in
	close_in fin ;
	let samrows = new sam health energy hygiene happiness in
	exec samrows;
  with
	| _ -> let samrows = new sam 100 100 100 100 in exec samrows

