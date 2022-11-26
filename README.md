# Estimación Rápida de Mapas de Radio en Escenarios Interiores Usando Deep Learning.
En esta investigación, se presenta la arquitectura de Deep Learning [UNet](https://arxiv.org/abs/1505.04597) para la estimación rápida de mapas de radio en escenarios interiores. Esta arquitectura fue implementada para estructuras WLAN conformadas por 1, 2 y 3 puntos de acceso, la cual tiene la capacidad de realizar estimaciones de los mapas de cobertura, de forma similar que un simulador físico, pero de forma rápida. De la misma manera, tiene la capacidad de estimar los respectivos mapas de celdas, para las estructuras descritas.

Un punto de referencia importante en el estado del arte fue [RadioUNet](https://github.com/RonLevie/RadioUNet), que es una aplicación para estimar la pérdida de trayectoria de propagación en escenarios exteriores.

### Estructura general de la base de datos creada.

Una gran díficultad inicial para el incio de la investigación, fue la falta de datos, en este caso, escenarios, mapas de cobertura y de celdas de interiores, para el entrenamiento de la estructura [UNet](https://arxiv.org/abs/1505.04597). Por lo que fue necesario realizar la creación de una base de datos adecuada, que diera lugar a los respectivos entrenamientos. Dichos mapas de cobertura, se generaron utilizando el modelo [WiFi IEEE](https://mentor.ieee.org/802.11/dcn/03/11-03-0940-04-000n-tgn-channel-models.doc). Dicha implementación se realizó en el software MATLAB y se dejan a disposición los [códigos](https://github.com/johanflorez98/Estimacion-Rapida-de-Mapas-de-Radio-en-Escenarios-Interiores-usando-Deep-Learning/tree/main/Archivos%20MATLAB).

Es por lo anterior, que la presente investigación, aporta una [base datos](https://drive.google.com/file/d/19l6GrUhRt5eMBTMf8on6Jbc2Pyxx7iQC/view?usp=sharing) que puede ser usada para el entrenamiento de múltiples arquitecturas de Deep Learning y con ella se podrían llevar a cabo investigaciones futuras de problemas similares.

En la siguiente tabla se específica la estructura de la base de datos creada.

| Datos                         | Cantidad                                              |
| ----------------------------  | -----------------------------------------------------:|
| Escenarios                    | 10                                                    |
| Puntos de acceso              | 1, 2, 3, 4 y 5                                        |
| Simulaciones x Escenario      | 1000                                                  |
| ----------------------------  | ----------------------------------------------------- |
| Puntos de acceso              | (1000 + 2000 + 3000 + 4000 + 5000) x 10 = 150000      |
| Mapas de cobertura            | (1000 + 1000 + 1000 + 1000 + 1000) x 10 = 50000       |
| Mapas de celdas               | (1000 + 1000 + 1000 + 1000) x 10 = 40000              |
| ----------------------------  | ----------------------------------------------------- |
| Total                         | 240000                                                |

Se establecieron 10 contrucciones de 20 m x 20 m, las cuales representan algunas de las distribuciones de escenarios de oficinas más comúnes. Para cada uno de los escenarios, se establecieron diferentes estructuras de WLAN conformadas por 1, 2 y 3 puntos de acceso, de las cuales para cada caso, se definieron 1000 posiciones aleatorias por cada construcción.

Es importante mencionar que cada una de las imágenes generadas tienen un tamaño de 256 px  x 256 px y una profundidad de 8 bits. Así mismo, se determinó que para los casos en los que se tienen 2 y 3 puntos de acceso era necesario que cada una de las posiciones definidas fuera representada en una imágen independiente, por esto se generaron 1000 imágenes para 1 punto de acceso, 2000 para 2 puntos de acceso y 3000 para 3 puntos de acceso, por cada construcción, para un total de 60000 imágenes, en las que la posición del punto de acceso se representa con un píxel en blanco o con un valor de 255.

Se generaron 1000 imágenes de mapas de cobertura, para cada estructura de WLAN por cada unos de los escenarios, para un total de 30000 imágenes, en las que el máximo valor se representa como 255, es decir la potencia máxima entregada por los puntos de acceso es representada mediante este valor y este decade de acuerdo a los obstaculos encontrados a los largo de cada escenario.

En el mismo sentido, se generaron 1000 imágenes de mapas de celdas para los casos en los que establecen 2 y 3 puntos de acceso por cada unos de los escenarios, para un total de 20000 imágenes de mapas de celdas. Es importante mencionar que para el caso en el que se tiene 1 punto de acceso no se consideró la creación del respectivo mapa de celda debido a que este está representado por el total del área de cada escenario.

Finalmente, se logró la conformación de una base de datos con 110000 imagénes a ser utilizadas como entradas y salidas de la arquitectura.

### Visualización de algunas imágenes que conforman la base de datos

Se muestran algunas imágenes aleatorias de los respectivos mapas de cobertura para 1, 2 y 3 puntos de acceso, así como los mapas de celdas para 2 y 3 puntos de acceso. En los mapas de cobertura se puede observar la distribución de los escenarios a nivel de las paredes que los conforman, así como las posiciones de los puntos de acceso para cada caso. Así mismo, en los mapas de celdas, se muestra el área de funcionamiento de cada uno, respectivamente.

![Mapa de cobertura con 1 punto de acceso.](https://github.com/johanflorez98/Estimacion-Rapida-de-Mapas-de-Radio-en-Escenarios-Interiores-usando-Deep-Learning/blob/main/Imagenes%20Readme/Cobertura_1.png)
![Mapa de cobertura con 2 punto2 de acceso.](https://github.com/johanflorez98/Estimacion-Rapida-de-Mapas-de-Radio-en-Escenarios-Interiores-usando-Deep-Learning/blob/main/Imagenes%20Readme/Cobertura_2.png)
![Mapa de cobertura con 3 puntos de acceso.](https://github.com/johanflorez98/Estimacion-Rapida-de-Mapas-de-Radio-en-Escenarios-Interiores-usando-Deep-Learning/blob/main/Imagenes%20Readme/Cobertura_3.png)

![Mapa de celdas con 2 puntos de acceso.](https://github.com/johanflorez98/Estimacion-Rapida-de-Mapas-de-Radio-en-Escenarios-Interiores-usando-Deep-Learning/blob/main/Imagenes%20Readme/Celdas_2.png) 
![Mapa de celdas con 3 puntos de acceso.](https://github.com/johanflorez98/Estimacion-Rapida-de-Mapas-de-Radio-en-Escenarios-Interiores-usando-Deep-Learning/blob/main/Imagenes%20Readme/Celdas_3.png)

## Estimador de los mapas de cobertura y de celdas

Se realizó la implementación de múltiples arquitecturas [UNet](https://arxiv.org/abs/1505.04597) utilizando el framework Keras. Los [códigos](https://github.com/johanflorez98/Estimacion-Rapida-de-Mapas-de-Radio-en-Escenarios-Interiores-usando-Deep-Learning/tree/main/C%C3%B3digos) disponibles fueron adecuados para generar modelos capaces de adaptarse a cada caso, es decir, de realizar procesos de entrenamiento para 1, 2 y 3 puntos de acceso en los casos de mapas de cobertura y para 2 y 3 puntos de acceso para los mapas de celdas.

### 1. Modelo de predicción para mapas de cobertura con 1 punto de acceso:

Una vez entrenado un modelo para predicción del mapa de cobertura con un punto de acceso, se muestra en la siguiente imagen la variación de la función de pérdida:

![Variación de la función de pérdida durante el entrenamiento.](https://github.com/johanflorez98/Estimacion-Rapida-de-Mapas-de-Radio-en-Escenarios-Interiores-usando-Deep-Learning/blob/main/Imagenes%20Readme/Loss_maps_1.PNG) 

Lo anterior permite observar que se alcanza un valor de la función de pérdida muy cercano a cero, lo que quiere decir que el modelo se ajusta de forma correcta a la estimación esperada.

Las siguientes imágenes muestran la evaluación del modelo, indicando la entrada (se ignoran las posiciones de los puntos de acceso al ser poco observable en la imagen, se considera solo el plano del escenario) la salida esperada y la obtenida:

![Evaluación del modelo para la estimación de mapas de cobertura con un punto de acceso.](https://github.com/johanflorez98/Estimacion-Rapida-de-Mapas-de-Radio-en-Escenarios-Interiores-usando-Deep-Learning/blob/main/Imagenes%20Readme/eval_maps_1.png) 

Se observa que el modelo se ajusta de forma adecuada a la estimación del mapa de cobertura.

### 2. Modelo de predicción para mapas de cobertura con 2 puntos de acceso:

Una vez entrenado un modelo para predicción del mapa de cobertura con dos puntos de acceso, se muestra en la siguiente imagen la variación de la función de pérdida:

![Variación de la función de pérdida durante el entrenamiento.](https://github.com/johanflorez98/Estimacion-Rapida-de-Mapas-de-Radio-en-Escenarios-Interiores-usando-Deep-Learning/blob/main/Imagenes%20Readme/Loss_maps_2.jpg) 

Lo anterior permite observar que se alcanza un valor de la función de pérdida muy cercano a cero, lo que quiere decir que el modelo se ajusta de forma correcta a la estimación esperada.

Las siguientes imágenes muestran la evaluación del modelo, indicando la entrada (se ignoran las posiciones de los puntos de acceso al ser poco observable en la imagen, se considera solo el plano del escenario) la salida esperada y la obtenida:

![Evaluación del modelo para la estimación de mapas de cobertura con dos puntos de acceso.](https://github.com/johanflorez98/Estimacion-Rapida-de-Mapas-de-Radio-en-Escenarios-Interiores-usando-Deep-Learning/blob/main/Imagenes%20Readme/eval_maps_2.png) 

Se observa que el modelo se ajusta de forma adecuada a la estimación del mapa de cobertura.

### 3. Modelo de predicción para mapas de cobertura con 3 puntos de acceso:

Una vez entrenado un modelo para predicción del mapa de cobertura con tres puntos de acceso, se muestra en la siguiente imagen la variación de la función de pérdida:

![Variación de la función de pérdida durante el entrenamiento.](https://github.com/johanflorez98/Estimacion-Rapida-de-Mapas-de-Radio-en-Escenarios-Interiores-usando-Deep-Learning/blob/main/Imagenes%20Readme/Loss_maps_3.jpg) 

Lo anterior permite observar que se alcanza un valor de la función de pérdida muy cercano a cero, lo que quiere decir que el modelo se ajusta de forma correcta a la estimación esperada.

Las siguientes imágenes muestran la evaluación del modelo, indicando la entrada (se ignoran las posiciones de los puntos de acceso al ser poco observable en la imagen, se considera solo el plano del escenario) la salida esperada y la obtenida:

![Evaluación del modelo para la estimación de mapas de cobertura con tres puntos de acceso.](https://github.com/johanflorez98/Estimacion-Rapida-de-Mapas-de-Radio-en-Escenarios-Interiores-usando-Deep-Learning/blob/main/Imagenes%20Readme/eval_maps_3.png) 

Se observa que el modelo se ajusta de forma adecuada a la estimación del mapa de cobertura.

### 4. Modelo de predicción para mapas de celdas con 2 puntos de acceso:

Una vez entrenado un modelo para predicción del mapa de celdas con dos puntos de acceso, se muestra en la siguiente imagen la variación de la función de pérdida:

![Variación de la función de pérdida durante el entrenamiento.](https://github.com/johanflorez98/Estimacion-Rapida-de-Mapas-de-Radio-en-Escenarios-Interiores-usando-Deep-Learning/blob/main/Imagenes%20Readme/Loss_cells_2.jpg) 

Lo anterior permite observar que se alcanza un valor de la función de pérdida muy cercano a cero, lo que quiere decir que el modelo se ajusta de forma correcta a la estimación esperada.

En el mismo sentido, en la siguiente imagen se puede observar el accuraccy alcanzado (esta medida se toma ya que es un problema de clasificación de píxel a píxel):

![Accuraccy durante el entrenamiento.](https://github.com/johanflorez98/Estimacion-Rapida-de-Mapas-de-Radio-en-Escenarios-Interiores-usando-Deep-Learning/blob/main/Imagenes%20Readme/acc_cells_2.png) 

Se obtuvo un accuraccy adecuado para la clasificación de los píxeles.

Las siguientes imágenes muestran la evaluación del modelo, indicando la entrada (se ignoran las posiciones de los puntos de acceso al ser poco observable en la imagen, se considera solo el plano del escenario) la salida esperada y la obtenida:

![Evaluación del modelo para la estimación de mapas de celdas con dos puntos de acceso.](https://github.com/johanflorez98/Estimacion-Rapida-de-Mapas-de-Radio-en-Escenarios-Interiores-usando-Deep-Learning/blob/main/Imagenes%20Readme/eval_cells_2.png) 

Se observa que el modelo se ajusta de forma adecuada a la estimación del mapa de celdas.

### 5. Modelo de predicción para mapas de celdas con 3 puntos de acceso:

Una vez entrenado un modelo para predicción del mapa de celdas con tres puntos de acceso, se muestra en la siguiente imagen la variación de la función de pérdida:

![Variación de la función de pérdida durante el entrenamiento.](https://github.com/johanflorez98/Estimacion-Rapida-de-Mapas-de-Radio-en-Escenarios-Interiores-usando-Deep-Learning/blob/main/Imagenes%20Readme/Loss_cells_3.jpg) 

Lo anterior permite observar que se alcanza un valor de la función de pérdida muy cercano a cero, lo que quiere decir que el modelo se ajusta de forma correcta a la estimación esperada.

En el mismo sentido, en la siguiente imagen se puede observar el accuraccy alcanzado (esta medida se toma ya que es un problema de clasificación de píxel a píxel):

![Accuraccy durante el entrenamiento.](https://github.com/johanflorez98/Estimacion-Rapida-de-Mapas-de-Radio-en-Escenarios-Interiores-usando-Deep-Learning/blob/main/Imagenes%20Readme/acc_cells_3.png) 

Se obtuvo un accuraccy adecuado para la clasificación de los píxeles.

Las siguientes imágenes muestran la evaluación del modelo, indicando la entrada (se ignoran las posiciones de los puntos de acceso al ser poco observable en la imagen, se considera solo el plano del escenario) la salida esperada y la obtenida:

![Evaluación del modelo para la estimación de mapas de celdas con tres puntos de acceso.](https://github.com/johanflorez98/Estimacion-Rapida-de-Mapas-de-Radio-en-Escenarios-Interiores-usando-Deep-Learning/blob/main/Imagenes%20Readme/eval_cells_3.png) 

Se observa que el modelo se ajusta de forma adecuada a la estimación del mapa de celdas.


Es importante notar, que para los modelos obtenidos, estos alcanzan un alto grado de generalización para estimar cada estructura de manera adecuada. De la misma manera a pesar de las variaciones las métricas utilizadas, se guardó para cada caso el mejor modelo.

