function output_value = load_database()    %Opretter output-funktion for load_database.m
persistent loaded;                         %Opretter loaded som fast variabel
persistent numeric_Image;                  %Opretter numeric_Image som fast variabel
if(isempty(loaded))
    alle_billeder = zeros(500*500,20);     %Opretter en matrix med søjler tilhørende hvert billede med størrelse 500x500
    for i=1:4                              %For hver person/mappe med billede i datasættet
        cd(strcat('f',num2str(i)));        %Genkender mapperne si
        for j=1:5                          %For hvert fingeraftryk i mappen
            image_Container = imread(strcat(num2str(j),'.pgm')); %Læser hvert billede
            alle_billeder(:,(i-1)*5+j)=reshape(image_Container,size(image_Container,1)*size(image_Container,2),1); %Samler billederne
        end
        cd ..
    end
    numeric_Image = single(alle_billeder);   %Omdanner alle_billeder til single()
end
loaded = 1;                     %loaded sættes til 1, så koden ikke køres igen
output_value = numeric_Image;   %Opdaterer output_value

%Kilde: https://www.nzfaruqui.com/loading-the-dataset-for-face-recognition/