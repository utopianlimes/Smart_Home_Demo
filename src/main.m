%room_handle = connect_to_smart_room();
%connect_to_fbd();
%state = get_state(gesture_class);
count = 0;
while(true)
    switch (state)
        case "Idle"
            [gesture_class, gesture_amplitude, fbd_state] = get_decoder_output();
            % if gesture_class == "Wake Gesture"
            state = fbd_state; %"Gesture Detected"
            % end
            count = count + 1;
            disp(count)
        case "Gesture Detected"
            command_str = generate_tcp_command(gesture_class, gesture_amplitude);
            % send_tcp_command(room_handle, command_str)
            disp(command_str)
            state = "Idle";
            if isempty(command_str)
                continue
            else
                disp('http request')
            end
               
    end
end