% 2012 10 18 I.Zliobaite
% last modified: 2014 10 29 - sutvarkytas apipavidalinimas ir komentarai

% balsavimo duomenu paruosimas
% duomenys is cia http://data.ukmin.lt/duomenys_rinkimu.html

% Analizuojamos partijos, kurios pateko i Seima
% 1 ls - Liberalu sajudis
% 3 dp - Darbo partija 
% 5 ts - Tevynes sajunga
% 6 dk - Drasos kelias
% 7 le - Lenku rinkimu akcija
% 8 sd - Socialdemokratai
% 9 tt - Tvarka ir teisingumas

input_file = '3_data/raw_data/pirmumo_balsai.csv';

param_min_skirtumas = 5; %per daugiau kaip 5 vietas aukstyn
param_didele_koreliacija = 0.5; %nuo kiek jau skaitosi didele koreliacija
patekusiu_partiju_numeriai = [1 3 5 6 7 8 9];
patekusiu_partiju_kodai = {'ls' 'dp' 'ts' 'dk' 'le' 'sd' 'tt'};

%duomenu nuskaitymas
%apylinke,sarasas,pr_reitingas,pab_reitingas,balsai
data = csvread(input_file,1,0);
apylinkes = unique(data(:,1));
no_apylinkiu = length(apylinkes);

for sk=1:length(patekusiu_partiju_numeriai)
    partija_now = patekusiu_partiju_numeriai(sk);
    
    %duomenu filtravimas, viena partija
    ind_now = find(data(:,2)==partija_now);
    n = length(ind_now);
    data_now = data(ind_now,:);
    kandidatai = unique(data_now(:,3));
    no_kandidatu = length(kandidatai);
    
    kan_file_name = ['3_data/' patekusiu_partiju_kodai{sk} '_kandidatai.csv'];
    csvwrite(kan_file_name,kandidatai);
    
    %inicializavimas
    skirtumai = zeros(no_apylinkiu,no_kandidatu); %tarp pradzios reitingo ir pabaigos reitingo
	balsai = zeros(no_apylinkiu,no_kandidatu); %is viso balsu
    
    %ciklas per vienos partijos duomenis
    for sk2 = 1:n
        apylinkes_nu = find(apylinkes == data_now(sk2,1));
        kandidato_nu = find(kandidatai == data_now(sk2,3));
        skirtumai(apylinkes_nu,kandidato_nu) = data_now(sk2,3)-data_now(sk2,4);
        balsai(apylinkes_nu,kandidato_nu) = data_now(sk2,5);
    end;
    
    %balsu proporcija apylinkeje (is visu tai partijai pirmumo balsu, kiek
    %kandidatas gavo)
    smb = sum(balsai,2);
    smb(smb==0) = 1;
    balsai_rel = balsai./(smb*ones(1,no_kandidatu)); 
    
    brel_file_name = ['3_data/' patekusiu_partiju_kodai{sk} '_balsai_rel.csv'];
    csvwrite(brel_file_name,balsai_rel);
    
    %ind = find(skirtumai(1,:)>param_min_skirtumas);

    %koreliacija tarp prop balsu, domina teigiamos
    correlations = corr(balsai_rel); 
    
    cor_file_name = ['3_data/' patekusiu_partiju_kodai{sk} '_koreliacijos.csv'];
    csvwrite(cor_file_name,correlations);
    
    %idomios poros
    for sk3 = 1:no_kandidatu %tiek max nariu sarase
        correlations(sk3,sk3)=0; %pats su savim nesiskaito
    end;
    
    [i,j] = sort(correlations(:),'descend'); %rusiuojam nuo didziausios iki maziausios
    kiek_dideliu_koreliaciju = length(find(i>=param_didele_koreliacija));
    
    poros = [];
    for cik = 1:2:kiek_dideliu_koreliaciju %kai surusiuojam, tai gaunasi, kad reikia ziureti kas antra
        [xx,yy] = find(correlations==i(cik));
        poros = [poros; xx(1) yy(1) skirtumai(1,xx(1)) skirtumai(1,yy(1)) correlations(xx(1),yy(1))];
    end;
    
    por_file_name = ['3_data/' patekusiu_partiju_kodai{sk} '_poros.csv'];
    csvwrite(por_file_name,poros);
    
    
end;