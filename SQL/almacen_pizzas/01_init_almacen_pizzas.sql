-- ======================================================
-- PLANTILLA COMPLETA: ESQUEMA, DATOS, ÍNDICES, MIGRACIONES,
-- TRIGGERS, FUNCIONES Y VISTA
-- ======================================================

-- ======================================================
-- 1) DEFINICIÓN DE TIPOS ENUM
-- ======================================================
CREATE TYPE tipo_zona_enum AS ENUM('Picking', 'Stock');
CREATE TYPE tipo_estado_enum AS ENUM('Pendiente', 'Acabado', 'Cancelado');


-- ======================================================
-- 2) CREACIÓN DE TABLAS
-- ======================================================

-- 2.1) Productos
CREATE TABLE productos (
    id                INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre            VARCHAR(50) NOT NULL,        -- ej: Bandeja BBQ
    tipo              VARCHAR(20) NOT NULL,        -- 'Bandeja' o 'Pequeña'
    proveedor         VARCHAR(100) NOT NULL,       -- 'ELAPI' o 'ITALY'
    CONSTRAINT chk_tipo       CHECK (tipo       IN ('Bandeja','Pequeña')),
    CONSTRAINT chk_proveedor  CHECK (proveedor  IN ('ELAPI','ITALY'))
);

-- 2.2) Ubicaciones físicas
CREATE TABLE ubicaciones (
    id             INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ubicacion      VARCHAR(20) UNIQUE NOT NULL,    -- ej: 'B2J-23-1'
    estanteria     VARCHAR(10) NOT NULL,           -- ej: 'B2J'
    altura         INT NOT NULL,                   -- 1 a 5
    tipo_zona      tipo_zona_enum NOT NULL,        -- 'Picking' o 'Stock'
    CONSTRAINT chk_altura CHECK (altura BETWEEN 1 AND 5)
);

-- 2.3) Stock: cantidad de bultos por producto y ubicación
CREATE TABLE stock (
    id                   INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    producto_id          INT NOT NULL
                          REFERENCES productos(id),
    ubicacion_id         INT NOT NULL
                          REFERENCES ubicaciones(id),
    bultos               INT NOT NULL
                          CONSTRAINT chk_bultos CHECK (bultos >= 0),
    unidades_por_bulto   INT NOT NULL
                          CONSTRAINT chk_unidades CHECK (unidades_por_bulto > 0),
    CONSTRAINT uq_prod_ubi UNIQUE (producto_id, ubicacion_id)
);

-- 2.4) Pedidos (cabecera)
CREATE TABLE pedidos (
    id       INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    fecha    TIMESTAMP NOT NULL DEFAULT now(),
    estado   tipo_estado_enum NOT NULL DEFAULT 'Pendiente'
);

-- 2.5) Detalle de pedido
CREATE TABLE pedido_detalle (
    id                   INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    pedido_id            INT NOT NULL
                          REFERENCES pedidos(id),
    producto_id          INT NOT NULL
                          REFERENCES productos(id) ON DELETE RESTRICT,
    bultos_solicitados   INT NOT NULL
                          CONSTRAINT chk_pd_bultos CHECK (bultos_solicitados >= 0)
);


