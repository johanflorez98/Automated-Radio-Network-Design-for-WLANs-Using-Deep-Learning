%% Generación de las ubicaciones de los AP ********************************

clear
close all
clc

% Escenario actual:
esc = 1;
cant_esc = 10; % Cantidad de escenarios disponibles************************

% Posiciones de AP por escenario:
pos = 1000; % Cantidad de simulaciones a realizar por escenario
pos1 = 1; % Contador de las posiciones de los AP por escenario

cant_AP = 3; % Cantidad de AP**********************************************
% (se modifica según la estructura de la red que se quiera, en este caso, 
% se establecieron 1,2 y 3 puntos de acceso)

% Ciclo de genración de los escenarios y transmisores:
while pos1 <= pos && esc <= cant_esc

    % Lectura del plano actual
    if pos1 == 1
        % En las imagenes que se leen como escenarios, 
        % las paredes se representan on píxeles en negro y e
        % resto de la misma con píxeles en blanco.
        % (La ruta establecida se debe cambiar según la posición en la que se encuentren los planos de los escenarios)
        % Esta es la ruta de la carpeta en la que se encuentran los planos de los escenarios:
        ruta = "" % #######################################################
        plano = imread(ruta + string(esc) + '.JPG'); % Plano inicial
        tam = size(plano); % Tamaño de los escenarios
        
        % Adecuación del plano ********************************************
        % Se binariza la imagen:
        % Las paredes se representan ahora con píxeles en blanco y el resto
        % del escenario con píxeles en negro. Así mismo las imágenes ahora
        % se generan en una profundidad de 8 bits.
        for i = 1:tam(1)
            for j = 1:tam(2)
                if plano(i,j,1) <= 100
                    plano1(i,j) = 255;
                end
                if plano(i,j,1) > 100
                    plano1(i,j) = 0;
                end
            end
        end
        
        % Se aseguran las paredes de los lados:
        plano1(1, :) = 255;
        plano1(tam(1), :) = 255;
        
        plano1(:, 1) = 255;
        plano1(:, tam(2)) = 255;
        
        % Se muestra y se guarda el plano procesado:
        figure(1)
        imshow(plano1)
        % (La ruta establecida se debe cambiar según la posición en la que se desee alamacenar la misma)
        % Esta es la ruta de la carpeta en la que se desean guardar las nuevas imágenes de los escenarios:
        ruta = "" % #######################################################
        imwrite(plano1, ruta + string(esc) + '.png')
    end

    % Ubicación de AP de forma aleatoria, se dejan 10 px de margen respecto
    % a los bordes de cad imagen:
    apx = randi([0+10 tam(1)-10], 1, cant_AP);
    apy = randi([0+10 tam(2)-10], 1, cant_AP);
    
    AP = [apx' apy'];
    
    % Creación de la matriz de los transmisores:
    antenas = zeros(tam(1), tam(2));
    
    for i = 1:length(apx)
        antenas(apx(i), apy(i)) = 255;
    end

    % Se reubican los AP si se encuentran sobre las paredes ***************
    % se mueven 5 pixeles en diagonal hacia la derecha:
    for k = 1:cant_AP
        for i = 1:tam(1)
            for j = 1:tam(2)
                if plano1(i, j) == 255 && AP(k, 1) == i && AP(k, 2) == j
                    AP(k, 1) = AP(k, 1) + 5;
                    AP(k, 2) = AP(k, 2) + 5;
                end
            end
        end
    end
    
    % Se actualizan las posiciones de los AP
    antenas = zeros(tam(1), tam(2));
    
    for i=1:length(apx)
        antenas(AP(i, 1), AP(i, 2)) = 255;
    end
    
    % Se muestran y se guardan las posiciones de los transmisores
    figure(2)
    imshow(antenas)
    % (La ruta establecida se debe cambiar según la posición en la que se desee alamacenar la misma)
    % Esta es la ruta de la carpeta en la que se desean guardar las imágenes de las posiciones de los transmisores:
    ruta = "" % #######################################################
    imwrite(antenas, ruta + string(esc) + '_'+string(pos1) + '.png')

    % Se almacenan las ubicaciones (x,y) de los AP por escenario **********
    pos_AP_esc(:, :, pos1, esc) = AP; % (x,y,posicion_AP,escenario)
    pos1 = pos1 + 1;
    if pos1 == pos + 1
        pos1 = 1;
        esc = esc + 1;
    end

end

% Se guardan las posiciones de los APs para cualquier uso posterior que se
% requiera:
% (La ruta establecida se debe cambiar según la posición en la que se deseen alamacenar las posicones de los transmisores.
% Finalmente es importante mencionar que las imágenes tienen una resolución de 256 px x 256 px y que las posiciones almacenadas
% para cada caso de 1, 2 y 3 transmisores se guarda con coordenadas en píxeles.)
% Esta es la ruta en la que se desea guardar las posiciones de los transmisores:
ruta = "" % #######################################################
save(ruta, 'pos_AP_esc');
