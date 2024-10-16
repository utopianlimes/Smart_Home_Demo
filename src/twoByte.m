function output = twoByte(roomNumber)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
bits = dec2bin(roomNumber);
while(length(bits) < 16)
    bits = ['0', bits];
end
output = uint8([bin2dec(bits(1:8)), bin2dec(bits(9:16))]);
end