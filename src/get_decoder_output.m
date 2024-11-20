function [gesture_class, gesture_amplitude, fbd_state] = get_decoder_output()
% This function returns 2 values from FBD
% class: The class of the performed gesture
% amplitude: The intensity of the EMG signals

fbd_state = "Gesture Detected";

%%%%%%%%% UDP Receiver Notes:  %%%%%%%%%%%%
%   - Receiver: The LocalPort is where your receiver listens for incoming UDP packets.
%   - Sender: The RemoteHost and RemotePort specify where the sender is sending the data.
%   - The read function in the receiver code is blocking by default, 
%       meaning it will wait until data is received before continuing.
%       You can adjust the timeout with the Timeout property on the udpport object 
%       if needed:
%   - You can specify the data type to be sent or received. 
%       In this example, I used "char", which is suitable for string data. 
%       If you're working with binary data, you can adjust this to "uint8" 
%       or another appropriate format. 
%   - Ensure the firewall settings on the machines (if running on different
%       machines) allow traffic on the specified UDP port.
%   - Use the actual IP address of the receiver in place of "localhost" in 
%       the sender code if the sessions are on different machines.


% Create a UDP port object for receiving data on a specific port
receiver = udpport("LocalPort", 5000);  % Replace 5000 with your chosen port

% Set a timeout for the read operation (in seconds)
receiver.Timeout = 5;  % Timeout after 5 seconds (you can adjust this value)

% Display status
disp('Waiting for UDP message...');
    
% Read all available data (no need to specify the number of bytes)
receivedData = read(receiver, 1024, "char");

% If we received data, display it
disp(['Received data: ' receivedData]);

if isempty(receivedData)
    receivedData = 'emptycommand 0';
    warning("no command received")
end

% Clean up the UDP port object
clear receiver;

%%%%%% Parsing receivedData from UDP %%%%%%%%%%

% Two Options: split (simple), textscan (more complex)
% keeping both in case split doesn't work as we test more commands

% split

% Split the received string into a cell array of two elements
parts = split(receivedData);

% Extract the first part (the string)
gesture_class = parts{1};

% Extract the second part and convert it to a numeric value
gesture_amplitude = str2double(parts{2});

% Display the results
disp(gesture_class);  
disp(gesture_amplitude);         

%textscan

% Use textscan to extract two parts, one as a string and the other as a number
%result = textscan(receivedData, '%s %f');

% Extract the string and the number
% gesture_class = result{1}{1};             % The string
% gesture_amplitude = result{2};            % The number 

% Display the results
%disp(gesture_class);  
%disp(gesture_amplitude);        



end