-- ======================================================
-- 3) DATOS INICIALES
-- ======================================================
BEGIN;

  -- 3.1) Productos ELAPI
  INSERT INTO productos(nombre,tipo,proveedor) VALUES
    ('Bandeja BBQ',    'Bandeja', 'ELAPI'),
    ('Bandeja Mixta',  'Bandeja', 'ELAPI'),
    ('Bandeja Atun',   'Bandeja', 'ELAPI'),
    ('Bandeja Queso',  'Bandeja', 'ELAPI'),
    ('Queso Pequeña',  'Pequeña','ELAPI'),
    ('Atún Pequeña',   'Pequeña','ELAPI'),
    ('Mixta Pequeña',  'Pequeña','ELAPI');

  -- 3.2) Productos ITALY
  INSERT INTO productos(nombre,tipo,proveedor) VALUES
    ('Tonno',    'Pequeña','ITALY'),
    ('Formaggi', 'Pequeña','ITALY'),
    ('Procciuto','Pequeña','ITALY'),
    ('Salamino', 'Pequeña','ITALY');

  -- 3.3) Ubicaciones ELAPI – Picking (altura 1)
  INSERT INTO ubicaciones(ubicacion,estanteria,altura,tipo_zona) VALUES
    ('B2J-23-1','B2J',1,'Picking'),
    ('B2J-24-1','B2J',1,'Picking'),
    ('B2J-25-1','B2J',1,'Picking'),
    ('B2J-26-1','B2J',1,'Picking'),
    ('B2J-27-1','B2J',1,'Picking'),
    ('B2J-29-1','B2J',1,'Picking'),
    ('B2J-35-1','B2J',1,'Picking');

  -- 3.4) Ubicaciones ELAPI – Stock (alturas 2–5)
  INSERT INTO ubicaciones(ubicacion,estanteria,altura,tipo_zona) VALUES
    ('B2J-23-2','B2J',2,'Stock'),('B2J-23-3','B2J',3,'Stock'),
    ('B2J-23-4','B2J',4,'Stock'),('B2J-23-5','B2J',5,'Stock'),
    ('B2J-24-2','B2J',2,'Stock'),('B2J-24-3','B2J',3,'Stock'),
    ('B2J-24-4','B2J',4,'Stock'),('B2J-24-5','B2J',5,'Stock'),
    ('B2J-25-2','B2J',2,'Stock'),('B2J-25-3','B2J',3,'Stock'),
    ('B2J-25-4','B2J',4,'Stock'),('B2J-25-5','B2J',5,'Stock'),
    ('B2J-26-2','B2J',2,'Stock'),('B2J-26-3','B2J',3,'Stock'),
    ('B2J-26-4','B2J',4,'Stock'),('B2J-26-5','B2J',5,'Stock'),
    ('B2J-27-2','B2J',2,'Stock'),('B2J-27-3','B2J',3,'Stock'),
    ('B2J-27-4','B2J',4,'Stock'),('B2J-27-5','B2J',5,'Stock'),
    ('B2J-29-2','B2J',2,'Stock'),('B2J-29-3','B2J',3,'Stock'),
    ('B2J-29-4','B2J',4,'Stock'),('B2J-29-5','B2J',5,'Stock'),
    ('B2J-35-2','B2J',2,'Stock'),('B2J-35-3','B2J',3,'Stock'),
    ('B2J-35-4','B2J',4,'Stock'),('B2J-35-5','B2J',5,'Stock');

  -- 3.5) Ubicaciones ITALY – Picking (altura 1)
  INSERT INTO ubicaciones(ubicacion,estanteria,altura,tipo_zona) VALUES
    ('B2J-19-1','B2J',1,'Picking'),
    ('B2J-20-1','B2J',1,'Picking'),
    ('B2J-21-1','B2J',1,'Picking'),
    ('B2J-22-1','B2J',1,'Picking');

  -- 3.6) Ubicaciones ITALY – Stock (alturas 2–5)
  INSERT INTO ubicaciones(ubicacion,estanteria,altura,tipo_zona) VALUES
    ('B2J-19-2','B2J',2,'Stock'),('B2J-19-3','B2J',3,'Stock'),
    ('B2J-19-4','B2J',4,'Stock'),('B2J-19-5','B2J',5,'Stock'),
    ('B2J-20-2','B2J',2,'Stock'),('B2J-20-3','B2J',3,'Stock'),
    ('B2J-20-4','B2J',4,'Stock'),('B2J-20-5','B2J',5,'Stock'),
    ('B2J-21-2','B2J',2,'Stock'),('B2J-21-3','B2J',3,'Stock'),
    ('B2J-21-4','B2J',4,'Stock'),('B2J-21-5','B2J',5,'Stock'),
    ('B2J-22-2','B2J',2,'Stock'),('B2J-22-3','B2J',3,'Stock'),
    ('B2J-22-4','B2J',4,'Stock'),('B2J-22-5','B2J',5,'Stock');

  -- 3.7) Inserción masiva de stock inicial
  -- ELAPI – Picking (0–100) y Stock (72 / 96)
  INSERT INTO stock(producto_id,ubicacion_id,bultos,unidades_por_bulto)
  SELECT p.id,u.id,
    FLOOR(RANDOM()*101)::INT,
    CASE WHEN p.tipo='Bandeja' THEN 6 ELSE 8 END
  FROM productos p
  JOIN ubicaciones u ON u.tipo_zona='Picking' AND u.estanteria='B2J' AND u.altura=1
  WHERE p.proveedor='ELAPI';

  INSERT INTO stock(producto_id,ubicacion_id,bultos,unidades_por_bulto)
  SELECT p.id,u.id,
    CASE WHEN p.tipo='Bandeja' THEN 72 ELSE 96 END,
    CASE WHEN p.tipo='Bandeja' THEN 6 ELSE 8 END
  FROM productos p
  JOIN ubicaciones u ON u.tipo_zona='Stock' AND u.estanteria='B2J' AND u.altura BETWEEN 2 AND 5
  WHERE p.proveedor='ELAPI';

  -- ITALY – Picking (0–100) y Stock (60 bultos)
  INSERT INTO stock(producto_id,ubicacion_id,bultos,unidades_por_bulto)
  SELECT p.id,u.id,
    FLOOR(RANDOM()*101)::INT,
    8
  FROM productos p
  JOIN ubicaciones u ON u.tipo_zona='Picking' AND u.estanteria='B2J' AND u.altura=1
  WHERE p.proveedor='ITALY';

  INSERT INTO stock(producto_id,ubicacion_id,bultos,unidades_por_bulto)
  SELECT p.id,u.id,
    60,
    8
  FROM productos p
  JOIN ubicaciones u ON u.tipo_zona='Stock' AND u.estanteria='B2J' AND u.altura BETWEEN 2 AND 5
  WHERE p.proveedor='ITALY';

