# RESPUESTAS

## Parte 1: El ciclo de prueba de aceptación- prueba unitaria
En primera instancia realizamos la migracion y cargamos los datos en la tabla movies de nuestra base de datos con el comando bundle exec rake db:seed, luego ejecutamos rails server y tenemos lo siguiente:

![Captura de pantalla de 2023-12-27 07-24-52](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/63c62021-b838-4e94-b6bd-fc38e05ff8f6)

Ejucutamos el comando bundle exec rake db:test:prepare y verificamos que Cucumber esté configurado correctamente ejecutando cucumber. Al ejecutar bundle exec cucumber features/movies_by_director.feature . El primer fallo de prueba en un escenario debería ser: Undefined step: the director of "Alien" should be "Ridley Scott "


![Captura de pantalla de 2023-12-27 07-51-37](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/b6ab65dc-b828-41b2-b133-beab284669e0)

![Captura de pantalla de 2023-12-27 07-51-45](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/637bc15f-c71a-485e-8994-cf05ccb8919e)

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

### Claramente, ahora que se ha agregado un nuevo campo, tendrás que modificar las Vistas paraque el usuario pueda ver e ingresar valores para ese campo. ¿También tienes que modificar el archivo del modelo para que "se note" el nuevo campo? . Muestra con ejemplos tu respuesta

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


Comprobamos la funcionalidad de nuestra aplicacion, ejecutamos `rails console` y listamos todas las peliculas con Movie.all y podemos apreciar que todos los campos de nuestras peliculas esta vacios.

```
Movie Load (0.6ms)  SELECT "movies".* FROM "movies"
 => #<ActiveRecord::Relation [#<Movie id: 1, title: "Aladdin", rating: "G", description: nil, release_date: "1992-11-25 00:00:00", created_at: "2023-12-27 12:22:59", updated_at: "2023-12-27 12:22:59", director: nil>, #<Movie id: 2, title: "The Terminator", rating: "R", description: nil, release_date: "1984-10-26 00:00:00", created_at: "2023-12-27 12:22:59", updated_at: "2023-12-27 12:22:59", director: nil>, #<Movie id: 3, title: "When Harry Met Sally", rating: "R", description: nil, release_date: "1989-07-21 00:00:00", created_at: "2023-12-27 12:22:59", updated_at: "2023-12-27 12:22:59", director: nil>, #<Movie id: 4, title: "The Help", rating: "PG-13", description: nil, release_date: "2011-08-10 00:00:00", created_at: "2023-12-27 12:22:59", updated_at: "2023-12-27 12:22:59", director: nil>, #<Movie id: 5, title: "Chocolat", rating: "PG-13", description: nil, release_date: "2001-01-05 00:00:00", created_at: "2023-12-27 12:22:59", updated_at: "2023-12-27 12:22:59", director: nil>, #<Movie id: 6, title: "Amelie", rating: "R", description: nil, release_date: "2001-04-25 00:00:00", created_at: "2023-12-27 12:22:59", updated_at: "2023-12-27 12:22:59", director: nil>, #<Movie id: 7, title: "2001: A Space Odyssey", rating: "G", description: nil, release_date: "1968-04-06 00:00:00", created_at: "2023-12-27 12:22:59", updated_at: "2023-12-27 12:22:59", director: nil>, #<Movie id: 8, title: "The Incredibles", rating: "PG", description: nil, release_date: "2004-11-05 00:00:00", created_at: "2023-12-27 12:22:59", updated_at: "2023-12-27 12:22:59", director: nil>, #<Movie id: 9, title: "Raiders of the Lost Ark", rating: "PG", description: nil, release_date: "1981-06-12 00:00:00", created_at: "2023-12-27 12:22:59", updated_at: "2023-12-27 12:22:59", director: nil>, #<Movie id: 10, title: "Chicken Run", rating: "G", description: nil, release_date: "2000-06-21 00:00:00", created_at: "2023-12-27 12:22:59", updated_at: "2023-12-27 12:22:59", director: nil>]> 

```
Mostramos especificamente los campos del registro de titulo The Terminator con el comando `movie = Movie.find_by(title: 'The Terminator')`

![Captura de pantalla de 2023-12-27 11-38-23](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/2c2d7438-4884-4f49-8e0f-d638685ff57b)

Y agregamos un director a la pelicula con  movie.update(director: 'James Cameron')

