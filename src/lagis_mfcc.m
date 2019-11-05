%%%%%%%%%%%%%%%%%%%%
% MFCC
% Original: Code Lagis
%
% Voir "~/LAGIS-SEGM/lagis_mfcc_segm.m" qui est une adaptation 
% de ce programme pour la segmentation
%
% Arguments :
% -----------
%
% - signal          -> signal à analyser : doit être un vecteur ligne
% - taille_fenetre  -> taille des fenêtres d'analyse en nombre d'échantillons
% - taille_pas      -> taille du pas d'avancement en nombre d'échantillons
% - taille_fft      -> taille des FFT en nombre d'échantillons
% - fe              -> fréquence d'échantillonnage
% - nomfichier      -> sauve le premier spectre d'amplitude 
%                      au format postcript dans ce fichier
% - nmfcc           -> nombre de filtres MFCC
%
% Retour :
% --------
%
% Renvoi une matrice comprenant :
%   * nombre_filtres             lignes
%   * ~taille_signal/taille_pas  colonnes
%
% liste TODO
% ----------
%
% 1) 23/01/2006
%    M'assurer que la normalisation est bien faite.
%
% 2) 30/01/2006
%    Implémenter d'autres fenêtres que la fenêtre de Hamming.
%
% 3) 30/01/2006
%    Modulariser tout cela !!!
%
% St\'ephane Rossignol - 23/01/2006 (LAGIS) ; 24/06/10 (Sup\'elec)
%
%%%%%%%%%%%%%%%%%%%%

function [mfcc_collect] = lagis_mfcc (signal,taille_fenetre,taille_pas,taille_fft,fe,nomfichier,nmfcc)


%%% initialisations
inspectspec    = 0;  % pour vérifier l'ajustement des normalisations etc 
                     % => mettre à 1 pour ce faire ; à 0 sinon
mfcc_collect   = []; % où les coefficients de la MFCC sont collectés
numero_pond    = 2;  % choix de la fenêtre de pondération
taille_signal  = length(signal);


%%% construction de la fenêtre de pondération
switch numero_pond
  case 1
    % fenêtre de pondération rectangulaire ; works better with the rectangular window
    fpond    = ones(1,taille_fenetre);

  case 2
    % fenêtre de ponderation de Hamming
    %fpond    = 0.54 + 0.46*sin(2*pi*[0:taille_fenetre-1]/(taille_fenetre-1)-pi/2);
    fpond = hamming(taille_fenetre)';

  case 3
    % fenêtre de ponderation de Blackman
    fpond = blackman(taille_fenetre)';
end;
fpond    = 2*fpond/sum(fpond); % normalisation de la fenêtre de pondération


%%% construction du banc de filtres MEL
frequences = [0:taille_fft/2]*fe/taille_fft;
nombre_filtres    = nmfcc; % ca depend de fe
frequence_minimum = 130;   % en Hz ; ca depend de fe et de ce qu'on veut
if (fe==16000)
  frequence_maximum = 6800;  % en Hz ; ca depend de fe
elseif (fe==8000)
  frequence_maximum = 3500;  % en Hz ; ca depend de fe
end;
Fmin = 2595*log10(frequence_minimum/700 + 1); % \'echelle des Mels
Fmax = 2595*log10(frequence_maximum/700 + 1); % \'echelle des Mels
ww   = (Fmax - Fmin)/(nombre_filtres/2+0.5);  % largeur de bande dans l'echelle des Mels
filtres_mel = zeros(nombre_filtres,length(frequences)); % initialisation filtres Mel
for ii=1:nombre_filtres
  Fimin = Fmin  + (ii-1)*ww/2;
  Fi    = Fimin + ww/2;
  Fimax = Fimin + ww;

  fimin = 700*(10^(Fimin/2595) - 1);
  fi    = 700*(10^(Fi/2595)    - 1);
  fimax = 700*(10^(Fimax/2595) - 1);

  montee   = (frequences>=fimin & frequences<=fi);
  descente = (frequences>fi     & frequences<=fimax);
  filtres_mel(ii,:) = ((frequences-fimin)/(fi-fimin)).*montee + ((fimax-frequences)/(fimax-fi)).*descente;
end;

figure(1);
clf;
grid on;
hold on;
for ii=1:2:nombre_filtres
  plot(frequences,filtres_mel(ii,:),'r');
end
for ii=2:2:nombre_filtres
  plot(frequences,filtres_mel(ii,:),'b');
end
%zoom on;
hold off;
%pause;


%%% Boucle temporelle
for ii=1:taille_pas:taille_signal-taille_fenetre
  % fenêtrage
  signal_fenetre = signal(ii:ii+taille_fenetre-1).*fpond;

  % spectre d'amplitude
  spectre = abs(fft(signal_fenetre,taille_fft));

  % log spectre d'amplitude (plot pas nécessaire à l'analyse => simplement pour tester)
  if (inspectspec==1 | ii==1)
    spec = 20.*log10(spectre);
    figure(2);
    clf;
    grid on;
    hold on;
    plot(spec);
    title('spectre d amplitude en dB');
    %%zoom on;
    hold off;
    %print('-dpsc2',nomfichier);
  end;

  for jj=1:nombre_filtres % essayer de me débarrasser de cette boucle
    % spectre réduit - filtrage Mel
    spectre_reduit = spectre(1:length(frequences)).*filtres_mel(jj,:);

    % energies spectres reduits
    energies(jj) = log10(sum(spectre_reduit.*spectre_reduit));
  end;

  % transformation cosinus inverse
  mfcc = dct(energies);
  %mfcc2 = lagis_dct(energies);
  if (inspectspec==1)
    figure(3);
    clf;
    grid on;
    hold on;
    plot(mfcc);
    plot(mfcc2+0.1,'r');
    %%zoom on;
    hold off;
  end;

%  figure(1);
%  plot(signal_fenetre);
%  figure(2);
%  plot(mfcc);
%  pause;

  mfcc_collect = [mfcc_collect mfcc'];

  if (inspectspec==1)
    %pause;
  end;
end;

