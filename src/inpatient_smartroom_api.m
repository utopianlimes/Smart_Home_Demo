classdef inpatient_smartroom_api < handle
    % The inpatient_smartroom_api is able to send commands to the smart
    % room devices inside any inpatient room of the Neilsen Rehabilitation
    % Hospital. These commands can be used to control the lights, blinds,
    % thermostat and other aspects of the room.
    %
    % These commands are able to control ANY of the inpatient rooms of the
    % NRH, including the ones with patients staying in them. DO NOT UNDER
    % ANY CIRCUMSTANCE USE THIS API OUTSIDE OF ITS INTENDED PURPOSE. Use
    % should be limited to room 513 and 515 unless testing it out with a
    % patient in one of their rooms. Please use responsibly.
    %
    % Connor Olsen
    % University of Utah NeuroRobotics Lab, 2022

    properties
        t; ready, room, pin, api_cmds, messageType
    end

    methods
        function obj = inpatient_smartroom_api(roomNumber)
            if nargin ~= 1
                error("Please give a desired room");
            end
            changeRoom(obj, roomNumber);
            obj.pin = obj.twoByte(5555);
            obj.messageType = 1;
            loadCommands(obj);
            init(obj);
        end

        function changeRoom(obj, roomNumber)
            obj.room = obj.twoByte(roomNumber);
        end

        function openBlinds(obj)
            sendCommand(obj, "BLINDS_ALL_OPEN");
        end

        function closeBlinds(obj)
            sendCommand(obj, "BLINDS_ALL_CLOSE");
        end

        function blinds(obj, section, height)
            switch lower(string(height))
                case "open"
                    height = "OPEN";
                case "close"
                    height = "CLOSE";
            end
            switch lower(string(section))
                case "opaque"
                    section = "OPAQUE";
                case "blackout"
                    section = "BLKOUT";
                case "both"
                    section = "ALL";
            end
            cmd = sprintf("BLINDS_%s_%s", section, height);
            sendCommand(obj, cmd);
        end

        function lights(obj, section, varargin)
            if nargin == 3
                intensity = round(varargin{1});
                if intensity > 10
                    intensity = 10;
                elseif intensity < 0
                    intensity = 0;
                end
            end
            switch lower(string(section))
                case "wall"
                    section = 0;
                case "door"
                    section = 1;
                case "bed"
                    section = 2;
                case "bathroom"
                    section = 3;
                case "surgery"
                    section = 4;
                case "on"
                    specificCommand(obj, [10, 12, 14, 16, 18]);
                case "off"
                    specificCommand(obj, [11, 13, 15, 17, 19]);
                otherwise
                    error("Please specify a real section of lights ('door', 'bed', 'bathroom', 'surgery')");
            end
            if isnumeric(section)
                cmd = sprintf("LTG_DIM_%d_%d", section, intensity);
                sendCommand(obj, cmd);
            end
        end
        
        function raiseTemp(obj)
            sendCommand(obj, "HVAC_TEMP_UP");
        end

        function lowerTEMP(obj)
            sendCommand(obj, "HVAC_TEMP_DN");
        end

        function temp(obj, new_temp)
            if new_temp<67 || new_temp>79
                error("Temperature must be between 67 and 79 degrees Fahrenheit.");
            elseif mod(new_temp*4, 2) ~= 0
                error("Temperature must be a positive number that is an integer or ends in .5");
            end
            
            if new_temp>=70 && new_temp<=75
                if mod(new_temp*2, 2)==0
                    cmd = sprintf("HVAC_TEMP_SETPOINT_TO_%d", new_temp);
                    sendCommand(obj, cmd);
                elseif mod(new_temp*2, 2) == 1
                    idx = strlength("HVAC_TEMP_SETPOINT_TO_") + 4;
                    cmd = extractBetween(sprintf("HVAC_TEMP_SETPOINT_TO_%f", new_temp), 1, idx);
                    sendCommand(obj, cmd);
                end
            elseif new_temp<70
                steps = (70-new_temp)*2;
                for i = 1:steps
                    sendCommand(obj, "HVAC_TEMP_DN");
                end
            elseif new_temp>75
                steps = (new_temp-75)*2;
                for i = 1:steps
                    sendCommand(obj, "HVAC_TEMP_UP");
                end
            end
        end

        function specificCommand(obj, cmd)
            for i = 1:length(cmd)
                sendCommand(obj, obj.api_cmds(cmd(i)));
            end
        end

        function displayCommands(obj)
            for i = 1:length(obj.api_cmds)
                fprintf("%d) %s\n",i, obj.api_cmds(i));
            end
        end
    end

    methods (Hidden=true)
        function obj = init(obj, varargin)
            ip = "prod.nrh-smartroom.med.utah.edu";
            port = 6003;
            obj.t = tcpclient(ip, port);
            %             configureCallback(obj.t, 'byte', 1, @obj.read)
            fprintf("Connected to Smart Room!\n");
            obj.ready = 1;
        end

        function sendCommand(obj, msg)
            msg = uint8(char(msg));
            msgLength = uint8(length(msg)+6);
            msg_concatenated = [msgLength, obj.messageType, obj.room, obj.pin, msg];
            write(obj.t, msg_concatenated);
        end

        function output = twoByte(obj, num)
            bits = dec2bin(num);
            while(length(bits) < 16)
                bits = ['0', bits];
            end
            output = uint8([bin2dec(bits(1:8)), bin2dec(bits(9:16))]);
        end

        function read(obj)
            try
                byteCount = obj.t.NumBytesAvailable;
                reply = read(obj.t, byteCount);
                fprintf("%s"\n, reply);
            catch
                error("TCP Error")
            end
        end
        function loadCommands(obj)
            obj.api_cmds = ["ATV_RIGHT", "ATV_LEFT", "ATV_UP", "ATV_DOWN", "ATV_SELECT", "ATV_MENU",...
                "ATV_PLAY", "LTG_FULL", "LTG_DARK", "LTG_ON_0", "LTG_OFF_0", "LTG_ON_1", "LTG_OFF_1",...
                "LTG_ON_2", "LTG_OFF_2", "LTG_ON_3", "LTG_OFF_3", "LTG_ON_4", "LTG_OFF_4", "LTG_READ",...
                "LTG_SOFT", "LTG_TV", "LTG_DIM_0_RAISE", "LTG_DIM_0_LOWER", "LTG_DIM_1_RAISE",...
                "LTG_DIM_1_LOWER", "LTG_DIM_2_RAISE", "LTG_DIM_2_LOWER", "LTG_DIM_3_RAISE",...
                "LTG_DIM_3_LOWER", "LTG_DIM_4_RAISE", "LTG_DIM_4_LOWER", "LTG_DIM_0_0", "LTG_DIM_0_1",...
                "LTG_DIM_0_2", "LTG_DIM_0_3", "LTG_DIM_0_4", "LTG_DIM_0_5", "LTG_DIM_0_6", "LTG_DIM_0_7",...
                "LTG_DIM_0_8", "LTG_DIM_0_9", "LTG_DIM_0_10", "LTG_DIM_1_0", "LTG_DIM_1_1", "LTG_DIM_1_2",...
                "LTG_DIM_1_3", "LTG_DIM_1_4", "LTG_DIM_1_5", "LTG_DIM_1_6", "LTG_DIM_1_7", "LTG_DIM_1_8",...
                "LTG_DIM_1_9", "LTG_DIM_1_10", "LTG_DIM_2_0", "LTG_DIM_2_1", "LTG_DIM_2_2", "LTG_DIM_2_3",...
                "LTG_DIM_2_4", "LTG_DIM_2_5", "LTG_DIM_2_6", "LTG_DIM_2_7", "LTG_DIM_2_8", "LTG_DIM_2_9",...
                "LTG_DIM_2_10", "LTG_DIM_3_0", "LTG_DIM_3_1", "LTG_DIM_3_2", "LTG_DIM_3_3", "LTG_DIM_3_4",...
                "LTG_DIM_3_5", "LTG_DIM_3_6", "LTG_DIM_3_7", "LTG_DIM_3_8", "LTG_DIM_3_9", "LTG_DIM_3_10",...
                "LTG_DIM_4_0", "LTG_DIM_4_1", "LTG_DIM_4_2", "LTG_DIM_4_3", "LTG_DIM_4_4", "LTG_DIM_4_5",...
                "LTG_DIM_4_6", "LTG_DIM_4_7", "LTG_DIM_4_8", "LTG_DIM_4_9", "LTG_DIM_4_10", "DOOR_OPEN",...
                "DOOR_CLOSE", "DOOR_OPEN_HOLD", "DOOR_OPEN_PARTIAL", "BLINDS_ALL_OPEN", "BLINDS_ALL_CLOSE",...
                "BLINDS_BLKOUT_OPEN", "BLINDS_BLKOUT_CLOSE", "BLINDS_OPAQUE_OPEN", "BLINDS_OPAQUE_CLOSE",...
                "BLINDS_OPAQUE_DOWN_1", "BLINDS_OPAQUE_DOWN_2", "BLINDS_OPAQUE_DOWN_3", "BLINDS_OPAQUE_DOWN_4",...
                "BLINDS_OPAQUE_DOWN_5", "BLINDS_OPAQUE_DOWN_6", "BLINDS_OPAQUE_DOWN_7", "BLINDS_OPAQUE_DOWN_8",...
                "BLINDS_OPAQUE_DOWN_9", "BLINDS_OPAQUE_UP_1", "BLINDS_OPAQUE_UP_2", "BLINDS_OPAQUE_UP_3",...
                "BLINDS_OPAQUE_UP_4", "BLINDS_OPAQUE_UP_5", "BLINDS_OPAQUE_UP_6", "BLINDS_OPAQUE_UP_7",...
                "BLINDS_OPAQUE_UP_8", "BLINDS_OPAQUE_UP_9", "BLINDS_BLKOUT_DOWN_1", "BLINDS_BLKOUT_DOWN_2",...
                "BLINDS_BLKOUT_DOWN_3", "BLINDS_BLKOUT_DOWN_4", "BLINDS_BLKOUT_DOWN_5", "BLINDS_BLKOUT_DOWN_6",...
                "BLINDS_BLKOUT_DOWN_7", "BLINDS_BLKOUT_DOWN_8", "BLINDS_BLKOUT_DOWN_9", "BLINDS_BLKOUT_UP_1",...
                "BLINDS_BLKOUT_UP_2", "BLINDS_BLKOUT_UP_3", "BLINDS_BLKOUT_UP_4", "BLINDS_BLKOUT_UP_5",...
                "BLINDS_BLKOUT_UP_6", "BLINDS_BLKOUT_UP_7", "BLINDS_BLKOUT_UP_8", "BLINDS_BLKOUT_UP_9",...
                "HVAC_TEMP_UP", "HVAC_TEMP_DN", "HVAC_TEMP_CURRENT", "HVAC_TEMP_SETPOINT", "HVAC_TEMP_SETPOINT_TO_70",...
                "HVAC_TEMP_SETPOINT_TO_70.5", "HVAC_TEMP_SETPOINT_TO_71", "HVAC_TEMP_SETPOINT_TO_71.5",...
                "HVAC_TEMP_SETPOINT_TO_72", "HVAC_TEMP_SETPOINT_TO_72.5", "HVAC_TEMP_SETPOINT_TO_73",...
                "HVAC_TEMP_SETPOINT_TO_73.5", "HVAC_TEMP_SETPOINT_TO_74", "HVAC_TEMP_SETPOINT_TO_74.5",...
                "HVAC_TEMP_SETPOINT_TO_75", "FAN_ON", "FAN_OFF", "FAN_SET_SPEED1", "FAN_SET_SPEED2",...
                "FAN_SET_SPEED3", "TV_POWER", "TV_CH_UP", "TV_CH_DN", "TV_CH0", "TV_CH1", "TV_CH2", "TV_CH3",...
                "TV_CH4", "TV_CH5", "TV_CH6", "TV_CH7", "TV_CH8", "TV_CH9", "TV_SOURCE_CAST", "TV_SOURCE_HDMI",...
                "TV_SOURCE_CABLE", "TV_SOURCE_AUX", "SBAR_WIPE", "SBAR_VOL_UP", "SBAR_VOL_DN", "SBAR_VOL_000",...
                "SBAR_VOL_005", "SBAR_VOL_010", "SBAR_VOL_015", "SBAR_VOL_020", "SBAR_VOL_025", "SBAR_VOL_030",...
                "SBAR_VOL_035", "SBAR_VOL_040", "SBAR_VOL_045", "SBAR_VOL_050", "SBAR_VOL_055", "SBAR_VOL_060",...
                "SBAR_VOL_065", "SBAR_VOL_070", "SBAR_VOL_075", "SBAR_VOL_MUTE_VOICE", "SBAR_VOL_UNMUTE_VOICE",...
                "SBAR_VOL_MUTE_BP", "SBAR_VOL_UNMUTE", "SBAR_VOL_BLUETOOTH", "SBAR_VOL_TV", "SBAR_VOL_INPUT",...
                "SBAR_VOL_ON", "SBAR_VOL_OFF", "SBAR_PAIR", "SBAR_PLAY", "SBAR_SKIP_FW", "SBAR_SKIP_BW", "GET_STATUS",...
                "PAIR_S", "PAIR_B", "WB_POWER", "WB_DIM", "WB_BRIGHT", "RESETPIN"];
        end
    end
end
