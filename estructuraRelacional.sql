DROP SCHEMA IF EXISTS etl CASCADE;
CREATE SCHEMA etl;

CREATE TABLE etl.restaurantes_platos (
  id INT NOT NULL,
  fecha_emision DATE NOT NULL,
  alquiler NUMERIC NOT NULL,
  personal NUMERIC NOT NULL,
  proveedores NUMERIC NOT NULL,
  extra NUMERIC NOT NULL,
  ingresos_presencial NUMERIC NOT NULL,
  ingresos_domicilio NUMERIC NOT NULL,
  numero_clientes_presencial INT NOT NULL,
  nuevos_clientes_presencial INT NOT NULL,
  numero_clientes_domicilio INT NOT NULL,
  nuevos_clientes_domicilio INT NOT NULL,
  plato_id INT NOT NULL,
  plato_nombre VARCHAR NOT NULL,
  plato_precio NUMERIC NOT NULL,
  plato_ventas INT NOT NULL,
  PRIMARY KEY (id, fecha_emision, plato_id)
);

DROP SCHEMA IF EXISTS public cascade;
CREATE SCHEMA public;

-- Dimensión tiempo
CREATE TABLE dim_tiempo (
    id SERIAL PRIMARY KEY,
    ano int not null,
    mes int not null,
    mes_texto varchar(10) not null
);

-- Dimensión restaurante
CREATE TABLE dim_restaurante (
    id SERIAL PRIMARY KEY,
    pais varchar(255) not null,
    ciudad varchar(255) not null
);

-- Dimensión productos
CREATE TABLE dim_productos (
    id SERIAL PRIMARY KEY,
    nombre varchar(255) not null,
    precio numeric(10, 2) not null
);


-- evitamos que se modifiquen o eliminen restaurantes y/o fechas si hay registros asociados en las tablas de hechos. GArantizamos la consistencia de los datos y la integridad referencial. 


-- Tabla de hechos finanzas
CREATE TABLE fact_finanzas (
    restaurante INT NOT NULL REFERENCES dim_restaurante(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
    fecha INT NOT NULL REFERENCES dim_tiempo(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
    ---
    alquiler NUMERIC(15, 2) DEFAULT 0,
    personal NUMERIC(15, 2) DEFAULT 0,
    proveedores NUMERIC(15, 2) DEFAULT 0,
    extra NUMERIC(15, 2) DEFAULT 0,
    ingresos_presencial NUMERIC(15, 2) DEFAULT 0,
    ingresos_domicilio NUMERIC(15, 2) DEFAULT 0,
    numero_clientes_presencial INT DEFAULT 0,
    nuevos_clientes_presencial INT DEFAULT 0,
    numero_clientes_domicilio INT DEFAULT 0,
    nuevos_clientes_domicilio INT DEFAULT 0,
    PRIMARY KEY (restaurante, fecha)
);

-- Tabla de hechos producto
CREATE TABLE fact_ventas (
    restaurante INT NOT NULL REFERENCES dim_restaurante(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
    fecha INT NOT NULL REFERENCES dim_tiempo(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
    producto INT NOT NULL REFERENCES dim_productos(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
    ---
    ventas INT DEFAULT 0,
    ingresos INT DEFAULT 0,
    PRIMARY KEY (restaurante, fecha, producto)
);

-- Tabla de hechos feedback
CREATE TABLE fact_satisfaccion (
    restaurante INT NOT NULL REFERENCES dim_restaurante(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
    fecha INT NOT NULL REFERENCES dim_tiempo(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
    ---
    valoracion_ambiente NUMERIC(2, 1) CHECK (valoracion_ambiente >= 0 AND valoracion_ambiente <= 5),
    valoracion_personal NUMERIC(2, 1) CHECK (valoracion_personal >= 0 AND valoracion_personal <= 5),
    valoracion_comida NUMERIC(2, 1) CHECK (valoracion_comida >= 0 AND valoracion_comida <= 5),
    PRIMARY KEY (restaurante, fecha)
);
