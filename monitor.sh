#! /bin/env bash

stty -F /dev/ttyUSB0 raw 115200
cat /dev/ttyUSB0
