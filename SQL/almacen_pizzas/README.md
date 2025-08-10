# 🍕 Almacén de Pizzas

Este proyecto reproduce el flujo de stock y pedidos de un almacén real de pizzas, pensado como ejercicio práctico de SQL con aplicación directa al entorno laboral. Incluye desde la definición del esquema hasta la simulación de pedidos, la reposición automática de stock y el control de accesos mediante roles..

---

## 🎯 Objetivos

- Construir un esquema completo en PostgreSQL con buenas prácticas: enums, constraints, índices...
- Cargar datos iniciales de productos, ubicaciones y stock (Picking y Stock).  
- Generar aleatoriamente stock de Picking y niveles fijos en Stock por proveedor.  
- Implementar triggers para auditar los movimientos de stock.  
- Crear funciones para recuento y reposición de stock en altura.  
- Definir una vista consolidadora `v_pedido_info` para reporting de pedidos.
- Controlar el acceso a funciones y tablas mediante roles `operario` y `admin`.

---


## 📂 Estructura del proyecto

    Proyectos/
    └── almacen_pizzas/
        ├── 01_init_almacen_pizzas.sql   # Script único con DDL, DML, triggers, funciones y vista
        └── README.md                    # Documentación de este proyecto

---

## 🛠️ Requisitos

- PostgreSQL 15 o superior  
- Cliente SQL (psql, DataGrip, DBeaver, pgAdmin…)  
- Permisos para crear esquemas, tablas, funciones, triggers y roles. 

---

## 🚀 Cómo ejecutar

1. Clona este repositorio y ve a la carpeta del proyecto:
   ```bash
   git clone https://github.com/Coprat95/sql-learning-journey.git
   cd sql-learning-journey/Proyectos/almacen_pizzas