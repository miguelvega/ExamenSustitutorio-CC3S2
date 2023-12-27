# RESPUESTAS

En primera instancia realizamos la migracion y cargamos los datos en la tabla movies de nuestra base de datos con el comando bundle exec rake db:seed, luego ejecutamos rails server y tenemos lo siguiente:

![Captura de pantalla de 2023-12-27 07-24-52](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/63c62021-b838-4e94-b6bd-fc38e05ff8f6)

Ejucutamos el comando bundle exec rake db:test:prepare y verificamos que Cucumber esté configurado correctamente ejecutando cucumber. Al ejecutar bundle exec cucumber features/movies_by_director.feature . El primer fallo de prueba en un escenario debería ser: Undefined step: the director of "Alien" should be "Ridley Scott "

![Captura de pantalla de 2023-12-27 07-57-52](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/0fe689a3-bcb8-44f4-bdad-f537a308e31d)

### ¿Qué tendrás que hacer para solucionar ese error específico?

Podemos agregar el campo director a la tabla movies, ya que nuestro esquema actual de nuestra tabla no tiene ese campo.

### Agrega un campo Director a Movies (1 punto)
De la sugerencia usaremos el método add_column de ActiveRecord::Migration con lo cual agregaremos una columna a nuestra tabla movies

```ruby
class AddDirectorToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :director, :string
  end
end

```

Ejecutamos el comando bundle exec rake db:migrate para cambiar la estructura de nuestra tabla agregando una nueva columna y cargandola en nuestra  base de dato.

![Captura de pantalla de 2023-12-27 09-33-20](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/d770af13-7080-436f-b8a5-2423f09a7c6e)

Con lo cual ahora agregamos ese nuevo campo en las vistas : 

index.html.erb:

```
<!--  This file is app/views/movies/index.html.erb -->
<h2>All Movies</h2>

<%#  Part 2: Start here... %>

<table class="table table-striped col-md-12" id="movies">
  <thead>
    <tr>
      <th>Movie Title</th>
      <th>Rating</th>
      <th>Release Date</th>
      <th>Director</th>
      <th>More Info</th>
    </tr>
  </thead>
  <tbody>
    <% @movies.each do |movie| %>
      <tr>
        <td>
          <%= movie.title %>
        </td>
        <td>
          <%= movie.rating %>
        </td>
        <td>
          <%= movie.release_date %>
        </td>
        <td>
          <%= movie.director %>
        </td>
        <td>
          <%= link_to "More about #{movie.title}", movie_path(movie) %>
        </td>
      </tr>
    <% end %>
  </tbody>
</table>
<%= link_to 'Add new movie', new_movie_path, :class => 'btn btn-primary' %>

```


![Captura de pantalla de 2023-12-27 09-55-02](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/136f2299-d61f-411e-9edf-776bd946f87b)

show.html.erb:

```
<!--  app/views/movies/show.html.erb -->
<h2>Details about <em><%= @movie.title %></em></h2>

<ul id="details">
  <li>
    Rating:
    <%= @movie.rating %>
  </li>
  <li>
    Released on:
    <%= @movie.release_date.strftime("%B %d, %Y") %>
  </li>
  <li>
    Director:
    <%= @movie.director %>
  </li>
</ul>

<h3>Description:</h3>
<p id="description">
  <%= @movie.description %>
</p>

<div class="row">
  <%= link_to 'Edit', edit_movie_path(@movie), :class => 'btn btn-primary col-2' %>
  <%= link_to 'Delete', movie_path(@movie), 'data-method' => 'delete', 'data-confirm' => 'Are you sure?', :class => 'btn btn-danger col-2' %>
  <%= link_to 'Back to movie list', movies_path, :class => 'btn btn-primary col-2' %>
</div>

``` 

![Captura de pantalla de 2023-12-27 09-55-08](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/526dc62f-5186-474f-b148-49751890fcc7)

new.html.erb:


```
<h2>Create New Movie</h2>

<%= form_tag movies_path, class: 'form' do %>
  <%= label :movie, :title, 'Title', class:'col-form-label' %>
  <%= text_field :movie, :title, class: 'form-control' %>
  <%= label :movie, :rating, 'Rating', class: 'col-form-label'  %>
  <%= select :movie, :rating, ['G','PG','PG-13','R','NC-17'], {}, {class: 'form-control col-1'} %>
  <%= label :movie, :release_date, 'Released On', class: 'col-form-label' %>
  <%= date_select :movie, :release_date, {}, class: 'form-control col-2 d-inline' %>
  <br/>
  <%= label :movie, :director, 'Director', class: 'col-form-label' %>
  <%= text_field :movie, :director, class: 'form-control' %>
  <br/>
  <%= submit_tag 'Save Changes', class: 'btn btn-primary' %>
  <%= link_to 'Cancel', movies_path, class: 'btn btn-secondary' %>
<% end %>


```
![Captura de pantalla de 2023-12-27 09-55-25](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/7928abbf-7804-4ca8-aeaa-72d2ba2ebde1)


