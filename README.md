# README


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

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
