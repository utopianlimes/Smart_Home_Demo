% port = 6003
% prod.nrh-smartroom.med.utah.edu
% '10.71.16.4'


% Pairing is only for feedback
% must be tcp

% format to bytes using utf8 

% Message length in bytes + 6'
% first byte is length of message
% Second bytes is message type (1) 1
% 3 & 4 are room number in bytes (02 01)
% 5 & 6 are pin (5555) (15 03)
% Then the command string!
close all; clear all; clc;
load('api_cmd.mat')

remote_address = "prod.nrh-smartroom.med.utah.edu";
remote_port = 6003;
try
    tcp_obj = tcpclient(remote_address, remote_port);
catch 
    disp("Failed to establish TCP connection")
    % tcp_obj = tcpclient("localhost", 30000);
end
room_number = twoByte(513);
room_pin = twoByte(5555);

%% 

for i = 1:length(api_cmd)

messageType = uint8([1]);


msg = uint8(char(api_cmd{i}));
msgLength = uint8([length(msg)+6]);

data = [msgLength, messageType, room_number, room_pin, msg];
% write(tcp_obj,data);

fprintf("Sent the command %d: '%s'\n", i, api_cmd{i})
pause(.1);
% fprintf("Reply: %s\n", char(read(tcp_obj, tcp_obj.NumBytesAvailable)));
pause(3);

end