% Plot SNR information of P and S teleseismic wave arrivals for BADGER data.
% Waveform files are too large to store, please contact Eva Golos (golos@wisc.edu) 
% for access to raw waveforms surrounding arrivals, in format required
% here.

net= 'BA'; % Network name is '27' with FDSN, but here we need a string that
% starts with a letter.

load BA/Networks.mat 
load BA/Events.mat
stas= fieldnames(Networks.(net));
nst= length(stas);
evs_precise= fieldnames(Events);

%  To find event info -- need to match that event later on.
% This is more complicated for the BA directory because data were
% originally stored in 2-hour files, not requested from DMC.
MatchMe= cell(length(evs_precise),1);
for iii=1:length(evs_precise)
    Ev_to_match= Events.(evs_precise{iii});
    MatchMe{iii}= ['EQ_',replace(Ev_to_match.Event_ID,'.','_')];
end

% For BA, only basin stations
SNR_all_P= []; SNR_all_S= [];
SNR_mean_P= zeros(nst,1); SNR_mean_S= zeros(nst,1);
SNR_std_P= zeros(nst,1); SNR_std_S= zeros(nst,1);
SNR_allstns_P= cell(nst,1); SNR_allstns_S= cell(nst,1);
Q5_all_P= zeros(nst,1); Q95_all_P= zeros(nst,1);
Q5_all_S= zeros(nst,1); Q95_all_S= zeros(nst,1);
for i=1:nst
    load([net,'/',stas{i},'/Waveform_Data_1_33_allS2N.mat']);
    evs= fieldnames(All_Waveform_Data);
    SNR_i_P= zeros(length(evs),1); SNR_i_S= SNR_i_P;
    evlat= SNR_i_P; evlon= SNR_i_P; evdep= SNR_i_P; evmag= SNR_i_P;
    
    
    for iev=1:length(evs)
        SNR_i_P(iev)= All_Waveform_Data.(evs{iev}).Ps_Waveforms.S2N_ratio;
        SNR_i_S(iev)= All_Waveform_Data.(evs{iev}).Sp_Waveforms.S2N_ratio;


        evlat(iev)= Events.(MatchMe{iev}).Latitude; evlon(iev)= Events.(MatchMe{iev}).Longitude; 
        evdep(iev)= Events.(MatchMe{iev}).Depth; evmag(iev)= Events.(MatchMe{iev}).Magnitude; 

    end

    T_SNR= [evlon evlat evdep evmag SNR_i_P SNR_i_S];
    T_headings= {'Longitude','Latitude','Depth','Magnitude','SNR_P','SNR_S'};
    T= array2table(T_SNR,'VariableNames',T_headings);
    

    isBad_P= SNR_i_P<=0; SNR_i_P(isBad_P)= [];
    isBad_S= SNR_i_S<=0; SNR_i_S(isBad_S)= [];
    
    SNR_all_P= [SNR_all_P; SNR_i_P]; 
    SNR_all_S= [SNR_all_S; SNR_i_S];
    SNR_mean_P(i)= mean(SNR_i_P); SNR_std_P(i)= std(SNR_i_P); 
    SNR_mean_S(i)= mean(SNR_i_S); SNR_std_S(i)= std(SNR_i_S); 
    
    SNR_allstns_P{i}= SNR_i_P; SNR_allstns_S{i}= SNR_i_S;
    Q5_all_P(i)= quantile(SNR_i_P,0.05); Q95_all_P(i)= quantile(SNR_i_P,0.95);
    Q5_all_S(i)= quantile(SNR_i_S,0.05); Q95_all_S(i)= quantile(SNR_i_S,0.95);
end


Q5_total_P= quantile(SNR_all_P,0.05); Q95_total_P= quantile(SNR_all_P,0.95);
Q5_total_S= quantile(SNR_all_S,0.05); Q95_total_S= quantile(SNR_all_S,0.95);

