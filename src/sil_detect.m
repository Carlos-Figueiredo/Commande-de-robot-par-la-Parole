%%% Silence detection
%%% 
%%% St\'ephane Rossignol -- 30/06/10


%%% STANDALONE
%clear all;
%close all;
%
%[xxx,fe] = wavread('detectsil2.wav');
%xxx = xxx(1:10000);


%%% FUNCTION
function [signal] = sil_detect(xxx, fe)


ttt = [1:length(xxx)]/fe;

tsig=round(0.04*fe);

thresh1 = 0.04;
tsil = round(1.00*fe);   %%% minimum length of a true silence
tvoice = round(0.04*fe); %%% minimum length of a voice activity segment

nn=max(xxx);
figure(3);
clf;
plot(ttt,xxx);
hold on;
plot([1 length(xxx)]/fe,[thresh1 thresh1],'r');

activity=0; %%% activity not yet detected
sil=1;      %%% the sound starts with a silence
fen=blackman(tsig);
fen=fen/sum(fen)*tsig;
actualstt=-1;


%%% threshold re-estimation
ii=tsig;
jj=1;
while ii<=2000
  yyy = xxx(ii-tsig+1:ii).*fen;
  ene(jj) = sqrt(sum(yyy.*yyy)/tsig);

  ii=ii+1;
  jj=jj+1;
end;
enei = sort(ene);
thresh1 = 1.2*enei(round(length(ene)*0.99));


%%% main loop
ii=tsig;
jj=1;
ene=zeros(1,length(xxx)-tsig);
while ii<=length(xxx)
  yyy = xxx(ii-tsig+1:ii).*fen;
  ene(jj) = sqrt(sum(yyy.*yyy)/tsig);

  %%% voice activity detection
  %%% it is assumed that:
  %%%   1. there is a silence, some voice activity, and a silence
  %%%   2. only voice activity
  if (ene(jj)>thresh1 && sil==1)
    sil=0;
    stt=ii;
  end;
  if (ene(jj)<thresh1 && sil==0)
    sil=1;
    edd=ii;
    if (edd-stt<tvoice)
      sil=0;   %%% too short voice activity segment; removed
    else
      if (actualstt<0)
        actualstt=stt;
      end;
      actualedd=edd;

      fprintf(1,'voice activity length: %f (%d %d)\n', (edd-stt)/fe, stt, edd);

      activity=1;  %%% the activity has been detected
      sttsil=edd;  %%% starting instant of the final silence

      plot([stt-round(tsig/2) edd-round(tsig/2)]/fe,0.1*[nn nn],'k');
      drawnow;
    end;
  end;
  if (sil==1 && activity==1)
    if (ii-sttsil>tsil)
      fprintf(1,'Processing stopped after a long silence\n');
      fflush(1);
      plot([ii ii]/fe, [min(xxx) max(xxx)]);
      ii=length(xxx);
    end;
  end;

  ii=ii+1;
  jj=jj+1;
end;

actualstt=actualstt-round(tsig/2);
actualedd=actualedd-round(tsig/2);

actualstt=actualstt-round(0.1*fe); %%% enlarging of the segment
actualedd=actualedd+round(0.1*fe); %%% enlarging of the segment
plot([actualstt actualedd]/fe,0.2*[nn nn],'m');

size(ttt)
size([zeros(1,round(tsig/2)) ene zeros(1,round(tsig/2))])
plot(ttt,[zeros(1,round(tsig/2)) ene zeros(1,round(tsig/2))],'g');
hold off;

signal = xxx([actualstt:actualedd]);
pause(1);

