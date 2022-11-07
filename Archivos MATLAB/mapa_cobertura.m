%% Conformación de base de datos para la aplicación de un algoritmo de Deep 
% Learning,  que estime mapas de potencia en construcciones
   
% IMPORTANTE###
% Al ver las propiedades de la imágen se observa sus dimensiones son,  por
% ejemplo 250x350 (ancho x alto),  donde ancho = 250 px y alto = 350 px o lo que es
% equivalente a filas = 350 y columnas = 250,  que es la forma en la que se
% lee desde MATLAB. Además al momento de hacer el monitoreo de las paredes
% se deben intercambiar las posiciones x por y,  y viceversa,  así como i por
% j para contadores.

% El modelo aplicado para el cálculo de la red es el modelo WIFI IEEE
% 802.11

clear
clc
close all

% Se cargan las posiciones de los AP previamentes generadas:
% (Las posiciones de los transmisores se deben cargar de acuerdo a la estructura
% de la red que se desee analizar,  es decir,  de forma independiente para 
% 1, 2 y 3 transmisores. La ruta se debe cambiar según el caso.)
% Ruta en la que se encuentran las posiciones de los transmisores que se desea analizar
% (Es importante mencionar que para cada caso de 1, 2 y 3 transmisores, es necesario generar 
% carpetas de almacenamiento distintas para cada resultado.)
ruta = "" % #######################################################
load(ruta)

% Cantidad de imagenes a crear en el DataSet.
% Se determina el número de iteraciones a ser ejecutadas para formar la
% base de datos:
tam_pos = size(pos_AP_esc);
imagenes = tam_pos(3); % Simulaciones por escenario

% Se inicializa el contador:
contador_im = 1;
Esc_act = 1; % Escenario actual
cant_esc = tam_pos(4); % Cantidad de escenarios sobre los que se crea la base de datos

time_pot = zeros(cant_esc, imagenes); % Matriz en la que se almacenarán los tiempos de ejecución de cada cálculo de mapa de cobertura.

% Se establece el formato a guardar las imagenes:
formato = '.png';

% Cargar el plano inicial:
% (La ruta se debe cambiar según el caso.)
% Ruta en la que se encuentra la carpeta que almacena las imágenes de los escenarios (diseños iniciales, paredes en negro y demás en blanco):
ruta = "" % #######################################################
plain1 = imread(ruta + string(Esc_act) + '.JPG'); % Plano inicial

plain(:, :, 1) = plain1;
plain(:, :, 2) = plain1;
plain(:, :, 3) = plain1;

% Se selecciona que escala en metros se usa:
% (En este caso se analizan escenarios de 20 m x 20 m)
x_metros = 20;
y_metros = 20;

% Parámetros de la red:
c_luz = 3e8; % [m/s^2] Velocidad de la luz
K = 1.380649e-23; % Constante de Boltzmann [J]
B = 20e6; % Ancho de banda [Hz]
T = 290; % T ambiente en [°K]
PT = 22; % Potencia de la antena transmisora [dBm]
GT = 3; % Ganacia de la antena transmisora [dBi]
GR = 0; % Ganancia de la antena transmisora [dBi]
F = 2.412e9; % Frecuencia de operación [Hz]
dpq = 10; % Distancia del punto de quiebre [m]
P_Paredes = 15; % pérdidas por penetración en paredes [dB]
cant_AP = tam_pos(1);
cant_variables = cant_AP*2; % Cantidad de variables a optimizar 
coordenadas = 2;
 