COMMIT;


-- ======================================================
-- 4) CREACIÓN DE ÍNDICES
-- ======================================================
CREATE INDEX idx_stock_producto_ubicacion ON stock(producto_id, ubicacion_id);
CREATE INDEX idx_productos_nombre           ON productos(nombre);
CREATE INDEX idx_ubicaciones_ubicacion     ON ubicaciones(ubicacion);
CREATE INDEX idx_pd_pedido_id              ON pedido_detalle(pedido_id);
CREATE INDEX idx_pd_producto_id            ON pedido_detalle(producto_id);


-- ======================================================
-- 5) LOG DE MOVIMIENTOS DE STOCK
-- ======================================================
CREATE TABLE movimientos_stock (
    id               INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    fecha_movimiento TIMESTAMP    DEFAULT NOW(),
    tipo_accion      VARCHAR(20),        -- 'INSERT','UPDATE','DELETE'
    producto_id      INT                REFERENCES productos(id),
    ubicacion_id     INT                REFERENCES ubicaciones(id),
    variacion_bultos INT,               -- cambio (+/-)
    bultos_antes     INT,
    bultos_despues   INT,
    motivo           TEXT,              -- se lee con current_setting('cambio.motivo')
    pedido_id        INT                REFERENCES pedidos(id)
);

-- 5.1) Trigger function
CREATE OR REPLACE FUNCTION trg_log_movimientos_stock()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE
  v_delta INT;
