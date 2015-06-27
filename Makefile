#******************************************************************************#
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: niccheva <niccheva@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2015/06/21 10:42:19 by niccheva          #+#    #+#              #
#    Updated: 2015/06/27 13:43:46 by niccheva         ###   ########.fr        #
#                                                                              #
#******************************************************************************#

RESULT = itama
SOURCES = main.ml
LIBS = bigarray sdl sdlloader
INCDIRS = +sdl
OCAMLLDFLAGS = -cclib "-framework Cocoa"
THREADS = true

include OCamlMakefile

fclean: cleanup
	rm -f $(RESULT)
