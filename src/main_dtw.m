%%% Exemple DTW -- Main program
%%% 
%%% St\'ephane Rossignol -- 24/06/10

clear all;
close all;

pkg load signal  %%% pour octave

name1 = 'test3/adroite2.wav'; %%% référence classe 1
name2 = 'test3/adroite.wav';  %%% son 1 à classer dans la classe 1
name3 = 'test3/adroite3.wav'; %%% son 2 à classer dans la classe 1

name4 = 'test3/agauche2.wav'; %%% référence classe 2
name5 = 'test3/agauche.wav';  %%% son 1 à classer dans la classe 2
name6 = 'test3/agauche3.wav'; %%% son 2 à classer dans la classe 2

name7 = 'test3/enavant2.wav'; %%% référence classe 3
name8 = 'test3/enavant.wav';  %%% son 1 à classer dans la classe 3
name9 = 'test3/enavant3.wav'; %%% son 2 à classer dans la classe 3

name10 = 'test3/stop2.wav'; %%% référence classe 4
name11 = 'test3/stop.wav';  %%% son 1 à classer dans la classe 4
name12 = 'test3/stop3.wav'; %%% son 2 à classer dans la classe 4

[signal,fe] = audioread(name1);

taille_fenetre = round(fe*0.03);
taille_pas     = round(fe*0.01);
taille_fft     = 2048;
nomfichier = 'tmp.ps';


%%%
feat = 1;  %%% on n'utilise plus que les MFCC
switch feat
  case 1
    fprintf(1,'MFCC\n');fflush(1);

  case 2
    fprintf(1,'LPC\n');fflush(1);
end;


dots = 0;   %%%% if dots=1, trailing silences processed
for ii=1:12 %%%% boucle sur les fichiers traités
  switch ii
    case 1
      [signal,fe] = audioread(name1);
      %%%
      if (dots==1) signal=modified(signal, fe, 0); end;  %%% with trailing silences
      signal = signal/mean(signal.*signal);
      signal1=signal;

    case 2
      [signal,fe] = audioread(name2);
      %%%
      if (dots==1) signal=modified(signal, fe, 1); end;  %%% with trailing silences
      signal = signal/mean(signal.*signal);
      signal2=signal;

    case 3
      [signal,fe] = audioread(name3);
      %%%
      if (dots==1) signal=modified(signal, fe, 1); end;  %%% with trailing silences
      signal = signal/mean(signal.*signal);
      signal3=signal;

    case 4
      [signal,fe] = audioread(name4);
      %%%
      if (dots==1) signal=modified(signal, fe, 0); end;  %%% with trailing silences
      signal = signal/mean(signal.*signal);
      signal4=signal;

    case 5
      [signal,fe] = audioread(name5);
      %%%
      if (dots==1) signal=modified(signal, fe, 1); end;  %%% with trailing silences
      signal = signal/mean(signal.*signal);
      signal5=signal;

    case 6
      [signal,fe] = audioread(name6);
      %%%
      if (dots==1) signal=modified(signal, fe, 1); end;  %%% with trailing silences
      signal = signal/mean(signal.*signal);
      signal6=signal;

    case 7
      [signal,fe] = audioread(name7);
      %%%
      if (dots==1) signal=modified(signal, fe, 0); end;  %%% with trailing silences
      signal = signal/mean(signal.*signal);
      signal7=signal;

    case 8
      [signal,fe] = audioread(name8);
      %%%
      if (dots==1) signal=modified(signal, fe, 1); end;  %%% with trailing silences
      signal = signal/mean(signal.*signal);
      signal8=signal;

    case 9
      [signal,fe] = audioread(name9);
      %%%
      if (dots==1) signal=modified(signal, fe, 1); end;  %%% with trailing silences
      signal = signal/mean(signal.*signal);
      signal9=signal;

    case 10
      [signal,fe] = audioread(name10);
      %%%
      if (dots==1) signal=modified(signal, fe, 0); end;  %%% with trailing silences
      signal = signal/mean(signal.*signal);
      signal10=signal;

    case 11
      [signal,fe] = audioread(name11);
      %%%
      if (dots==1) signal=modified(signal, fe, 1); end;  %%% with trailing silences
      signal = signal/mean(signal.*signal);
      signal11=signal;

    case 12
      [signal,fe] = audioread(name12);
      %%%
      if (dots==1) signal=modified(signal, fe, 1); end;  %%% with trailing silences
      signal = signal/mean(signal.*signal);
      signal12=signal;

  end;
end;