BEGIN
  IF TG_OP = 'INSERT' THEN
    v_delta := NEW.bultos;
    INSERT INTO movimientos_stock(
      tipo_accion, producto_id, ubicacion_id,
      variacion_bultos, bultos_antes, bultos_despues, motivo, pedido_id
    ) VALUES (
      'INSERT', NEW.producto_id, NEW.ubicacion_id,
      v_delta, 0, NEW.bultos,
      current_setting('cambio.motivo', true), NULL
    );
    RETURN NEW;

  ELSIF TG_OP = 'UPDATE' THEN
    v_delta := NEW.bultos - OLD.bultos;
    INSERT INTO movimientos_stock(
      tipo_accion, producto_id, ubicacion_id,
      variacion_bultos, bultos_antes, bultos_despues, motivo, pedido_id
    ) VALUES (
      'UPDATE', NEW.producto_id, NEW.ubicacion_id,
      v_delta, OLD.bultos, NEW.bultos,
      current_setting('cambio.motivo', true), NULL
    );
    RETURN NEW;

  ELSIF TG_OP = 'DELETE' THEN
    v_delta := - OLD.bultos;
    INSERT INTO movimientos_stock(
      tipo_accion, producto_id, ubicacion_id,
      variacion_bultos, bultos_antes, bultos_despues, motivo, pedido_id
    ) VALUES (
      'DELETE', OLD.producto_id, OLD.ubicacion_id,
      v_delta, OLD.bultos, 0,
      current_setting('cambio.motivo', true), NULL
    );
    RETURN OLD;
  END IF;
END;
$$;

-- 5.2) Trigger asociado
CREATE TRIGGER trg_stock_log
  AFTER INSERT OR UPDATE OR DELETE ON stock
  FOR EACH ROW
  EXECUTE FUNCTION trg_log_movimientos_stock();


-- ======================================================
-- 6) FUNCIONES AUXILIARES
-- ======================================================

-- 6.1) Reposición de alturas por proveedor
CREATE OR REPLACE FUNCTION fn_rellenar_stock_alturas(
  p_proveedor VARCHAR DEFAULT NULL
) RETURNS VOID
LANGUAGE plpgsql AS $$
DECLARE
  filas INT;
BEGIN
  UPDATE stock s
  SET bultos = CASE
    WHEN p.proveedor = 'ITALY' THEN 60
    WHEN p.proveedor = 'ELAPI' AND p.tipo = 'Bandeja'  THEN 72
    WHEN p.proveedor = 'ELAPI' AND p.tipo = 'Pequeña' THEN 96
    ELSE s.bultos
  END
  FROM productos p
  JOIN ubicaciones u ON u.id = s.ubicacion_id
  WHERE s.producto_id = p.id
    AND u.tipo_zona = 'Stock'
    AND (p_proveedor IS NULL OR p.proveedor = p_proveedor);

  GET DIAGNOSTICS filas = ROW_COUNT;
  RAISE NOTICE 'fn_rellenar_stock_alturas: % filas actualizadas (proveedor=%)',
               filas, COALESCE(p_proveedor,'TODOS');
END;
$$;

-- 6.2) Recuento de Picking por proveedor
CREATE OR REPLACE FUNCTION fn_recuento_picking_proveedor(
  p_proveedor VARCHAR
) RETURNS TABLE(
  producto_id   INT,
  nombre        VARCHAR,
  bultos_picking INT
)
LANGUAGE plpgsql STABLE AS $$
BEGIN
  RETURN QUERY
    SELECT p.id, p.nombre, SUM(s.bultos)::INT
    FROM productos p
    JOIN stock s ON s.producto_id = p.id
    JOIN ubicaciones u ON u.id = s.ubicacion_id
    WHERE u.tipo_zona = 'Picking'
      AND p.proveedor = p_proveedor
    GROUP BY p.id, p.nombre
    ORDER BY p.nombre;
END;
$$;

--6.3) Creamos la Función de reposición (para cuando nos pide más picking del que tenemos)
CREATE OR REPLACE FUNCTION fn_reposicion(p_prod_id INT)
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
  v_ubi_pick   INT;      -- ubicación de Picking para este producto
  v_ubi_alt    INT;      -- ubicación de Stock altura para este producto
  v_pick_qty   INT;      -- bultos en Picking
  v_alt_qty    INT;      -- bultos en altura
