clear all


%define COSP output file
ifile='AmipLmdz5_19790101_19790131_HF_histhfCOSP.nc'

% read latitude - longitude grid
lon = ncread(ifile,'lon');
lat = ncread(ifile,'lat');

%read grid land-ocean
pourc_oce = ncread('AmipLmdz5_19790101_19790131_HF_histhf.nc','pourc_oce',[1 1 1],[96 96 1]); 


% read tetas from the model
h=load('tetas_lmdz96');
h=h(:,2);
h=reshape(h,12,length(lat));
tetas=zeros(length(lat),13);
for ilat=1:length(lat)
    for imon=1:12
      tetas(ilat,1)=lat(ilat);
      tetas(ilat,imon+1)=h(imon,ilat);
    end
end  
tetas=tetas(:,2:end); % 12 tetas for each month
tetas=tetas(:,1);   % keep the tetas for example of january

tetas_sim=[0 20 40 60 80];


% read variables of 'instantaneous' reflectance and cloud fraction
refl = ncread(ifile,'parasol_refl',[1 1 1 1],[96 96 5 248]); 
cftot = ncread(ifile,'cltcalipso',[1 1 1],[96 96 248]); 
cflow = ncread(ifile,'cllcalipso',[1 1 1],[96 96 248]); 



% choose the corresponding reflectance according to tetas
refle(1:size(refl,4),1:length(lat),1:length(lon))=NaN;
for it=1:size(refl,4)
    for iang=1:length(tetas_sim)-1
        for ilat=1:length(lat)
      	    if(tetas_sim(iang)<=tetas(ilat)&tetas(ilat)<tetas_sim(iang+1)) 
               refle(it,ilat,:)=(refl(:,ilat,iang+1,it)-refl(:,ilat,iang,it))./(tetas_sim(iang+1)-tetas_sim(iang))*(tetas(ilat)-tetas_sim(iang))+refl(:,ilat,iang,it);
            end
        end
    end 
end        



% calculate the cloudy reflectance 
for ilon=1:length(lon)
     for ilat=1:length(lat)   
         for it=1:size(refl,4)
             if (cftot(ilon,ilat,it)>0.05)
                 reflecloud(it,ilat,ilon)=(refle(it,ilat,ilon)-0.03*(1-cftot(ilon,ilat,it)))/cftot(ilon,ilat,it);
             else
                 reflecloud(it,ilat,ilon)=NaN;
             end
         end 
    end
end             
     
 
% in case where the output COSP files contain the variable parasol_cref use only the following command to calculate the cloudy reflectance
%reflecloud = ncread(ifile,'parasol_crefl',[1 1 1 1],[96 96 5 248]); 
    

% exclude land
for ilon=1:length(lon)
    for ilat=1:length(lat)
        if pourc_oce(ilat,ilon)<60 
            reflecloud(:,ilat,ilon)=NaN;
        end 
    end
end
  



% caclulate the number points within the bins of cloud fraction and cloud reflectance

cfbin=[0:0.03:1.06];
refbin=[0:0.03:1.06];

for iref=1:length(refbin)-1 
      iref 
    for icf=1:length(cfbin)-1 
       is(iref,icf)=0;
       islow(iref,icf)=0;
       for ilon=1:length(lon)
           for ilat=1:length(lat)
                for it=1:size(refl,4)
                    if (lat(ilat)<30&lat(ilat)>-30)   % only tropics
                       if (refbin(iref)<reflecloud(it,ilat,ilon)&reflecloud(it,ilat,ilon)<=refbin(iref+1))... 
                               & (cfbin(icf)<=cftot(ilon,ilat,it)&cftot(ilon,ilat,it)<cfbin(icf+1))
                          is(iref,icf)=is(iref,icf)+1;
                           if (cflow(ilon,ilat,it)>0.9*cftot(ilon,ilat,it))
                              islow(iref,icf)=islow(iref,icf)+1;
                           end  
                       end   
                    end
                 end
            end
        end
    end
end


% normalisation to the total number of points
nomis=sum(is,1);
nomis=sum(nomis);
is=is/nomis;
islow=islow/nomis;




% plot figures

a=[1 1 1; 1 0.75 0; 1 1 0; 0.5 1 0; 0 1 0; 0 1 1; 0 0.5 1; 0 0 1; 0.5 0 1; 0.75 0 1; 1 0 0.5; 1 0 0];

figure
pcolor(cfbin(1:end-1),refbin(1:end-1),is)
shading flat
axis([0 1.03 0 1])
caxis([0 0.008])
colormap(a)
colorbar
ylabel ('CLOUD REFLECTANCE','FontSize',15,'FontSize',15)
xlabel('CLOUD COVER','FontSize',15,'FontSize',15)
title('ALL CLOUDS - LMDZ5A','FontSize',15,'FontSize',15)
 
   
figure
pcolor(cfbin(1:end-1),refbin(1:end-1),islow)
shading flat
axis([0 1.03 0 1])
caxis([0 0.002])
colormap(a)
colorbar
ylabel ('CLOUD REFLECTANCE','FontSize',15,'FontSize',15)
xlabel('CLOUD COVER','FontSize',15,'FontSize',15)
title('LOW CLOUDS - LMDZ5A','FontSize',15,'FontSize',15)
 
   


