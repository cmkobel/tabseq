#!/bin/bash

clang test.c \
	&& echo "# --- running below ---" \
	&& ./a.out