BEGIN
  -- 1) Encuentra la ubicación de picking que ya existe en stock para este producto
  SELECT s.ubicacion_id
    INTO v_ubi_pick
  FROM stock s
  JOIN ubicaciones u ON u.id = s.ubicacion_id
  WHERE s.producto_id = p_prod_id
    AND u.tipo_zona = 'Picking'
    AND u.altura    = 1
  LIMIT 1;

  IF v_ubi_pick IS NULL THEN
    RAISE NOTICE 'fn_reposicion: no tengo fila de stock en Picking para producto %', p_prod_id;
    RETURN;
  END IF;

  -- 2) Encuentra la ubicación de stock en altura (2–5) para este producto
  SELECT s.ubicacion_id
    INTO v_ubi_alt
  FROM stock s
  JOIN ubicaciones u ON u.id = s.ubicacion_id
  WHERE s.producto_id = p_prod_id
    AND u.tipo_zona = 'Stock'
    AND u.altura BETWEEN 2 AND 5
  LIMIT 1;

  IF v_ubi_alt IS NULL THEN
    RAISE NOTICE 'fn_reposicion: no tengo fila de stock en Altura para producto %', p_prod_id;
    RETURN;
  END IF;

  -- 3) Lee las cantidades actuales (con COALESCE para evitar NULL)
  SELECT COALESCE(bultos,0) INTO v_pick_qty
    FROM stock
   WHERE producto_id  = p_prod_id
     AND ubicacion_id = v_ubi_pick;

  SELECT COALESCE(bultos,0) INTO v_alt_qty
    FROM stock
   WHERE producto_id  = p_prod_id
     AND ubicacion_id = v_ubi_alt;

  RAISE NOTICE 'Reposición antes: prod % → picking ubi % = %, alt ubi % = %',
               p_prod_id, v_ubi_pick, v_pick_qty, v_ubi_alt, v_alt_qty;

  -- 4) Mover todo de alt a picking
  UPDATE stock
     SET bultos = v_pick_qty + v_alt_qty
   WHERE producto_id  = p_prod_id
     AND ubicacion_id = v_ubi_pick;

  UPDATE stock
     SET bultos = 0
   WHERE producto_id  = p_prod_id
     AND ubicacion_id = v_ubi_alt;

  RAISE NOTICE 'Reposición después: prod % → picking ubi % = %',
               p_prod_id, v_ubi_pick,
               (v_pick_qty + v_alt_qty);

END;
$$;

--6.4) Función trigger que revisa el stock en Picking y
-- llama a reposicion si hace falta

CREATE OR REPLACE FUNCTION trg_reponer_picking()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_pick_qty stock.bultos%TYPE;
BEGIN
    -- Obtener stock actual en Picking para este producto
    SELECT COALESCE(bultos,0) INTO v_pick_qty
    FROM stock s
    JOIN ubicaciones u ON u.id = s.ubicacion_id
    WHERE s.producto_id = NEW.producto_id  
    AND u.tipo_zona = 'Picking'
    AND u.estanteria = 'B2J'
    AND u.altura  = 1;

    RAISE NOTICE 'Trigger activado: producto %, bultos solicitados %, stock picking %', NEW.producto_id, NEW.bultos_solicitados, v_pick_qty;

    IF NEW.bultos_solicitados > v_pick_qty THEN
        RAISE NOTICE 'Reposición necesaria para producto %', NEW.producto_id;
        PERFORM fn_reposicion(NEW.producto_id);
    END IF;

    RETURN NEW;
END;
$$;
--6.5) 
/* 3) Trigger que dispara la función antes de INSERT o UPDATE
   en pedido_detalle. Es decir:

   Cada vez que se cree o modifique una línea de pedido
   (referencia de pizza) , el sistema
   automáticamente revisa el stock disponible en Picking y genera una
   reposición desde Altura si no hay suficiente cantidad.
*/
	
DROP TRIGGER IF EXISTS trg_reponer_antes_pedido ON pedido_detalle;

