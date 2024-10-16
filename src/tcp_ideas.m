%% dictionary method, key is blinds value is a cell array

blindso = [api_cmd{96} api_cmd{98} api_cmd{99} api_cmd{100} api_cmd{101} api_cmd{102} api_cmd{103} api_cmd{104} api_cmd{105} api_cmd{106} api_cmd{97}]';
blinds_o = dictionary(0, api_cmd{96}, .1, api_cmd{98}, .2, api_cmd{99}, .3, api_cmd{100}, .4, api_cmd{101}, .5, api_cmd{102});

blinds_o;

%commands = struct("blinds_o", "blinds_b");



commands = dictionary;
blinds_oup = {api_cmd{96} api_cmd{98} api_cmd{99} api_cmd{100} api_cmd{101} api_cmd{102} api_cmd{103} api_cmd{104} api_cmd{105} api_cmd{106} api_cmd{97}}';
blinds_bup = {api_cmd{94} api_cmd{116} api_cmd{117} api_cmd{118} api_cmd{119} api_cmd{120} api_cmd{121} api_cmd{122} api_cmd{123} api_cmd{124} api_cmd{95}}';
commands("blinds_o") = {blinds_oup};
commands("blinds_b") = {blinds_bup};


gesture_class = "blinds_o";
gesture_amplitude = 9;

%% structure
blinds_oup = {api_cmd{96} api_cmd{107} api_cmd{108} api_cmd{109} api_cmd{110} api_cmd{111} api_cmd{112} api_cmd{113} api_cmd{114} api_cmd{115} api_cmd{97}}';
blinds_bup = {api_cmd{94} api_cmd{116} api_cmd{117} api_cmd{118} api_cmd{119} api_cmd{120} api_cmd{121} api_cmd{122} api_cmd{123} api_cmd{124} api_cmd{95}}';
blindoup = struct({"blinds_o", "blinds_b"});
blindoup.blinds_b = blinds_bup;
commnad.blinds_o = blinds_oup;
tnt = "blinds_o";

blindoup.tnt

% error to struct from cell/string
%% dictionary part 2
n = .3;
%n = 0:.1:1;
%blinds_oup = [api_cmd{96} api_cmd{107} api_cmd{108} api_cmd{109} api_cmd{110} api_cmd{111} api_cmd{112} api_cmd{113} api_cmd{114} api_cmd{115} api_cmd{97}];
blindoup = dictionary(0, api_cmd{96}, .1, api_cmd{107}, .2, api_cmd{108}, .3, api_cmd{109}, .4, api_cmd{110},...
    .5, api_cmd{111}, .6, api_cmd{112}, .7, api_cmd{113}, .8, api_cmd{114}, .9, api_cmd{115}, 1, api_cmd{97});
%command = dictionary(n, blinds_oup);
%command("blinds_opaque") = [api_cmd{96}];

gesture_class = "blinds_o";
x = convertStringsToChars(gesture_class)
%y = uint8(x)

blinds = struct(x, blindoup)

% gesture = char('blinds_o');
% 
% class(gesture)
% 
% blinds(class('blinds_o'))
% 
% bill = convertStringsToChars(gesture);
% 



%position = blindoup(n)





%%
%look how to index into a cell based on matching values (matching
    %strings)

    %obtain row number of matching commands

    %convert row number(integer) into int-8 form
    
    % Goal is generate_tcp_command(blinds_o, 9) and have opaque blinds move
    % to position 9.



    blindso = [api_cmd{96} api_cmd{98} api_cmd{99} api_cmd{100} api_cmd{101} api_cmd{102} api_cmd{103} api_cmd{104} api_cmd{105} api_cmd{106} api_cmd{97}]'
    %blinds.b = [api_cmd{94} api_cmd{116} api_cmd{117} api_cmd{118} api_cmd{119} api_cmd{120} api_cmd{121} api_cmd{122} api_cmd{123} api_cmd{124} api_cmd{125}]'
    
    gesture_class = "blinds_o"
    x = convertStringsToChars(gesture_class)
    y = uint8(x)
    % change from char to int

    % create a dictionary with "blinds_o" and "blinds_b" as the key, (focus
    % on the "up" commands) and the positions as the values

    % gesture amplitude will be 0-1 floating point, not whole integer from
    % 0-10, make it round to the nearest .1 position ex .75 -> .8

    %g_amp = blinds.o(gesture_amplitude)
    
    commands = dictionary;
    commands("blinds_o") = {{api_cmd{96} api_cmd{98} api_cmd{99} api_cmd{100} api_cmd{101} api_cmd{102} api_cmd{103} api_cmd{104} api_cmd{105} api_cmd{106} api_cmd{97}}};
    commands("blinds_b") = {{api_cmd{94} api_cmd{116} api_cmd{117} api_cmd{118} api_cmd{119} api_cmd{120} api_cmd{121} api_cmd{122} api_cmd{123} api_cmd{124} api_cmd{95}}};
    

    %%
    gesture_class = "blinds_b";
    gesture_amplitude = .75;
    
    x = convertStringsToChars(gesture_class);
    n = round(gesture_amplitude, 1);
    blinds_o = 'blinds_o';
    blinds_b = 'blinds_b';
    blind_o_up = dictionary(0, api_cmd{96}, .1, api_cmd{107}, .2, api_cmd{108}, .3, api_cmd{109}, .4, api_cmd{110},...
            .5, api_cmd{111}, .6, api_cmd{112}, .7, api_cmd{113}, .8, api_cmd{114}, .9, api_cmd{115}, 1, api_cmd{97});
    blind_b_up = dictionary(0, api_cmd{94}, .1, api_cmd{125}, .2, api_cmd{126}, .3, api_cmd{127}, .4, api_cmd{128},...
            .5, api_cmd{129}, .6, api_cmd{130}, .7, api_cmd{131}, .8, api_cmd{132}, .9, api_cmd{133}, 1, api_cmd{95});
    blinds = struct(blinds_o, blind_o_up, blinds_b, blind_b_up);
    
    if x == blinds_o
        position = blinds.blinds_o(n);
        a = convertStringsToChars(position);
        b = uint8(a)
    elseif x == blinds_b
        position = blinds.blinds_b(n);
        a = convertStringsToChars(position);
        b = uint8(a)
    end