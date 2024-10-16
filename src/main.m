room_handle = connect_to_smart_room();
connect_to_fbd();
state = get_state(gesture_class);
while(True)
    switch (state)
        case "Idle"
            [gesture_class, gesture_amplitude] = get_decoder_output();
            if gesture_class == "Wake Gesture"
                state = "Gesture Detected"
            end

        case "Gesture Detected"
            command_str = generate_tcp_command(gesture_class, gesture_amplitude);
            send_tcp_command(room_handle, command_str)
            state = "Idle";
    end
end