# README

# This is a project to practive validations | scopes | BD queries etc

* Validations in this project

> Product validations:

> own validations

> Validatios by default:

`validates_presence_of :attr, message: "mssg"`
`validates_uniqueness_of :email, message: "The email should be unique"`
`validates_length_of :members, :minimum => 1`

> Some querys
`Product.where(name: "iphone").or(Product.where(name: "iphone544"))`
`Product.where('price <= 200')`
`Product.where('name LIKE %a% ')`

> placeholders
`Product.where('price <= ?', 200)`
`Product.where('price <= ? and code = ?', 200, 5)`

>find, if is nil, it trough an exception
`Product.find(2)` : find id, or array of ids
`Product.find 2, 3, 4`
`Product.find [2, 3, 4]`

>find_by: return the first element that supply the condition. if is nil, the resutl is nil
`Product.find_by code: '5'`

>Order
`Product.all.order('price DESC')`

>Limit
`Product.all.order('price DESC').limit`

>exist
`Product.where('price = 200').exists?`

>select especific columns, return objects with those attributes
`Product.select(:title)`
`Product.order('price DESC').limit(5).select('price')`
`Product.order('price DESC').limit(5).select(:title)`

> pluck = select without object, just the value pass as parameter
`Product.order('price DESC').limit(5).pluck(:title)`
that will return just the titles

>find_or_create_by
`Product.find_or_create_by name:"Playera"`
if this doesn't exist it will create a new product with those parameters

>first_or_create

* Scopes
> consultas pre-establecidas las cuales hemos definido en nuestros modelos
>encapsular consultas comunes en nuestros modelos, evitando repetir consultas comunes
>registra un nuevo metodo de clase para el objeto
>los scopes se pueden concatenar

* Metodos de clase
>metodos de clase que tienen en su nombre `self.name`

* Scopes y metodos de clase
> son lo mismo, scopes se usa para consultas sencillas, clases para consultas complejas, que es por lo q se separa en un metodo a parte

* update
` p.update(code: "aqw", price: 12)`

* update_attribute 
> -> omite las validaciones del modelo
> con update NO se guarda si no cumple con las validaciones
`Product.first.update_attribute(price: 16)`

* update_attributes 
> SI lee las validaciones
 `Product.first.update_attribute(price: 16, name: "New Update")`

* update_column
> validaciones seran omitidas y el attributo updated_at no sera actualizado
> la unica ventaja es que las actualizaciones son rapidas. se utiliza solo cuando el performance es algo critico. pero NO ES SEGURO para validaciones en BD
`Product.update_column(:code, nil)`

* update_columns
> validaciones seran omitidas y el attributo updated_at no sera actualizado
`Product.update_columns(name: "Updated", code: nil)`


* destroy_all
> elimina todos los registros basados en una consulta tmb o Product.destroy_all para todos

* Monitoreo
`obj.changed?` -> return true o no si se cambio
`obj.changes?` -> return array de arreglos que cambiaron
`obj.{attr_name}_changed` -> si cambio exactamente ese atributo
`obj.{attr_name}_was` -> valor que tenia anteriormente ese atributo
> una vez que se persistan los cambios ya estos metodos de monitoreo de reiunician

`saved_change_to_{attr}?`
`p.saved_change_to_price?` -> si se cambio o no el price una vez persistido
`p.saved_change_to_name?`  -> si se cambio o no el pricename una vez persistido


`obj.persisted?` -> si se guardaron los cambios
`obj.valid?` -> si el obj cumple con todas las validaciones
`obj.errors.full_messages`
`obj.erros.messages`


* Relations

** 1 - *
> in relations 1-* example 1user has * shopping carts, 
> the references alwasys goes in the * model as foreing_key, but it is described in the comand as `user:references` 
> in singular because is just one
`user:references` attr in console == `t.references :user, null: false, foreign_key: true` in the migration

>add values of that reference to the object can be in two ways:
`user_id: id`
`user: obj`

** 1-1
> simplemente ponemos por ejemplo
`has_one: shopping_cart`
> como rails es convencion sobre configuracion, haciendo solamente esto en el modelo, ya al usuario se le annade por defauls el primer carrito de compra en ese attr

> add nuevo attr con covencion
`add_active_to_shopping_carts` -> `add_{attr}_to_{table}`

