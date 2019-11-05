%%% Adds trailing silences -- silence detection used
%%% 
%%% St\'ephane Rossignol -- 30/06/10

function [signal] = modified(sss, fe, doit)

if (doit==1)
  stdn = 0.008+rand(1,1)*0.001;
  noise1 = stdn*randn(1,fe + rand(1,1)*fe);
  noise2 = stdn*randn(1,fe + rand(1,1)*fe);

%size(sss)
%size(noise1)

  signal = [noise1 sss' noise2]';

  signal = sil_detect(signal, fe);
else
  signal = sss;
end;