succ=1000.;
for nfeat=10:20 %%% on fait varier le nombre de features (=MFCC ici) extraits pour voir l'influence de ce paramètre
                %%% note : ça marche pour tout les "nfeat" testés ici

  for ii=1:12  %%% boucle sur les signaux traités
    switch ii
      case 1
        signal = signal1;

      case 2
        signal = signal2;

      case 3
        signal = signal3;

      case 4
        signal = signal4;

      case 5
        signal = signal5;

      case 6
        signal = signal6;

      case 7
        signal = signal7;

      case 8
        signal = signal8;

      case 9
        signal = signal9;

      case 10
        signal = signal10;

      case 11
        signal = signal11;

      case 12
        signal = signal12;

    end;

    %%% band-pass filtering
%    [bb,aa] = butter(5, [60./fe 8000./fe]);
%    signa = filter(bb, aa, signal);
    %figure(1);
    %plot(signal)
    %hold on;
    %plot(signa,'r')
    %pause

    %%% resampling
%    if (feat==2)
%      signal = resample(signal,8000.,fe);
%      fe = 8000.;
%    end

    switch feat
      case 1
        [feat_collect] = lagis_mfcc (signal',taille_fenetre,taille_pas,taille_fft,fe,nomfichier,nfeat);

      case 2
        [feat_collect] = lpc_collect(signal',taille_fenetre,taille_pas,nfeat,fe);
    end;
    %size(feat_collect)
    %pause

    stt=1;
    eed=size(feat_collect,1);
    switch ii
      %%%
      case 1
        ref1 = feat_collect([stt:eed],:);

      case 2
        seq1 = feat_collect([stt:eed],:);

      case 3
        seq2 = feat_collect([stt:eed],:);

      %%%
      case 4
        ref2 = feat_collect([stt:eed],:);

      case 5
        seq3 = feat_collect([stt:eed],:);

      case 6
        seq4 = feat_collect([stt:eed],:);

      %%%
      case 7
        ref3 = feat_collect([stt:eed],:);

      case 8
        seq5 = feat_collect([stt:eed],:);

      case 9
        seq6 = feat_collect([stt:eed],:);

      %%%
      case 10
        ref4 = feat_collect([stt:eed],:);

      case 11
        seq7 = feat_collect([stt:eed],:);

      case 12
        seq8 = feat_collect([stt:eed],:);

    end; 

  end;

  nwords=4;                           %%% nombre de classes
  idealconfus=2*ones(nwords,nwords);  %%% matrice de confusion idéale
                                      %%% => 0 partout et 2 sur la diagonale puisqu'il y a 2 sons par classe à classer
  for (ii=1:nwords)
    idealconfus(ii,ii)=0;
  end;

  confus=2*ones(nwords,nwords);
  for ii=1:2:2*nwords
    switch ii
      case 1
        nss=1;
        seq=seq1;

      case 3
        nss=2;
        seq=seq3;

      case 5
        nss=3;
        seq=seq5;

      case 7
        nss=4;
        seq=seq7;
    end;

    dd(nss,1) = function_dtw2 (seq,ref1);%pause;
    dd(nss,2) = function_dtw2 (seq,ref2);%pause;
    dd(nss,3) = function_dtw2 (seq,ref3);%pause;
    dd(nss,4) = function_dtw2 (seq,ref4);%pause;
    %dd(nss,:)

    [vm,pm] = min(dd(nss,:));
    confus(nss,pm)=confus(nss,pm)-1;
  end;
  for ii=2:2:2*nwords
    switch ii
      case 2
        nss=1;
        seq=seq2;

      case 4
        nss=2;
        seq=seq4;

      case 6
        nss=3;
        seq=seq6;

      case 8
        nss=4;
        seq=seq8;
    end;

    dd(nss,1) = function_dtw2 (seq,ref1);%pause;
    dd(nss,2) = function_dtw2 (seq,ref2);%pause;
    dd(nss,3) = function_dtw2 (seq,ref3);%pause;
    dd(nss,4) = function_dtw2 (seq,ref4);%pause;
    %dd(nss,:)

    [vm,pm] = min(dd(nss,:));
    confus(nss,pm)=confus(nss,pm)-1;
  end;

  figure(4)
  imagesc(confus);
  xlim([0.5 4.5]);
  ylim([0.5 4.5]);
  drawnow;

  %%% minimize "succ"
  succ = [succ sum(sum(abs(confus-idealconfus)))];   %%% la différence ntre la matrice de confusion idéale et la matrice de confusion trouvée doit être aussi
                                                     %%% petite que possible
  fprintf(1,'nfeat=%d  minsucc:%f  currentsucc:%f\n',nfeat,min(succ),succ(length(succ)));fflush(1);

end; %%% loop on 'nfeat'

