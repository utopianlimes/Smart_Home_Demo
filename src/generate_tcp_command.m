function command_str = generate_tcp_command(gesture_class, gesture_amplitude)
    % This function outputs a command in the form of: %s%D- tcp-ip_address
    load("C:\Users\tjk90\Box\JAGLAB\Projects\Demo-Smart-Room\api_cmd.mat")
    x = convertStringsToChars(gesture_class);
    n = round(gesture_amplitude, 1);    % rounds amplitude to tenth decimal place
    
    % gesture classes
    blinds_o = 'blinds_o';
    blinds_b = 'blinds_b';
    ltg_on = 'ltg_on';          % clarify difference between on/off and full/dark
    ltg_off = 'ltg_off';
    ltg_dim_raise = 'ltg_dim_raise'; % amplitude decides which ltg
    ltg_dim_lower = 'ltg_dim_lower'; % amplitude decides which ltg
    ltg_dim_0 = 'ltg_dim_0';
    ltg_dim_1 = 'ltg_dim_1';
    ltg_dim_2 = 'ltg_dim_2';
    ltg_dim_3 = 'ltg_dim_3';
    ltg_dim_4 = 'ltg_dim_4';
    door = 'door';              % all door commands are just door gesture class
    hvac_temp = 'hvac_temp';
    fan = 'fan';                % all fan commands, does setting speed automatically turn it on?
    tv_power = 'tv_power';
    tv_channel = 'tv_channel';
    tv_source = 'tv_source';
    sbar_pow = 'sbar_power';
    sbar_vol = 'sbar_vol';
 


    % gesture class states and positions

    % blinds
    blinds_o_up = dictionary(0, api_cmd{96}, .1, api_cmd{107}, .2, api_cmd{108}, .3, api_cmd{109}, .4, api_cmd{110},...
            .5, api_cmd{111}, .6, api_cmd{112}, .7, api_cmd{113}, .8, api_cmd{114}, .9, api_cmd{115}, 1, api_cmd{97});
    blinds_b_up = dictionary(0, api_cmd{94}, .1, api_cmd{125}, .2, api_cmd{126}, .3, api_cmd{127}, .4, api_cmd{128},...
            .5, api_cmd{129}, .6, api_cmd{130}, .7, api_cmd{131}, .8, api_cmd{132}, .9, api_cmd{133}, 1, api_cmd{95});
    
    % ltg
    ltg_on_x = dictionary(0, api_cmd{10}, 1, api_cmd{12}, 2, api_cmd{14}, 3, api_cmd{16}, 4, api_cmd{18});
    ltg_off_x = dictionary(0, api_cmd{11}, 1, api_cmd{13}, 2, api_cmd{15}, 3, api_cmd{17}, 4, api_cmd{19});

    ltg_raise_x = dictionary(0, api_cmd{23}, 1, api_cmd{25}, 2, api_cmd{27}, 3, api_cmd{29}, 4, api_cmd{31});
    ltg_lower_x = dictionary(0, api_cmd{24}, 1, api_cmd{26}, 2, api_cmd{28}, 3, api_cmd{30}, 4, api_cmd{32});

    ltg_dim_0_num = dictionary(0, api_cmd{33}, .1, api_cmd{34}, .2, api_cmd{35}, .3, api_cmd{36}, .4, api_cmd{37}, ...
        .5, api_cmd{38}, .6, api_cmd{39}, .7, api_cmd{40}, .8, api_cmd{41}, .9, api_cmd{42}, 1, api_cmd{43});
    ltg_dim_1_num = dictionary(0, api_cmd{44}, .1, api_cmd{45}, .2, api_cmd{46}, .3, api_cmd{47}, .4, api_cmd{48}, ...
        .5, api_cmd{49}, .6, api_cmd{50}, .7, api_cmd{51}, .8, api_cmd{52}, .9, api_cmd{53}, 1, api_cmd{54});
    ltg_dim_2_num = dictionary(0, api_cmd{55}, .1, api_cmd{56}, .2, api_cmd{57}, .3, api_cmd{58}, .4, api_cmd{59}, ...
        .5, api_cmd{60}, .6, api_cmd{61}, .7, api_cmd{62}, .8, api_cmd{63}, .9, api_cmd{64}, 1, api_cmd{65});
    ltg_dim_3_num = dictionary(0, api_cmd{66}, .1, api_cmd{67}, .2, api_cmd{68}, .3, api_cmd{69}, .4, api_cmd{70}, ...
        .5, api_cmd{71}, .6, api_cmd{72}, .7, api_cmd{73}, .8, api_cmd{74}, .9, api_cmd{75}, 1, api_cmd{76});
    ltg_dim_4_num = dictionary(0, api_cmd{77}, .1, api_cmd{78}, .2, api_cmd{79}, .3, api_cmd{80}, .4, api_cmd{81}, ...
        .5, api_cmd{82}, .6, api_cmd{83}, .7, api_cmd{84}, .8, api_cmd{85}, .9, api_cmd{86}, 1, api_cmd{87});
    
    % door
    door_pos = dictionary(0, api_cmd{89}, .5, api_cmd{91}, 1, api_cmd{88});

    % hvac
    hvac_set = dictionary(0, api_cmd{135}, 1, api_cmd{134}, 70, api_cmd{138}, 70.5, api_cmd{139}, 71, api_cmd{140}, ...
        71.5, api_cmd{141}, 72, api_cmd{142}, 72.5, api_cmd{143}, 73, api_cmd{144}, 73.5, api_cmd{145}, 74, api_cmd{146}, ...
        74.5, api_cmd{147}, 75, api_cmd{148});

    %fan
    fan_set = dictionary(0, api_cmd{150}, 1, api_cmd{151}, 2, api_cmd{152}, 3, api_cmd{153});

    %tv
    tv = dictionary(1, api_cmd{154});
    tv_num = dictionary(0, api_cmd{157}, 1, api_cmd{158}, 2, api_cmd{159}, 3, api_cmd{160}, 4, api_cmd{161}, ...
        5, api_cmd{162}, 6, api_cmd{163}, 7, api_cmd{164}, 8, api_cmd{165}, 9, api_cmd{166}, 10, api_cmd{156}, ...
        11, api_cmd{155});           % 10 is channel down, 11 is channel up
    tv_src = dictionary(1, api_cmd{167}, 2, api_cmd{168}, 3, api_cmd{169}, 4, api_cmd{170});
    
    %soundbar
    sbar_power = dictionary(0, api_cmd{198}, 1, api_cmd{197});    % volume off and on
    sbar_volume = dictionary(0, api_cmd{174}, 5, api_cmd{175}, 10, api_cmd{176}, 15, api_cmd{177}, 20, api_cmd{178}, ...
        25, api_cmd{179}, 30, api_cmd{180}, 35, api_cmd{181}, 40, api_cmd{182}, 45, api_cmd{183}, 50, api_cmd{184},...
        55, api_cmd{185}, 60, api_cmd{186}, 65, api_cmd{187}, 70, api_cmd{188}, 75, api_cmd{189});

    % gesture class structures
    
    blinds = struct(blinds_o, blinds_o_up, blinds_b, blinds_b_up);
    



    % if loop identifies gesture class then selects chosen position
    if strcmp(x, blinds_o)
        position = blinds.blinds_o(n);
        a = convertStringsToChars(position);
        command_str = uint8(a);
    elseif x == blinds_b
        position = blinds.blinds_b(n);
        a = convertStringsToChars(position);
        command_str = uint8(a);
    elseif x == ltg_on
        position = ltg_on_x(n);
        a = convertStringsToChars(position);
        command_str = uint8(a);
     
    elseif x == ltg_off
        position = ltg_off_x(n);
        a = convertStringsToChars(position);
        command_str = uint8(a);
    elseif x == ltg_dim_raise
        position = ltg_raise_x(n);
        a = convertStringsToChars(position);
        command_str = uint8(a);
    elseif x == ltg_dim_lower
        position = ltg_lower_x(n);
        a = convertStringsToChars(position);
        command_str = uint8(a);
    elseif x == ltg_dim_0
        position = ltg_dim_0_num(n);
        a = convertStringsToChars(position);
        command_str = uint8(a);
    elseif x == ltg_dim_1
        position = ltg_dim_1_num(n);
        a = convertStringsToChars(position);
        command_str = uint8(a);
    elseif x == ltg_dim_2
        position = ltg_dim_2_num(n);
        a = convertStringsToChars(position);
        command_str = uint8(a);
    elseif x == ltg_dim_3
        position = ltg_dim_3_num(n);
        a = convertStringsToChars(position);
        command_str = uint8(a);
    elseif x == ltg_dim_4
        position = ltg_dim_4_num(n);
        a = convertStringsToChars(position);
        command_str = uint8(a);
    elseif x == door
        position = door_pos(n);
        a = convertStringsToChars(position);
        command_str = uint8(a);
    elseif x == hvac_temp
        position = hvac_set(n);
        a = convertStringsToChars(position);
        command_str = uint8(a);
    elseif x == fan
        position = fan_set(n);
        a = convertStringsToChars(position);
        command_str = uint8(a);
    elseif x == tv_power
        position = tv(n);
        a = convertStringsToChars(position);
        command_str = uint8(a);
    elseif x == tv_channel
        position = tv_num(n);
        a = convertStringsToChars(position);
        command_str = uint8(a);
    elseif x == tv_source
        position = tv_src(n);
        a = convertStringsToChars(position);
        command_str = uint8(a);
    elseif x == sbar_pow
        position = sbar_power(n);
        a = convertStringsToChars(position);
        command_str = uint8(a);
    elseif x == sbar_vol
        position = sbar_volume(n);
    a = convertStringsToChars(position);
    command_str = uint8(a);
    end
