#!/bin/bash

while true
do
    # if keyboard connected
    if aconnect -o | grep 'USB Keystation 88es' &> /dev/null;
    then
        # if fluid synth is not running
        if ! pgrep fluidsynth &> /dev/null
        then
            echo "starting fluidsynth"
            fluidsynth -si -p fluid -a alsa -m alsa_seq \
                -r 48000 -c 2 -z 1024 -C 0 -R 0 \
                -g 5 /usr/share/sounds/sf2/FluidR3_GM.sf2 &

            sleep 3

            echo "connecting keyboard"
            aconnect 'USB Keystation 88es':0 'fluid':0
        fi
    else
        # if fluid synth is running
        if pgrep fluidsynth &> /dev/null
        then
            echo "killing fluidsynth"
            killall fluidsynth
        fi
    fi

    sleep 20
done
