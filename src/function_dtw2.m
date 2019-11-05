%%% DTW
%%% 
%%% St\'ephane Rossignol -- 24/06/10

function [dglob] = function_dtw2 (seqenter, seqref)
%seqenter = seq1;
%seqref = ref1;

mm = size(seqenter,2);
nn = size(seqref,2);

dtwpath = zeros(nn+1, mm+1);

dglob = 0.;

for jj=1:mm
  dtwpath(1,jj+1) = 1.0e6;
end;
for ii=1:nn
  dtwpath(ii+1,1) = 1.0e6;
end;
dtwpath(1,1) = 0.;

for ii=1:nn
  for jj=1:mm
    aaa = seqref(:,ii) - seqenter(:,jj);
    ddd = sum(aaa.*aaa);
    dtwpath(ii+1,jj+1) = ddd + min([dtwpath(ii,jj+1) dtwpath(ii+1,jj) dtwpath(ii,jj)]);
  end;
end;

dofig=1;
if (dofig==1)
  figure(3)
  imagesc(log(dtwpath(2:end,2:end)));
  drawnow;
  %pause;
end;

dglob = dtwpath(nn+1,mm+1)/nn; %%% normalisation

