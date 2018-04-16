# Taller de mallas poligonales

## Propósito

Estudiar la relación entre las [aplicaciones de mallas poligonales](https://github.com/VisualComputing/representation), su modo de [representación](https://en.wikipedia.org/wiki/Polygon_mesh) (i.e., estructuras de datos empleadas para representar la malla en RAM) y su modo de [renderizado](https://processing.org/tutorials/pshape/) (i.e., modo de transferencia de la geometría a la GPU).

## Tareas

Hacer un benchmark (midiendo los *fps* promedio) de varias representaciones de mallas poligonales para los _boids_ del ejemplo del [FlockOfBoids](https://github.com/VisualComputing/framesjs/tree/processing/examples/Advanced/FlockOfBoids) (requiere la librería [frames](https://github.com/VisualComputing/framesjs/releases), versión ≥ 0.1.0), tanto en modo inmediato como retenido de rendering.


1. Represente la malla del [boid](https://github.com/VisualComputing/framesjs/blob/processing/examples/Advanced/FlockOfBoids/Boid.pde) al menos de tres formas distintas.
2. Renderice el _flock_ en modo inmediato y retenido, implementando la función ```render()``` del [boid](https://github.com/VisualComputing/framesjs/blob/processing/examples/Advanced/FlockOfBoids/Boid.pde).
3. Haga un benchmark que muestre una comparativa de los resultados obtenidos.

### Desarrollo
1. Para la representación de la malla se implementaron las formas ``` Face-vertex ``` y ``` Vertex-Vertex```

2. Para las representaciones mencionadas anteriormente se implementarion los modos _inmediato_ y _retenido_ requeridos.

3. Para realizar la comparativa se definieron las siguientes pruebas a realizar:

    * Para cada modo ( _inmediato_ y _retenido_ )
        * Por cada representación ( _face-vertex_ y _vertex_vertex_ )
            * Realizar una prueba con los valores de _n_ E { 250,500,1000,2000 }, donde _n_ es el número de boids.


    Se obtuvieron los siguientes resultados:

    En la primera máquina que se ejecutó la cual tenía las siguietes características:

*   Memory: 7.6 GiB
* Processor Intel(R) Core(TM) i5-3337U CPU @ 1.80GHz
* Graphics: NVIDIA Corporation GK208M [GeForce GT 720M] 
* OS Type: 64 - bit
* OS: Fedora release 27 (Twenty Seven)
* Openjdk version 1.8.0_162


| num boids | Immediate   | Immediate     | Retained    | Retained      |
|-----------|-------------|---------------|-------------|---------------|
|        #    | Face-vertex | Vertex-Vertex | Face-vertex | Vertex-Vertex |
|    250    |     44.1    |       59      |     7.3     |       57      |
|    500    |      18     |       27      |     3.7     |      26.5     |
|    1000   |     8.3     |       11      |     1.7     |       10      |
|    2000   |     3.1     |      4.3      |     0.9     |      3.3      |


En la segunda máquina, que tenia las siguientes características

* Memory: 5,7 GiB
* Processor Intel® Core™ i5-2430M CPU @ 2.40GHz × 4
* Graphics: Intel® Sandybridge Mobile
* OS Type: 64 - bit
* OS: Ubuntu 16.04 LTS
* Java version "1.8.0_161"

Se obtivuieron los siguientes resultados

| num boids | Immediate   | Immediate     | Retained    | Retained      |
|-----------|-------------|---------------|-------------|---------------|
|        #    | Face-vertex | Vertex-Vertex | Face-vertex | Vertex-Vertex |
|    250    |     28    |       42      |     7.8     |       38      |
|    500    |      14     |       19.5      |     3.6     |      20     |
|    1000   |     5     |       7      |     1.7     |       6      |
|    2000   |     2     |      3.7      |     0     |      2.5      |


### Opcionales

1. Realice la comparativa para diferentes configuraciones de hardware.
2. Realice la comparativa de *fps* sobre una trayectoria de animación para el ojo empleando un [interpolator](https://github.com/VisualComputing/framesjs/tree/processing/examples/Basics/B8_Interpolation2) (en vez de tomar su promedio).
3. Anime la malla, como se hace en el ejemplo de [InteractiveFish](https://github.com/VisualComputing/framesjs/tree/processing/examples/ik/InteractiveFish).
4. Haga [view-frustum-culling](https://github.com/VisualComputing/framesjs/tree/processing/examples/Demos/ViewFrustumCulling) de los _boids_ cuando el ojo se encuentre en tercera persona.

### Profundizaciones

1. Introducir el rol depredador.
2. Cómo se afecta el comportamiento al tener en cuenta el [campo visual](https://es.wikipedia.org/wiki/Campo_visual) (individual)?
3. Implementar el algoritmo del ```flock()``` en [OpenCL](https://en.wikipedia.org/wiki/OpenCL). Ver [acá](https://www.youtube.com/watch?v=4NU37rPOAsk) un ejemplo de *Processing* en el que se que emplea [JOCL](http://www.jocl.org/).

### References

1. [Reynolds, C. W. Flocks, Herds and Schools: A Distributed Behavioral Model. 87](http://www.cs.toronto.edu/~dt/siggraph97-course/cwr87/).
2. Check also this [nice presentation](https://pdfs.semanticscholar.org/73b1/5c60672971c44ef6304a39af19dc963cd0af.pdf) about the paper:
3. There are many online sources, google for more...

## Integrantes

Máximo 3.

Complete la tabla:

| Integrante | github nick |
|------------|-------------|
|Andres Rondon| [amrondonp](https://github.com/amrondonp)             |
|Raul Ramirez| [raulramirezp](https://github.com/raulramirezp)             |
|Juan Carlos Gama| [JuanCarlosUNAL](https://github.com/JuanCarlosUNAL)             |


## Entrega

* Modo de entrega: Haga [fork](https://help.github.com/articles/fork-a-repo/) de la plantilla e informe la url del repo en la hoja *urls* de la plantilla compartida (una sola vez por grupo). Plazo: 15/4/18 a las 24h.
* Exposición oral en el taller de la siguiente semana.