![Captura de pantalla de 2023-12-27 11-38-34](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/b676c153-9120-4309-b16e-ae3487c48ed4)

Vemos los cambios en el navegador

![Captura de pantalla de 2023-12-27 11-39-18](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/9f339f88-1d02-43f7-9265-3cb05e3a1fbe)

Tambien podemos editar el director de una pelicula directamente desde el navegador, colocando que el director de la pelicula Aladdin sera Viviana  :

![Captura de pantalla de 2023-12-27 11-47-40](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/888855b3-aff1-42ed-9e3f-b274be33aaa0)


![Captura de pantalla de 2023-12-27 11-43-45](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/22247069-366e-458d-82a0-5ef2183fb243)

Y podemos apreciar el cambio en la vista index del director de la pelicula Aladdin

![Captura de pantalla de 2023-12-27 11-43-51](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/43101921-58c3-4097-a0d6-d1d32b6d2bab)


Mejoramos las vistas agregando un enlace en el campo director en la vista index que nos renderiza a la vista siempre y cuando el director de la pelicula este presente, con el fin de mostrar otras peliculas con el mismo director

```
<%= movie.director.present? ? link_to(movie.director, show_by_director_movie_path(movie)) : "Unknown" %>

```

Tambien agregamos codigo en la funcion others_by_same_director en el archivo movie.rb correspondiente al modelo movie 

```
  def others_by_same_director
    # Your code here #
    return nil if director.blank?
    Movie.where(director: director).where.not(id: id)
  end

```

Agregamos rutas en el archivo routes.rb y agregamos codigo en el controlador, con lo cual tendremos lo siguiente :


![Captura de pantalla de 2023-12-27 13-57-10](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/6e77b1b1-dc7c-40d9-95f7-e9585dc25acb)

![Captura de pantalla de 2023-12-27 13-57-16](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/7dc84101-3e88-4d40-816f-fe966228cf7e)


### Mira las definiciones de los pasos fallidos de los escenarios de Cucumber. (¿Dónde encontrará esas definiciones?) Según las definiciones de los pasos, ¿qué pasos del archivo de escenario esperarías aprobar si vuelves a ejecutar Cucumber y por qué? Verifica que los pasos de Cucumber que espera aprobar realmente se aprueben.


Las definiciones de los pasos lo encontramos en features/movies_steps.rb. Recordemos que los archivos movies_by_director.feature sirve como especificaciones de comportamiento y contiene escenarios de prueba que describen el comportamiento esperado , y las definiciones de pasos son implementaciones de los pasos escritos en Gherkin y se encargan de ejecutar el código correspondiente para llevar a cabo las acciones descritas en los escenarios.

- Esperaria pasar el paso correspondiente a `Given the following movies exist`, ya que este paso implica crear las películas en la base de datos correctamente, porque ahora si se tiene el atributo director para el modelo movie, ademas este se utiliza para establecer un estado inicial común.

- Esperaria pasar tambien `Given I am on the details page for "Star Wars" ` , porque este paso indica que estamos en la página de detalles de "Star Wars".

- Tambien When I follow "Find Movies With Same Director, ya que este paso implica hacer clic en el enlace para encontrar películas con el mismo director.



![Captura de pantalla de 2023-12-27 13-59-03](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/963c6d0e-cae5-462e-9a96-4c5050f0afbd)

![Captura de pantalla de 2023-12-27 14-00-27](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/b6ce7374-640f-4789-aa86-5bd6de41491f)

### Los pasos background ahora pasan (comprueba esto), pero el primer paso de cada escenario falla, porque le estás pidiendo a Cucumber que "visite una página" pero no has proporcionado una asignación entre el nombre legible por humanos de la página (por ejemplo, the edit page for "Alien") y la ruta real (URL) que iría a esa página en RottenPotatoes. ¿Dónde necesitarás agregar esta asignación (en qué archivo y qué método en ese archivo)?

El paso de background si pasò la prueba 

![Captura de pantalla de 2023-12-27 13-59-03](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/963c6d0e-cae5-462e-9a96-4c5050f0afbd)

mostramos las partes donde los pasos estan fallando:

![Captura de pantalla de 2023-12-27 14-02-59](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/d416eb74-6f13-4fb4-b834-370e488f9384)

Segun la pregunta, para solucionar el error mencionado en Cucumber, necesitamos proporcionar una asignación entre el nombre legible por humanos de la página y la ruta real (URL) en el archivo features/support/paths.rb y debemos agregar esta funcionalidad en def path_to(page_name).

