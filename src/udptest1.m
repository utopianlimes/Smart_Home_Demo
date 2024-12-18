%% soon to be outdated

% Receiver (Session 1)

% Create a UDP object to listen for incoming data on a specific port
receiver = udp('localhost', 'LocalPort', 5000);  % Replace 'localhost' with the actual IP if on separate machines

% Open the UDP connection
fopen(receiver);

% Set a timeout if needed
receiver.Timeout = 10;  % Timeout in seconds

disp('Waiting for UDP message...');

% Read incoming data (will block until data is received)
receivedData = fscanf(receiver, '%s');  % Use appropriate format based on data type
disp(['Received data: ' receivedData]);

% Close the connection
fclose(receiver);
delete(receiver);
clear receiver;

%% modern method
% Receiver (Session 1)
% Notes:
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

% Display status
disp('Waiting for UDP message...');

% Read incoming data (blocking call until data is received)
% This will read a maximum of 1024 bytes. Adjust size as needed.
receivedData = read(receiver, 1024, "char");

% Display received data
disp(['Received data: ' receivedData]);

% Clean up
clear receiver;

%%
% Receiver (Session 1)

% Receiver (Session 1)
try
    % Create a UDP port object for receiving data on a specific port
    receiver = udpport("LocalPort", 5000);  % Replace 5000 with your chosen port
    
    % Set a timeout for the read operation (in seconds)
    receiver.Timeout = 5;  % Timeout after 5 seconds (you can adjust this value)
    
    % Display status
    disp('Waiting for UDP message...');
    
    % Wait for data to be available
    while receiver.BytesAvailable == 0
        pause(0.1);  % Wait for a short time before checking again
    end
    
    % Read all available data (no need to specify the number of bytes)
    receivedData = read(receiver, receiver.BytesAvailable, "char");
    
    % If we received data, display it
    disp(['Received data: ' receivedData]);

catch ME
    % If no data is received or an error occurs, display a warning
    if strcmp(ME.identifier, 'MATLAB:udpport:TimeoutExceeded')
        warning('No data received within the timeout period of %.1f seconds.', receiver.Timeout);
    elseif strcmp(ME.identifier, 'MATLAB:udpport:ReadWarning')
        warning('Data read was incomplete or not received as expected.');
    else
        % Display other errors that might occur
        rethrow(ME);  % Re-throw the error for debugging
    end
end

% Clean up the UDP port object
clear receiver;
