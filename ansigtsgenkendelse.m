%Dette program har til formål at genkende billeder fra hinanden 
%Programmet har mulighed for at:
%   1) Printe billedet der skal genkendes samt billedet der ligner bedst
%   2) Printe billederne i datasættet
%   3) Printe egenbilleder
%   4) Printe gennemsnitsbillede
%   5) Printe diverse værdier fra algoritmen

%Indlæser, udvælger og sorterer datasættet:
loaded_billeder=load_database();        %Indlæser datasættet
billede_tal=1;                          %Denne person skal genkendes
billede=loaded_billeder(:,billede_tal); %Vælger billedet
resten_billeder=loaded_billeder(:,[1:billede_tal-1 billede_tal+1:end]); %Samler de restende billeder
antal_billeder=19; %Antallet af resterende billeder

%Beregner egenvektorer:
x_bar=single(mean(resten_billeder,2));      %Beregner middelvektoren x_bar
B=resten_billeder-(single(x_bar));          %Beregner B
var=single(B)'*single(B);                   %Beregner varians med SVD
[egenvektor,D]=eig(var);                    %Beregner normaliserede egenvektorer og egenværdier for varians
egenvektor=single(B)*egenvektor;            %Finder en ortogonal basis for søjlerummet i B
egenvektor=flip(egenvektor,2);              %Spejler egenvektor-matricen, sådan den mest betydningsfulde vektor er i første søjle.
B_egenvektor_proj=zeros(size(antal_billeder,2),antal_billeder); %Opretter array til projektionen af B i egenrummet
for i=1:antal_billeder                      %Egenvektormatricen transponeres og ganges med B vektor. Dette projekterer billede i til egenrummet.
    B_egenvektor_proj(i,:)=single(B(:,i))'*egenvektor; 
end

%Gør billedet kompatibelt og finder mindste afstand:
B_billede=billede-x_bar;                %Beregner B for det valgte billede
B_egenvektor_proj_billede=single(B_billede)'*egenvektor;    %Projiterer billedet ned i egenrummet
afstand=[];                     %Opretter tomt array for afstand mellem billeder
for i=1:antal_billeder          %Beregner afstand mellem billeder
    afstand=[afstand,norm(B_egenvektor_proj(i,:)-B_egenvektor_proj_billede,2)];  
end
[a,i]=min(afstand);             %Udregner den mindste afstand


%Finder afstanden mellem billedet og alle andre billeder uden brug af
%eigenfaces(dårlig metode):
% afstand_simpel=[];              %Opretter tomt array til afstande
% for j=1:antal_billeder          %Beregner afstand mellem billeder
%     afstand_simpel=[afstand_simpel,norm(billede-resten_billeder(j,:),2)];
% end
% [a,i]=min(afstand_simpel);      %Vælger den mindste afstand(altid til billede 1)

%Printer billedet, der ledes efter:
figure(1);                      %Opretter Figur 1
colormap(gray);                 %Laver Figur 1 gråtone
subplot(121);                   %Subplot 1/2 i Figur 1 oprettes
image(reshape(billede,500,500));%Printer billedet, der skal genkendes i Subplot 1/2
title(sprintf('Leder efter person %d ', billede_tal),'FontWeight','bold','Fontsize',16,'color','red');

%Printer billedet, der matcher bedst:
subplot(122);                   %Subplot 2/2 i Figur 1 oprettes
image(reshape(resten_billeder(:,i),500,500));   %Billedet der ligner bedst plottes
if i>=billede_tal   %Ændrer i, så det passer til det tilhørende billeder når teksten printes
    i=i+1;
end
title(sprintf('Person %d ligner mest', i),'FontWeight','bold','Fontsize',16,'color','red');

% %Printer alle personener(fortæller fejl i command window, men virker stadig):
% figure(2);                          %Opretter Figur 2
% M = num2cell(loaded_billeder,1);    %Inddeler loaded_billeder
% colormap(gray);                     %Printer i gråtoner
% image(reshape(billede,500,500));
% subplot(4,5,1);
% for i=1:antal_billeder+1          %Printer alle billederne
%     image(reshape(M{i},500,500));   
%     title(sprintf('%d',i),'color','red');
%     subplot(4,5,i+1);
% end   

%Printer egenansigter:
% figure(3);                          %Opretter Figur 3
% M = num2cell(egenvektor,1);         %Inddeler egenvektor-matricen
% colormap(flipud(gray));             %printer i gråtoner
% 
% for i=1:antal_billeder            %Printer alle egenansigter
%     image(reshape(M{i},500,500));
%     subplot(4,5,i);
% end


%Printer gennemsnitsansigt:
% figure(4);
% colormap((gray));
% image(reshape(x_bar,500,500));

%Printer diverse værdier:
% disp(egenvektor);                %Printer egenvektorerne(meget store)
% disp(D);                         %Printer egenværdier
% disp(min(afstand));                   %Printer mindte afstand mellem billederne

%Kilde: https://www.nzfaruqui.com/face-recognition-using-matlab-implementation-and-code/