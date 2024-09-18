function command_str = generate_tcp_command(gesture_class, gesture_amplitude)
    % This function outputs a command in the form of: %s%D- tcp-ip_address
    load("C:\Users\tjk90\Box\JAGLAB\Projects\Demo-Smart-Room\api_cmd.mat")
    x = convertStringsToChars(gesture_class);
    n = round(gesture_amplitude, 1);    % rounds amplitude to tenth decimal place
    
    % gesture classes
    blinds_o = 'blinds_o';
    blinds_b = 'blinds_b';

    % gesture class states and positions
    blinds_o_up = dictionary(0, api_cmd{96}, .1, api_cmd{107}, .2, api_cmd{108}, .3, api_cmd{109}, .4, api_cmd{110},...
            .5, api_cmd{111}, .6, api_cmd{112}, .7, api_cmd{113}, .8, api_cmd{114}, .9, api_cmd{115}, 1, api_cmd{97});
    blinds_b_up = dictionary(0, api_cmd{94}, .1, api_cmd{125}, .2, api_cmd{126}, .3, api_cmd{127}, .4, api_cmd{128},...
            .5, api_cmd{129}, .6, api_cmd{130}, .7, api_cmd{131}, .8, api_cmd{132}, .9, api_cmd{133}, 1, api_cmd{95});
    blinds = struct(blinds_o, blinds_o_up, blinds_b, blinds_b_up);
    
    % if loop identifies gesture class then selects chosen position
    if x == blinds_o
        position = blinds.blinds_o(n);
        a = convertStringsToChars(position);
        command_str = uint8(a)
    elseif x == blinds_b
        position = blinds.blinds_b(n);
        a = convertStringsToChars(position);
        command_str = uint8(a)
    end
end