% UDP SENDER FORMAT

%% soon to be outdated

% Sender (Session 2)

% Create a UDP object to send data to a specific IP and port
sender = udp('localhost', 'RemotePort', 5000);  % Replace 'localhost' with the IP address of the receiver

% Open the UDP connection
fopen(sender);

% Send some data (e.g., a string message)
dataToSend = 'blinds_b 3';
fprintf(sender, '%s', dataToSend);

% Close the connection
fclose(sender);
delete(sender);
clear sender;

%% modern method

% Sender (Session 2)

% Create a UDP port object for sending data
sender = udpport;  % No need to specify 'RemoteHost' when creating the object

% Specify the remote host and port when using write
remoteHost = 'localhost';  % Replace with the IP of the receiver if on separate machines
remotePort = 5000;  % Port number where the receiver is listening

% Send data (e.g., a string message)
dataToSend = 'blinds_o 0.2';
write(sender, dataToSend, "char", remoteHost, remotePort);

% Clean up the UDP port object
clear sender;