CREATE TRIGGER trg_reponer_antes_pedido
BEFORE INSERT OR UPDATE ON pedido_detalle
FOR EACH ROW
WHEN (NEW.bultos_solicitados > 0 ) -- si de una referencia no pide bultos no se lanza el trigger
EXECUTE FUNCTION trg_reponer_picking();

-- 6.6) CREATE OR REPLACE PROCEDURE hacer_pedido()
LANGUAGE plpgsql
AS $$
DECLARE
  v_pedido_id    INT;             -- Identificador del nuevo pedido
  v_prod         RECORD;          -- Cada fila de SELECT id FROM productos
                                   -- Dentro del bucle podremos acceder a v_prod.id, v_prod.nombre, etc.
  v_cant_req     INT;             -- Bultos solicitados aleatorios entre 0 y 100
  v_stock_pick   INT;             -- Stock disponible en zona Picking
  v_insuficiente BOOLEAN := FALSE; -- Flag que indica si faltó stock en alguno de los productos
BEGIN

  -- 1) Insertar cabecera con proveedor aleatorio y estado Pendiente
  INSERT INTO pedidos(proveedor, estado)
       VALUES (
         CASE
           WHEN random() < 0.5 THEN 'elapi'
           ELSE 'italpi'
         END,
         'Pendiente'::tipo_estado_enum
       )
  RETURNING id INTO v_pedido_id;

  -- 2) Recorrer todas las referencias de productos
  FOR v_prod IN
    SELECT id
      FROM productos
  LOOP

    -- 2.1) Generar cantidad aleatoria entre 0 y 100
    v_cant_req := floor(random() * 101)::INT;
    IF v_cant_req = 0 THEN
      CONTINUE;  -- Si sale 0, saltar al siguiente producto
    END IF;

    -- 2.2) Leer stock en Picking para el producto actual
    SELECT COALESCE(s.bultos, 0)
      INTO v_stock_pick
      FROM stock s
      JOIN ubicaciones u ON u.id = s.ubicacion_id
     WHERE s.producto_id = v_prod.id
       AND u.tipo_zona   = 'Picking'
       AND u.estanteria  = 'B2J'
       AND u.altura      = 1
     LIMIT 1;

    -- 2.3) Si no hay suficiente stock, reponer y recalcular
    IF v_cant_req > v_stock_pick THEN
      PERFORM fn_reposicion(v_prod.id);  -- Llamada a la función de reposición

      SELECT COALESCE(s.bultos, 0)
        INTO v_stock_pick
        FROM stock s
        JOIN ubicaciones u ON u.id = s.ubicacion_id
       WHERE s.producto_id = v_prod.id
         AND u.tipo_zona   = 'Picking'
         AND u.estanteria  = 'B2J'
         AND u.altura      = 1
       LIMIT 1;
    END IF;

    -- 2.4) Si sigue faltando stock, marcar insuficiencia
    IF v_cant_req > v_stock_pick THEN
      v_insuficiente := TRUE;
    END IF;

    -- 2.5) Insertar línea de detalle del pedido
    INSERT INTO pedido_detalle(pedido_id, producto_id, bultos_solicitados)
      VALUES (v_pedido_id, v_prod.id, v_cant_req);

  END LOOP;

  -- 3) Finalizar o cancelar pedido según disponibilidad de stock
  IF v_insuficiente THEN
    -- 3.1) Marcar pedido como Cancelado
    UPDATE pedidos
       SET estado = 'Cancelado'::tipo_estado_enum
     WHERE id = v_pedido_id;
  ELSE
    -- 3.2) Descontar del stock de Picking lo servido
    UPDATE stock AS s
      SET bultos = s.bultos - d.bultos_solicitados
      FROM pedido_detalle AS d
     WHERE d.pedido_id    = v_pedido_id
       AND s.producto_id  = d.producto_id
       AND s.ubicacion_id = (
         SELECT id
           FROM ubicaciones
          WHERE tipo_zona  = 'Picking'
            AND estanteria = 'B2J'
            AND altura     = 1
          LIMIT 1
       );

    -- 3.3) Marcar pedido como Acabado
    UPDATE pedidos
       SET estado = 'Acabado'::tipo_estado_enum
     WHERE id = v_pedido_id;
  END IF;