![Captura de pantalla de 2023-12-27 14-14-26](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/d11da175-1a72-4706-9bf8-f1539f72a788)



### Además de modificar las Vistas, ¿tendremos que modificar algo en el controlador? ¿Si es así
cuales?
Debemos modificar la accion update debido a que no se agregaba en la base de datos el director correspondiente a una pelicula. Ya que, cuando editabamos o creabamos una nueva pelicula agregando el campo director este no se veia en el navegador ni en la base de datos.

```ruby
  def update
    @movie = Movie.find(params[:id])
    if @movie.update(movie_params)
      flash[:notice] = "#{@movie.title} was successfully updated."
      redirect_to movie_path(@movie)
    else
      render 'edit'
    end
  end

```

He añadido en el controlador la accion  show_by_director necesaria para mostrar el director segun el id y las otras peliculas asociadas segun el director:

```ruby
def show_by_director
    @movie = Movie.find(params[:id])
    @director = @movie.director
    @movies = @movie.others_by_same_director
end

```
Tambien he agregado el campo director en la accion movie_params ya que esta accion especifica los atributos específicos del modelo Movie que se permiten para la asignación masiva. En otras palabras, solo estos campos estarán disponibles para ser asignados a un nuevo objeto o para actualizar un objeto existente. Con lo cual, cualquier otro parámetro presente en la solicitud será ignorado

```ruby
def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :director)
  end
end
```
### ¿Qué acciones del controlador, específicamente, no funcionarían si no hicieses el cambio anterior?

- La accion de mostrar el director y las otras peliculas asociadas debido que si no se incorpora el campo director en la accion movie_params este campo sera ignorado.
- Las accion update decido al nuevo campo agregado que es el director, pues sino se modificaba no se podria ver este director en la base de datos al momento de crear o editar una nueva pelicula.


### Utiliza pruebas de aceptación para aprobar nuevos escenarios (2 puntos)


Agregue el siguiente codigo en la vista show:

```
  <%= link_to "Find Movies With Same Director", show_by_director_movie_path(@movie), :class => 'btn btn-primary col-2' %>

```

La ruta que hemos estabeclido para dirigirnos a la vista show_by_director.html.erb segun el id se establece en el archivo routes.rb 

```ruby

Rottenpotatoes::Application.routes.draw do
  resources :movies do
    member do
      get 'show_by_director'
      
    end
  end

  
  # Add new routes here

  root :to => redirect('/movies')
end


```

Segun esta pregunta nos dice que la ruta debe ser `similar` pero por tiempo yo ya lo habia establecido anteriormente con `show_by_director`, 
por ello se utilizara este nombre y la accion del controlador tendra tambien este nombre

``` ruby

  def show_by_director
    @movie = Movie.find(params[:id])
    
    @director = @movie.director
    @movies = @movie.others_by_same_director
  end

```

Tambien agregamos la siguiente definicion de paso al archivo movies_steps.rb debido a que al ejecutar `cucumber features/movies_by_director.feature` nos muestra los siguiente

![Captura de pantalla de 2023-12-27 16-36-54](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/b4ea98a9-3d14-4c48-b9c2-f3c338e96ff6)

Por ello agregamos esta definicion de paso : 

```
Then(/^the director of "([^"]*)" should be "([^"]*)"$/) do |movie_title, director_name|
  movie = Movie.find_by(title: movie_title)
  expect(movie.director).to eq(director_name)
end


``` 

Como tenemos una ruta diferente a la establecida en la pregunta cambiamos de nombre a la ruta en el archivo paths.rb especificamente en lo siguiente: 

```
when /^the Similar Movies page for "([^"]+)"$/
      movie = Movie.find_by(title: $1)
      show_by_director_movie_path(movie)
```

Quedando nuestro archivo de la siguinete manera:

```
# TL;DR: YOU SHOULD DELETE THIS FILE
#
# This file is used by web_steps.rb, which you should also delete
#
# You have been warned
module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name
    when /^the home\s?page$/
      '/'
    when /^the details page for "([^"]+)"$/
      movie = Movie.find_by(title: $1)
      movie_path(movie)
    when /^the edit page for "([^"]+)"$/
      movie = Movie.find_by(title: $1)
      edit_movie_path(movie)
    when /^the Similar Movies page for "([^"]+)"$/
      movie = Movie.find_by(title: $1)
      show_by_director_movie_path(movie)
    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
              "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)


```

