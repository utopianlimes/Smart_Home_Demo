function [gesture_class, gesture_amplitude] = get_decoder_output()
% This function returns 2 values from FBD
% class: The class of the performed gesture
% amplitude: The intensity of the EMG signals
gesture_class = "Lights on";
gesture_amplitude = rand(1);
end