while contador_im <= imagenes && Esc_act <= cant_esc

    close all

    % Se lee el tamaño de la imagen:
    tam_imagen = size(plain);
    x_imagen = tam_imagen(1);
    y_imagen = tam_imagen(2);

    % Se aseguran las paredes de los lados del escenario (nuevamente):
    % (Es importante mencionar que aquí,  las paredes ahora se representan con
    % píxeles en negro y el resto del escenario con píxeles en blanco,  ya que
    % en el mapa de cobertura a ser genrado posteriormente,  los sitios de 
    % menor potencia se representan con valores de píxeles cercanos a cero.)
    plain(1, :, :) = 0;
    plain(:, 1, :) = 0;
    plain(tam_imagen(1), :, :) = 0;
    plain(:, tam_imagen(2), :) = 0;

    % Se binariza la imagen (se invierten colores blanco y negro):
    for i = 1:tam_imagen(1)
        for j = 1:tam_imagen(2)
            if plain(i, j, 1) <= 100
                plain2(i, j) = 0;
            end
            if plain(i, j, 1) > 100
                plain2(i, j) = 255;
            end
        end
    end
    
    % Ubicación de AP en base a posiciones previas:
    apx = pos_AP_esc(:, 1, contador_im, Esc_act);
    apy = pos_AP_esc(:, 2, contador_im, Esc_act);
    
    % Ubicación de AP en pixeles:
    AP=[apx apy];

    % Cálculo del mapa de potencias por AP:
    tic % Empieza a contar el tiempo que se gasta en general el mapa de potencias
    for ap = 1:cant_AP
        for i = 1:x_imagen
            for j = 1:y_imagen
                AP_2 = AP(ap, :);
                % Se llama a la función que realiza el cálculo del mapa de
                % cobertura:
                PR_grafica(i, j, ap) = calculo_potencia(AP_2, plain2, ...
                                    x_imagen, y_imagen, x_metros, y_metros, c_luz, ...
                                    PT, GT, GR, F, dpq, P_Paredes, i, j);
            end
        end
    end

    % Mapa de potencias general y celdas del escenario por AP:
    for i = 1:x_imagen
        for j = 1:y_imagen
            [PR_general(i, j) celda(i, j)] = max(PR_grafica(i, j, :));
        end
    end

    % Grafica del mapa de potencias general:
    mapa = figure;
    mapa.Color = 'white';
    a = PR_general;
    imshow(plain);
    hold on 
    im = imagesc(a);
    colormap(gray(numel(a))); 
    axis image;
    set(gca, 'xtick', [], 'ytick', []); % Se eliminan las etiquetas de los ejes

    % Se guarda la imagen en RGB:
    % Ruta de la carpeta en la que se desean almacenar los mapas de cobertura cálculados:
    ruta = "" % #######################################################
    fileName = ruta + string(Esc_act) + '_' + string(contador_im) + string(formato);
    
    Fig = getframe(gca);
    imwrite(Fig.cdata,  fileName);

    % Colocación de las paredes en el escenario:
    % Primero se lee la imagen y se binariza
    % Ruta de la carpeta en la que se tienen almacenados los mapas de cobertura:
    ruta = "" % #######################################################
    sim_gray_bef = imread(ruta + string(Esc_act) + '_' + string(contador_im) + string(formato));

    % Se binariza la imagen:
    sim_gray = im2gray(sim_gray_bef); % se lleva la imágen a una profundidad de 8 bits
    
    for i = 1:tam_imagen(1)
        for j = 1:tam_imagen(2)
            if plain2(i, j) == 0
                sim_gray(i, j) = 0;
            end
        end
    end

    % Ruta de la carpeta en la que se desea guardar la nueva imagen con profundidad de 8 bits:
    ruta = "" % #######################################################
    fileName = ruta + string(Esc_act) + '_' + string(contador_im) + string(formato);
    
    imwrite(sim_gray,  fileName);

    % Grafica de las celdas del escenario:
    mapa = figure;
    mapa.Color = 'white';
    a = celda;
    imshow(plain);
    hold on 
    im = imagesc(a);
    colormap(gray(numel(a))); 
    axis image;
    set(gca, 'xtick', [], 'ytick', []); % Se eliminan las etiquetas de los ejes

    % Se guarda la imagen en RGB:
    % Ruta de la carpeta en la que se desea guardar la imagen:
    ruta = "" % #######################################################
    fileName = ruta + string(Esc_act) + '_' + string(contador_im) + string(formato);
    Fig = getframe(gca);
    imwrite(Fig.cdata,  fileName);

    % Colocación de las paredes en el escenario con las celdas:
    % Primero se lee la imagen y se binariza
    % Ruta de la carpeta en la que se almacenan las imágenes de los mapas de celdas calculados
    ruta = "" % #######################################################
    celdas_gray_rgb = imread(ruta + string(Esc_act) + '_' + string(contador_im) + string(formato));

    celdas_gray = im2gray(celdas_gray_rgb);
    
    % Se guarda la imagen con una profundidad de 8 bits:
    % Ruta de la carpeta en la que se desean guardar las nuevas imágenes:
    ruta = "" % #######################################################
    fileName = ruta + string(Esc_act) + '_' + string(contador_im) + string(formato);

    imwrite(celdas_gray,  fileName);

    time = toc;  
    % Se almacena el tiempo empleado por cada calculo de mapa de potencia:
    time_pot(Esc_act, contador_im) = time;

    % Muestra en pantalla las simulaciones realizadas:
    formatOut1 = 'HH:MM';
    horaAct = datestr(now, formatOut1);
    disp(['Mapa ', num2str(contador_im), ' de ', num2str(imagenes),  ...
        ',  escenario ',  ...
        num2str(Esc_act), ' de ',  num2str(cant_esc), ',  tiempo de ejecución: '...
        , num2str(time/60), ' minutos,  hora: ', num2str(horaAct)])
    
    % Se incrementan los contadores de escenarios por plano y de escenarios
    % simulados:
    contador_im = contador_im + 1;
    
    % Se da lugar al inicio de un nuevo calculo de mapa de potencia y
    % cuando se tienen todos los mapas de potencias por escenario,  se hace
    % un cambio de plano:
    if contador_im == imagenes + 1
        contador_im = 1;
        Esc_act = Esc_act + 1;
        if Esc_act <= cant_esc   
            % Ruta de la carpeta en la que se encuentran almacenadas las imágenes de los escenarios (diseñados inicialmente):
            ruta = "" % #######################################################
            plain1 = imread(ruta + string(Esc_act) + '.JPG');
            plain(:, :, 1) = plain1;
            plain(:, :, 2) = plain1;
            plain(:, :, 3) = plain1;
        end
    end
end

close all 

% Ruta en la que se desea almacenar la matriz de los tiempos de ejecución:
ruta = "" % #######################################################
save(ruta, 'time_pot');