![Captura de pantalla de 2023-12-27 16-43-04](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/87fa011f-1ada-4d5d-8172-ff5a0b35f543)

![Captura de pantalla de 2023-12-27 16-43-12](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/9c2acaba-3f36-49ba-b624-7678040626e8)

![Captura de pantalla de 2023-12-27 16-43-16](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/918d9b9c-4298-431b-a56c-77d8aace36d5)

![Captura de pantalla de 2023-12-27 16-22-57](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/9a240d55-dc3d-420d-89da-2e849afc0643)

Segun vemos en la imagen anterior, faltaria  redirigir a la página de inicio cuando no se proporciona información sobre el director .

###  Cobertura del código (1 punto)

Abrimos coverage/index.html después de una ejecución de prueba y haz clic en el nombre de cualquier archivo en tu aplicación para ver qué líneas cubrieron tus pruebas

![Captura de pantalla de 2023-12-27 17-00-09](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/99142b9b-7ad4-44ea-a2d1-e23119f02db0)



Agregamos escenarios y pasos para cubrir los huecos

```
Scenario: View the list of movies
  Given I am on the home page
  When I follow "All Movies"
  Then I should see the list of movies

```

Y su correspondiente definicion de paso :

```

Then("I should see the list of movies on the home page") do
  expect(page).to have_content("Star Wars")
  expect(page).to have_content("Blade Runner")
end

```
Con esto aumentamos el porcentaje

![Captura de pantalla de 2023-12-27 17-29-36](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/73096bac-46cf-40f9-9b64-1ab46ea570aa)

## Parte 2: Ruby on Rails

### Pregunta 1 (1 punto)
¿Por qué la abstracción de un objeto de formulario pertenece a la capa de presentación y no a la capa
de servicios (o inferior)?

Porque el objeto interactua con interfaces que van a servir informacion al usuario, con lo cual permite que el usuario se comunique con la aplicacion, por tal motivo pertenece a la capa de presentacion, ademas la abstracción del objeto de formulario en esta capa facilita la adaptación a cambios en la interfaz de usuario sin afectar las capas inferiores del sistema.

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

Realizamos un ejemplo general de la interactuar con las cookies de la página.

```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cookie Interaction</title>
</head>
<body>
    <script>
        // Función para obtener el valor de una cookie por nombre
        function getCookie(name) {
            const cookies = document.cookie.split('; ');
            for (const cookie of cookies) {
                const [cookieName, cookieValue] = cookie.split('=');
                if (cookieName === name) {
                    return cookieValue;
                }
            }
            return null;
        }

        // Función para crear una nueva cookie
        function setCookie(name, value, days) {
            const expirationDate = new Date();
            expirationDate.setDate(expirationDate.getDate() + days);
            const expires = `expires=${expirationDate.toUTCString()}`;
            document.cookie = `${name}=${value}; ${expires}; path=/`;
        }

        // Función para eliminar una cookie por nombre
        function deleteCookie(name) {
            document.cookie = `${name}=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;`;
        }

        // Configuración inicial: Generar el valor de document.cookie que debería estar en blanco
        console.log("Cookies antes de la configuración inicial:", document.cookie);

        // Configuración inicial: Intentar eliminar una cookie por nombre
        deleteCookie("exampleCookie");

        // Configuración inicial: Mostrar el resultado después de intentar eliminar la cookie
        console.log("Cookies después de intentar eliminar la cookie:", document.cookie);

        // Configuración inicial: Crear una nueva cookie con un valor y una duración de 1 día
        setCookie("exampleCookie", "exampleValue", 1);

        // Mostrar el resultado después de la configuración inicial
        console.log("Cookies después de la configuración inicial:", document.cookie);
    </script>
</body>
</html>


```

- getCookie(name): Esta función recibe el nombre de una cookie como argumento y devuelve su valor. Primero, divide la cadena document.cookie en un array de cookies utilizando split('; '). Luego, recorre este array y compara el nombre de cada cookie con el nombre proporcionado. Si encuentra la cookie, devuelve su valor; de lo contrario, devuelve null.

- setCookie(name, value, days): Esta función crea una nueva cookie con un nombre, un valor y una duración en días. Calcula la fecha de expiración sumando la cantidad de días a la fecha actual. Luego, crea una cadena de configuración de cookie que incluye el nombre, el valor, la fecha de expiración y la ruta, y la agrega a document.cookie.