end



% UNUSED CMDS :
% ATV_RIGHT
% ATV_LEFT
% ATV_UP
% ATV_DOWN
% ATV_SELECT
% ATV_MENU
% ATV_PLAY
% LTG_FULL
% LTG_DARK
% LTG_READ
% LTG_SOFT
% LTG_TV
% HVAC_TEMP_CURRENT
% HVAC_TEMP_SETPOINT       is this a separate command from the other setpoints?
% DOOR_OPEN_HOLD
% BLINDS_ALL_OPEN           add as a new structure blinds.all with just two commands?
% BLINDS_ALL_CLOSE
% all BLINDS_OPAQUE_DOWN and BLINDS_BLKOUT_DOWN
% FAN_ON   this felt redundant as setting fan can turn it on?
% SBAR_WIPE
% SBAR_UP
% SBAR_DN
% SBAR_MUTE_VOICE
% SBAR_UNMUTE_VOICE
% SBAR_MUTE_BP
% SBAR_UNMUTE
% SBAR_BLUETOOTH
% SBAR_TV
% SBAR_INPUT
% SBAR_PAIR
% SBAR_PLAY
% SBAR_SKIP_FW
% SBAR_SKIP_BW
% GET_STATUS
% PAIR_S
% PAIR_B
% WB_POWER
% WB_DIM
% WB_BRIGHT
% RESETPIN

% the main reason for unused commands is how to associate amplitude with
% each command, should it just be arbitrary like for ltg left right and up?
% see tv source for example of this