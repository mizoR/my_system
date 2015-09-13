#!/bin/bash

. helper.sh

printf 'is_ios      #=> '
is_osx && echo true || echo false

printf 'is_debian   #=> '
is_debian && echo true || echo false

printf 'is_redhat   #=> '
is_redhat && echo true || echo false