- deleteCookie(name): Esta función elimina una cookie dada su nombre. Para hacerlo, establece la fecha de expiración en el pasado (antes de la fecha actual). Al hacerlo, el navegador eliminará automáticamente la cookie.

- Configuración Inicial: Antes de realizar cualquier acción, se imprime en la consola el valor actual de document.cookie. Luego, se intenta eliminar una cookie llamada "exampleCookie" (aunque aún no existe). Finalmente, se crea una nueva cookie llamada "exampleCookie" con un valor "exampleValue" y una duración de 1 día. Después de cada acción, se muestra en la consola el valor actualizado de document.cookie.

Con lo cual  esta funciones gestionan las cookies en JavaScript. getCookie lee el valor de una cookie por nombre, setCookie crea una nueva cookie, y deleteCookie elimina una cookie por nombre. La configuración inicial demuestra cómo utilizar estas funciones y muestra los cambios en document.cookie.

### Pregunta 3 (2 punto)
Extienda la función de validación en ActiveModel que se ha utilizado en actividades de clase para
generar automáticamente código JavaScript que valide las entradas del formulario antes de que sea
enviado. Por ejemplo, puesto que el modelo Movie de RottenPotatoes requiere que el título de cada
película sea distinto de la cadena vacía, el código JavaScript debería evitar que el formulario “Add New
Movie” se enviara si no se cumplen los criterios de validación, mostrar un mensaje de ayuda al usuario, y
resaltar el(los) campo(s) del formulario que ocasionaron los problemas de validación. Gestiona, al
menos, las validaciones integradas, como que los títulos sean distintos de cadena vacía, que las
longitudes máxima y mínima de la cadena de caracteres sean correctas, que los valores numéricos estén
dentro de los límites de los rangos, y para puntos adicionales, realice las validaciones basándose en
expresiones regulares.

Agregamos validaciones del lado del servidor para la accion index de tal manera que cuando el usuario quiera colocar el titulo en blanco
el controlador le mando un mensaje de alerta y ademas este no se guarde en la base de datos. Hacemos esto en la accion update del controlador 

```ruby
def update
    @movie = Movie.find(params[:id])
    if movie_params[:title].present?
      @movie.update_attributes!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully updated."
      redirect_to movie_path(@movie)
    else 
      flash[:notice] = 'Title can not be blank'
      render :edit
    end
  end

```

y tambien en el el archivo movie.rb :

```ruby
  validates :title, :presence => true

```

Editamos la pelicula The Terminator

![Captura de pantalla de 2023-12-27 17-53-32](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/ed9bddf8-d020-4bc9-9b76-e40e99fb6b35)

Borramos el titulo de la pelicula

![Captura de pantalla de 2023-12-27 17-53-45](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/6db93211-aabd-4a86-af3d-991eedd69e13)

Y guardamos los cambios, sin embargo se puede apreciar que no se realizo el cambio debido a las validaciones establecidas.

![Captura de pantalla de 2023-12-27 17-53-50](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/931cc794-218c-4708-94c8-fe495b97a035)

Al volver a la lista de peliculas podemos apreciar que no se edito la pelicula 


![Captura de pantalla de 2023-12-27 17-54-06](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/492643d8-d12f-4754-81f2-06e939ffb559)


Ahora realicemos las validaciones del lado del cliente haciendo uso de codigo javascript. Usaremos de ejemplo la interaccion del usuario  con la vista correspondiente a new. Pero primero veamos la parte del DOM que vamos a necesitar para tratar la informacion con el codigo de javascript. Donde la parte <head> es comun debido a views/layouts/application.html.erb por ese motivo no lo coloco.

```
Document
└── <html>
    └── <head>
            .................................................
    └── <body>
        └── <h2>Create New Movie</h2>
        └── <form class="form">
            └── <label for="movie_title" class="col-form-label">
            └── <input id="movie_title" class="form-control" name="movie[title]" type="text">
            
````

Aregamos el siguiente codigo javascript al final de nuestro archivo new.html.erb


```javascript
<script>
  document.querySelector('.form').addEventListener('submit', function (event) {
    document.getElementById('movie_title').classList.remove('validation-error');
    var title = document.querySelector('#movie_title').value;
    if (title.trim() === '') {
      alert('El título no puede estar vacío');
      document.getElementById('movie_title').classList.add('validation-error');
      event.preventDefault();
      return;
    }
    });
</script>

<style>
  .validation-error {
    border: 1px solid red;
  }
