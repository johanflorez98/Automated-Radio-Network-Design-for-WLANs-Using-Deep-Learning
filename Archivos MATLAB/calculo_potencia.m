function PR = calculo_potencia(AP,plain2,...
    x_imagen,y_imagen,x_metros,y_metros,c_luz,...
    PT,GT,GR,F,dpq,P_Paredes,j,i)
    
    % Inicia el calculo de las rutas diagonales entre usuarios y
    % APs, según la distancia más corta:
    AP = fliplr(AP);
    
    if i >= AP(1,1)

       A = improfile(plain2,[AP(1,1) i],[AP(1,2) j]);
       cont = 0;
       for c = 2:length(A)
           diferencia = A(c,1) - A(c-1,1);
           if diferencia < 0
              cont = cont + 1;
           end
       end
       paredes = cont;
    end

    if i < AP(1,1)

       A = improfile(plain2,[i AP(1,1)],[j AP(1,2)]);
       cont = 0;
       for c = 2:length(A)
           diferencia = A(c,1) - A(c-1,1);
           if diferencia < 0
              cont = cont + 1;
           end
       end
       paredes = cont;
    end
    m = paredes;
    D = norm([AP(1,1)*x_metros/x_imagen AP(1,2)*y_metros/y_imagen] ...
        - [i*x_metros/x_imagen j*y_metros/y_imagen]);

    % Se cálcula la potencia en cada punto, aplicando el modelo WiFi:
    if D <= dpq
        PR = PT + GT + GR + 20*log10(c_luz/(4*pi)) - 20*log10(F) - 20*log10(D) - P_Paredes*m;
    end
    if D > dpq
        PR = PT + GT + GR + 20*log10(c_luz/(4*pi)) - 20*log10(F) - 20*log10(D) - P_Paredes*m - 35*log10(D/dpq);
    end

    if PR == inf 
        PR = PT;
    end

end