END;
$$;


-- ======================================================
-- 7) BLOQUE DE REINICIO / REINYECCIÓN DE STOCK
-- ======================================================
BEGIN;

  -- 7.1) Limpiar stock y reiniciar IDs
  TRUNCATE TABLE stock RESTART IDENTITY;

  -- 7.2) Insertar Picking (random 0–100) para ambos proveedores
  INSERT INTO stock(producto_id,ubicacion_id,bultos,unidades_por_bulto)
  SELECT p.id,u.id,
    FLOOR(RANDOM()*101)::INT,
    CASE WHEN p.tipo='Bandeja' THEN 6 ELSE 8 END
  FROM productos p
  JOIN ubicaciones u ON u.tipo_zona='Picking' AND u.estanteria='B2J' AND u.altura=1
  WHERE p.proveedor IN ('ELAPI','ITALY');

  -- 7.3) Insertar alturas ELAPI (Bandeja=72, Pequeña=96)
  INSERT INTO stock(producto_id,ubicacion_id,bultos,unidades_por_bulto)
  SELECT p.id,u.id,
    CASE WHEN p.tipo='Bandeja' THEN 72 ELSE 96 END,
    CASE WHEN p.tipo='Bandeja' THEN 6 ELSE 8 END
  FROM productos p
  JOIN ubicaciones u ON u.tipo_zona='Stock' AND u.estanteria='B2J' AND u.altura BETWEEN 2 AND 5
  WHERE p.proveedor = 'ELAPI';

  -- 7.4) Insertar alturas ITALY (siempre 60)
  INSERT INTO stock(producto_id,ubicacion_id,bultos,unidades_por_bulto)
  SELECT p.id,u.id, 60, 8
  FROM productos p
  JOIN ubicaciones u ON u.tipo_zona='Stock' AND u.estanteria='B2J' AND u.altura BETWEEN 2 AND 5
  WHERE p.proveedor = 'ITALY';

COMMIT;

-- ======================================================
-- 8) VISTA PARA CONSULTA DE PEDIDOS
-- ======================================================
CREATE OR REPLACE VIEW v_pedido_info AS
SELECT
  pe.id                 AS pedido_id,
  pe.fecha              AS fecha_pedido,
  p.nombre              AS pizza,
  p.tipo                AS tipo_pizza,
  p.proveedor           AS proveedor,
  pd.bultos_solicitados AS bultos
FROM pedidos pe
JOIN pedido_detalle pd ON pd.pedido_id = pe.id
JOIN productos p       ON p.id           = pd.producto_id;

-- ======================================================
-- 9) SEGURIDAD: CREACIÓN DE ROLES Y USUARIOS
-- ======================================================

-- 1. Crear roles (evita error si ya existen)
CREATE ROLE IF NOT EXISTS operario NOLOGIN;
CREATE ROLE IF NOT EXISTS admin    NOLOGIN;

-- 2. Dar acceso al esquema
GRANT USAGE ON SCHEMA public TO operario, admin;

-- 3. Permisos para admin
GRANT SELECT, INSERT, UPDATE ON stock TO admin;
GRANT INSERT ON pedidos           TO admin;
GRANT EXECUTE ON ALL FUNCTIONS 
  IN SCHEMA public                TO admin;

-- 4. Permisos para operario
GRANT EXECUTE
  ON FUNCTION hacer_pedido(INT, INT)
  TO operario;

-- 5. Herencia de roles
GRANT operario TO admin;

-- 6. Asignar usuarios a roles 
--    (añadimos IF NOT EXISTS para evitar duplicados)
CREATE USER IF NOT EXISTS juan  WITH PASSWORD 'juan1234';
GRANT operario TO juan;

CREATE USER IF NOT EXISTS maria WITH PASSWORD 'maria1234';
GRANT admin    TO maria;