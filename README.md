# Estimación Rápida de Mapas de Radio en Escenarios Interiores Usando Deep Learning.
En esta investigación, se presenta la arquitectura de Deep Learning [UNet](https://arxiv.org/abs/1505.04597) para la estimación rápida de mapas de radio en escenarios interiores. Esta arquitectura fue implementada para estructuras WLAN conformadas por 1, 2 y 3 puntos de acceso, la cual tiene la capacidad de realizar estimaciones de los mapas de cobertura, de forma similar que un simulador físico, pero de forma rápida. De la misma manera, tiene la capacidad de estimar los respectivos mapas de celdas, para las estructuras descritas.

Un punto de referencia importante en el estado del arte fue [RadioUNet](https://github.com/RonLevie/RadioUNet), que es una aplicación para estimar la pérdida de trayectoria de propagación en escenarios exteriores.

#### Estructura general de la base de datos creada.

Una gran díficultad inicial para el incio de la investigación, fue la falta de datos, en este caso, escenarios, mapas de cobertura y de celdas de interiores, para el entrenamiento de la estructura [UNet](https://arxiv.org/abs/1505.04597). Por lo que fue necesario realizar la creación de una base de datos adecuada, que diera lugar a los respectivos entrenamientos. Dichos mapas de cobertura, se generaron utilizando el modelo [WiFi IEEE](https://mentor.ieee.org/802.11/dcn/03/11-03-0940-04-000n-tgn-channel-models.doc). Dicha implementación se realizó en el software MATLAB y se dejan a disposición los [códigos](https://github.com/johanflorez98/Estimacion-Rapida-de-Mapas-de-Radio-en-Escenarios-Interiores-usando-Deep-Learning/tree/main/Archivos%20MATLAB).

Es por lo anterior, que la presente investigación, aporta una [base datos](https://drive.google.com/drive/folders/17ann1zRG3JtVQTSib1voEYGlmOFDSOTR?usp=sharing) que puede ser usada para el entrenamiento de múltiples arquitecturas de Deep Learning y con ella se podrían llevar a cabo investigaciones futuras de problemas similares.

En la siguiente tabla se específica la estructura de la base de datos creada.

| Datos                         | Cantidad                                |
| ----------------------------  | ---------------------------------------:|
| Escenarios                    | 10                                      |
| Puntos de acceso              | 1, 2 y 3                                |
| Simulaciones x Escenario      | 1000                                    |
| ----------------------------  | --------------------------------------- |
| Puntos de acceso              | (1000 + 2000 + 3000) x 10 = 60000       |
| Mapas de cobertura            | (1000 + 1000 + 1000) x 10 = 30000       |
| Mapas de celdas               | (1000 + 1000) x 10 = 20000              |
| ----------------------------  | --------------------------------------- |
| Total                         | 110000                                  |

Se establecieron 10 contrucciones de 20 m x 20 m, las cuales representan algunas de las distribuciones de escenarios de oficinas más comúnes. Para cada uno de los escenarios, se establecieron diferentes estructuras de WLAN conformadas por 1, 2 y 3 puntos de acceso, de las cuales para cada caso, se definieron 1000 posiciones aleatorias por cada construcción.

Es importante mencionar que cada una de las imágenes generadas tienen un tamaño de 256 px  x 256 px y una profundidad de 8 bits. Así mismo, se determinó que para los casos en los que se tienen 2 y 3 puntos de acceso era necesario que cada una de las posiciones definidas fuera representada en una imágen independiente, por esto se generaron 1000 imágenes para 1 punto de acceso, 2000 para 2 puntos de acceso y 3000 para 3 puntos de acceso, por cada construcción, para un total de 60000 imágenes, en las que la posición del punto de acceso se representa con un píxel en blanco o con un valor de 255.

Se generaron 1000 imágenes de mapas de cobertura, para cada estructura de WLAN por cada unos de los escenarios, para un total de 30000 imágenes, en las que el máximo valor se representa como 255, es decir la potencia máxima entregada por los puntos de acceso es representada mediante este valor y este decade de acuerdo a los obstaculos encontrados a los largo de cada escenario.

En el mismo sentido, se generaron 1000 imágenes de mapas de celdas para los casos en los que establecen 2 y 3 puntos de acceso por cada unos de los escenarios, para un total de 20000 imágenes de mapas de celdas. Es importante mencionar que para el caso en el que se tiene 1 punto de acceso no se consideró la creación del respectivo mapa de celda debido a que este está representado por el total del área de cada escenario.

Finalmente, se logró la conformación de una base de datos con 110000 imagénes a ser utilizadas como entradas y salidas de la arquitectura.

#### Visualización de algunas imágenes que conforman la base de datos

Se muestran algunas imágenes aleatorias de los respectivos mapas de cobertura para 1, 2 y 3 puntos de acceso, así como los mapas de celdas para 2 y 3 puntos de acceso. En los mapas de cobertura se puede observar la distribución de los escenarios a nivel de las paredes que los conforman, así como las posiciones de los puntos de acceso para cada caso.

[![Mapa de cobertura con 1 punto de acceso.](https://drive.google.com/file/d/1Xm6OWb1VljDEYVkpDGqllIgHxGmnO_Kr/view?usp=sharing "Mapa de cobertura con 1 punto de acceso.")](https://drive.google.com/file/d/1Xm6OWb1VljDEYVkpDGqllIgHxGmnO_Kr/view?usp=sharing "Mapa de cobertura con 1 punto de acceso.")


