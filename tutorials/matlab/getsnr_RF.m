function [S2N_max, S2N_phase_arrival]= getsnr_RF(trace, time, dt, Taup_phase_arrival)
% Find S2N for teleseismic arrivals based on S2N of envelopes, plus time
% of maximum S2N. Adapted from scripts modified by David Abt, Ved Lekic, 
% Emily Hopper, most recently by Eva Golos, 7/2025 

% Inputs:
% trace: waveform containing arrival
% time: corresponding to sampling of waveform
% dt: Time step (1/sampling rate)
% Taup_phase_arrival: Arrival time predicted by TauP

% Outputs:
% S2N_max: signal-to-noise ratio
% S2N_phase_arrival: ar


pre_phase_t     = 150;    post_phase_t    = 150; % Generous time window
Taup_phase_wl   = 30;    	% Arbitrary phase window length for Taup estimates
swl             = 5;        % "signal" window length (sec)
nwl             = 20;   	% "noise" window length (sec)
s2n_phase_wl    = 20;       % Arbitrary phase window length for S2N
search_range    = 15;       % Maximum time from Tau-P arrival to find max S2N

% Search for peak SNR within specified time window.
Taup_phase_window           = Taup_phase_arrival+[0 Taup_phase_wl];
            
% Generate an envelope function around the taup window and
% calculate signal:noise for a pair of moving windows to
% objectively find the arrival time.
S2N_range   = search_range;
indx_envl   = find(time>=(Taup_phase_arrival-S2N_range-pre_phase_t) & ...
    time<=(Taup_phase_arrival+S2N_range+post_phase_t));
indx_big   = find(time>=(Taup_phase_arrival-pre_phase_t) & ...
    time<=(Taup_phase_arrival+post_phase_t));
indx_S2N    = find(time>=(Taup_phase_arrival-S2N_range) & ...
    time<=(Taup_phase_arrival+S2N_range));
indx_search = find(time>=(Taup_phase_arrival-search_range) & ...
    time<=(Taup_phase_arrival+search_range));
nwlp        = nwl/dt;         % number of sample points in noise window
swlp        = swl/dt;         % number of sample points in signal window

if ~isempty(indx_search) && indx_S2N(1)>indx_envl(1)+double(nwlp) && ...
                indx_S2N(end)<indx_envl(end)-swlp+1 && ~isempty(trace)
            
            Hilbert    	= hilbert(trace(indx_envl));
            Envelope  	= abs(Hilbert);
            time_envl  	= time(indx_envl);
            indx_big    = uint16([max(find(indx_envl==indx_big(1)),1+nwlp) min(find(indx_envl==indx_big(end)),length(indx_envl)-swlp+1)]);
            indx_search	= [find(indx_envl==indx_search(1)) find(indx_envl==indx_search(end))];
            S2N         = zeros(size(Envelope));
            for iw=indx_big(1):indx_big(2)
                Noise   = mean(Envelope(iw-nwlp:iw-1));
                Signal  = mean(Envelope(iw:iw+swlp-1));
                S2N(iw) = Signal/Noise;
            end



            HWL             = uint16(swl);  % Hanning window length
            HW              = hann(HWL/dt);	% Hanning window to be convolved with the S2N time series
            S2N_hann_temp   = conv(S2N,HW);	% Filtered S2N
            hann_buff       = uint16((HWL/2)/dt);
            S2N_hann        = S2N_hann_temp(hann_buff:end-hann_buff);
            S2N_filt_norm   = S2N_hann/max(S2N_hann)*max(S2N);
            
            % Find the max S2N within the test window (some distance around the
            % Taup predicted arrival)
            S2N_max_indx = uint16(find(S2N_filt_norm==max(S2N_filt_norm(indx_search(1):indx_search(2)))));
            if length(S2N_max_indx)>1
                if length(S2N_max_indx)==2 && S2N_max_indx(1)==S2N_max_indx(2)+1
                    S2N_max_indx = S2N_max_indx(1);
                else
                    S2N_max_indx    = 1;
                    wrong='More than one S2N peak';
                    S2N_filt_norm   = -666;
                end
            elseif isempty(S2N_max_indx)
                S2N_max_indx    = 1;
                wrong='No S2N peak found';
                S2N_filt_norm   = -666;
            end

            % Maximum of S2N time series, and timing of max.
            S2N_max = S2N_filt_norm(S2N_max_indx);
            S2N_phase_arrival       = time_envl(S2N_max_indx-2/dt);
                
                
                
end