</style>

```

Dentro del script de Javascript estamos agregando un event listener al formulario con la clase 'form' que escucha el evento 'submit'.Cuando se envía el formulario, se remueve cualquier estilo de validación anterior al eliminar la clase 'validation-error' del campo de entrada con el ID 'movie_title'.Luego, se obtiene el valor del campo de título y se verifica si está vacío después de quitar espacios en blanco. Si el campo está vacío, se muestra una alerta, se resalta el campo con la clase 'validation-error', se previene el envío del formulario y se sale de la función. Ademas, el bloque de estilo CSS define la apariencia de los campos de entrada con la clase 'validation-error'. En este caso, agrega un borde rojo alrededor del campo.

Con ello le mostramos al usuario nuestras restricciones al querer agregar una nueva pelicula y le mostramod donde ha cometido el error.

![Captura de pantalla de 2023-12-27 18-01-45](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/68437bab-82b1-4755-9aae-fe1bb3495836)

![Captura de pantalla de 2023-12-27 18-01-51](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/19d84d2b-e59b-4f24-a9a0-7a5fceb99bc2)




### Parte 4: Pruebas y Rspec (3 puntos)

El sistema de puntuación utilizado en el tenis sobre hierba se originó en la Edad Media. A medida que los
jugadores ganan puntos sucesivos, sus puntuaciones se muestran como 15, 30 y 40. El siguiente punto
es una victoria a menos que tu oponente también tenga 40. Si ambos están empatados a 40, entonces
se aplican reglas diferentes: el primer jugador con una clara ventaja de dos puntos es el ganador.
Algunos dicen que el sistema 0, 15, 30, 40 es una corrupción del hecho de que la puntuación solía
hacerse utilizando los cuartos de un reloj.

Creamos la carpeta spec donde se va almacenar nuestra prueba llamada tennis_scorer_spec.rb 

``` ruby
require_relative '../lib/tennis_scorer.rb'

RSpec.describe "TennisScorer" do
    describe "puntuación básica" do
      it "empieza con un marcador de 0-0" do
        scorer = TennisScorer.new
        expect(scorer.score).to eq("0-0")
      end
  
      it "hace que el marcador sea 15-0 si el sacador gana un punto" do
        scorer = TennisScorer.new
        scorer.sacador_gana_punto
        expect(scorer.score).to eq("15-0")
      end
  
      it "hace que el marcador sea 0-15 si el receptor gana un punto" do
        scorer = TennisScorer.new
        scorer.receptor_gana_punto
        expect(scorer.score).to eq("0-15")
      end
  
      it "hace que el marcador sea 15-15 después de que ambos ganen un punto" do
        scorer = TennisScorer.new
        scorer.sacador_gana_punto
        scorer.receptor_gana_punto
        expect(scorer.score).to eq("15-15")
      end

      
    end

    
  end
  

```

Luego, creamos el archivo tennis_scorer.rb en la carpeta lib con el siguiente codigo:

```ruby

class TennisScorer

end

```

Donde obviamente al ejecutar el comando rspec spec/tennis_scorer_spec.rb tendremos el siguiente resultado :


![Captura de pantalla de 2023-12-27 18-25-29](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/9fb9ba0f-41f8-4413-98a7-b49a3f070e36)


Queremos implementar el proceso RGR, por ello primero hemos realizado el codigo de prueba con lo cual como el codigo almacenado en tennis_scorer.rb no esta implemnetado todas las pruebas fallaran , por ello vemos  FFFF de color rojo.


Luego, implementamos los metodos y atributos en el archivo tennis_scorer.rb para pasar todas las pruebas.

```ruby


class TennisScorer

    def initialize
      @score = { sacador: 0, receptor: 0 }
    end
  
    def sacador_gana_punto
      @score[:sacador] += 1
    end
  
    def receptor_gana_punto
      @score[:receptor] += 1
    end
  
    def score
      "#{puntuacion(@score[:sacador])}-#{puntuacion(@score[:receptor])}"
    end
  
    private
  
    def puntuacion(puntos)
      case puntos
      when 0 then "0"
      when 1 then "15"
      when 2 then "30"
      when 3 then "40"
      end
    end
  end
  
```

![Captura de pantalla de 2023-12-27 18-35-04](https://github.com/miguelvega/ExamenSustitutorio-CC3S2/assets/124398378/22098fb2-8799-4454-8475-6209f67533e0)