%% Plot according to mean +/- 1 standard deviation

f1= figure; 
ppos= get(f1,'Position');
set(f1,'Position',[ppos(1) ppos(2) ppos(3)*1.5 ppos(4)]);
subplot(1,2,1); hold on;
histogram(SNR_all_P);
xlabel('Mean SNR for P Arrivals'); ylabel('Number events');
set(gca,'FontSize',14);
xlim([0 30]);
subplot(1,2,2); hold on;
histogram(SNR_all_S,15);
xlabel('Mean SNR for S arrivals'); ylabel('Number events');
set(gca,'FontSize',14);
xlim([0 30]);

f2= figure; 
ppos= get(f2,'Position');
set(f2,'Position',[ppos(1) ppos(2) ppos(3)*1.9 ppos(4)]);
subplot(1,2,1); hold on;
for ip=1:nst
    plot([ip ip],[SNR_mean_P(ip)-SNR_std_P(ip) SNR_mean_P(ip)+SNR_std_P(ip)],'linewidth',7,'color',[183 28 28]/255);
end
scatter(1:nst,SNR_mean_P,300,'d','r','filled');
xlabel('Station'); ylabel('Signal-to-noise Ratio');
set(gca,'XTickLabel',{}); ylim([0 30]);
set(gca,'FontSize',18);

subplot(1,2,2); hold on;

for ip=1:nst
    plot([ip ip],[SNR_mean_S(ip)-SNR_std_S(ip) SNR_mean_S(ip)+SNR_std_S(ip)],'linewidth',7,'color',[183 28 28]/255);
end
scatter(1:nst,SNR_mean_S,300,'d','r','filled');
xlabel('Station'); ylabel('Signal-to-noise Ratio');
set(gca,'XTickLabel',{}); ylim([0 10]);
set(gca,'FontSize',18);

%% Plot according to mean and 5-95% percentile.

f3= figure; 
ppos= get(f3,'Position');
set(f3,'Position',[ppos(1) ppos(2) ppos(3)*1.9 ppos(4)]);
subplot(1,2,1); hold on;
for ip=1:nst
    this_stn= SNR_allstns_P{ip};
    pd= fitdist(SNR_allstns_P{ip},'Normal');
    % Line representing quantiles of sample - 5 to 95%
    Q5= quantile(this_stn,0.05); Q95= quantile(this_stn,0.95);
    plot([ip ip],[Q5 Q95],'color',[183 28 28]/255,'linewidth',2,'Marker','square','MarkerSize',5);
    scatter(ip,pd.mu,100,'d','r','filled','MarkerEdgeColor','k');
end
xlabel('Station'); ylabel('Signal-to-noise Ratio');
set(gca,'XTickLabel',{}); ylim([0 45]);
set(gca,'FontSize',18);

subplot(1,2,2); hold on;

for ip=1:nst %[isBasin, isNotBasin]
    this_stn= SNR_allstns_S{ip};
    pd= fitdist(SNR_allstns_P{ip},'Normal');
    % Line representing quantiles of sample - 5 to 95%
    Q5= quantile(this_stn,0.05); Q95= quantile(this_stn,0.95);
    plot([ip ip],[Q5 Q95],'color',[183 28 28]/255,'linewidth',2,'Marker','square','MarkerSize',5);
    scatter(ip,pd.mu,100,'d','r','filled','MarkerEdgeColor','k');
end
xlabel('Station'); ylabel('Signal-to-noise Ratio');
set(gca,'XTickLabel',{}); ylim([0 20]);
set(gca,'FontSize',18);


% Report mean and 5%, 95% percentiles.
[mean(SNR_all_P) Q5_total_P Q95_total_P mean(SNR_all_S) Q5_total_S Q95_total_S]

% Proportion of points above critical number
[sum(SNR_all_P>3)/length(SNR_all_P) sum(SNR_all_S>3)/length(SNR_all_S)]