edit.html.erb

```
<h2>Edit Existing Movie</h2>
<%= form_tag movie_path(@movie), method: :put do %>
  <%= label :movie, :title, 'Title', class: 'col-form-label' %>
  <%= text_field :movie, 'title', class: 'form-control' %>
  <%= label :movie, :rating, 'Rating', class: 'col-form-label' %>
  <%= select :movie, :rating, ['G','PG','PG-13','R','NC-17'], {}, {class: 'form-control col-1'} %>
  <%= label :movie, :release_date, 'Released On', class: 'col-form-label' %>
  <%= date_select :movie, :release_date, {}, class: 'form-control col-2 d-inline' %>
  <br/>
  <%= label :movie, :director, 'Director', class: 'col-form-label' %>
  <%= text_field :movie, :director, class: 'form-control' %>
  <br/>
  <%= submit_tag 'Update Movie Info', class: 'btn btn-primary' %>
  <%= link_to 'Cancel', movies_path, class: 'btn btn-secondary' %>
<% end %>


```


![Captura de pantalla de 2023-12-27 09-55-14](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/3918de28-ee1f-444f-adb3-9131f4913c1c)



## Parte 2: Ruby on Rails

### Pregunta 1 (1 punto)
¿Por qué la abstracción de un objeto de formulario pertenece a la capa de presentación y no a la capa
de servicios (o inferior)?

Porque el objeto interactua con interfaces que van a servir informacion al usuario, con lo cual permite que el usuario se comunique con la aplicacion, por tal motivo pertenece a la capa de presentacion.

### Pregunta 2 (1 punto)
¿Cuál es la diferencia entre autenticación y autorización?

La autenticacion es el paso necesario para determinar si el usuario es quien dice ser, mientras que la autorizacion se da cuando una vez autenticado se le permite al usuario acceder a ciertas partes de un todo.

### Pregunta 3 (2 puntos)
Un middleware es un componente que envuelve la ejecución de una unidad central (función) y puede inspeccionar y modificar datos de entrada y salida sin cambiar su interfaz. El middleware suele estar encadenado, por lo que cada uno invoca al siguiente y sólo el último de la cadena ejecuta la lógica central. El encadenamiento tiene como objetivo mantener el middleware pequeño y de un solo
propósito.
Ejecutamos bundle exec rake  middleware y tenemos la siguiente informacion:

![Captura de pantalla de 2023-12-27 08-40-26](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/53d7ef5e-eab2-4cdf-8b71-6fa89b8188b8)


Aprendimos que manejar una solicitud web implica miles de llamadas a métodos y objetos Ruby asignados.
¿Qué pasa si omite el middleware de Rack y se pasa la solicitud al enrutador directamente (Rails.application.routes.call(request))? 

El middleware de Rack es más que "una forma de filtrar una solicitud y una respuesta": es una implementación del patrón de diseño de canalización para servidores web. Si se omite el middleware de Rack y pasa la solicitud al enrutador directamente, entonces no se va separar muy claramente las diferentes etapas del procesamiento de una solicitud, ademas la separación de preocupaciones es un objetivo clave de todos los productos de software bien diseñados, ya que es de gran ayuda para tener etapas separadas del proceso:

- Autenticación
- Autorización
- Almacenamiento en caché
- Decoración
- Monitoreo de uso y rendimiento
- Ejecución

¿Qué pasa si se omite el enrutador y llamar a una acción del controlador de inmediato (por ejemplo, PostsController.action(:index).call(request))?

Cuando omitimos el enrutador y llamamos directamente a una acción del controlador usando PostsController.action(:index).call(request), estamos eludiendo el proceso normal de enrutamiento de Rails, es decir no se aplicarán las rutas definidas en el archivo routes.rb, ademas  estamos llamando directamente a la acción del controlador. Con lo cual, no estamos aprovechando las funcionalidades proporcionadas por el marco, debemos manejar manualmente la lógica de la ruta  y pasar los parámetros de la solicitud necesarios a la acción del controlador.


## Parte 3: JavaScript
### Pregunta1 (2 puntos)
Crea varias funciones que te permitirán interactuar con las cookies de la página, incluida la lectura de un valor de cookie por nombre, la creación de una nueva cookie usando un nombre y su configuración para una cantidad determinada de días, y la eliminación de una cookie.
Configura tu página web y, en el código JavaScript, genera el valor de documento.cookie que debería estar en blanco. Intenta eliminar un cookie por su nombre.



    
