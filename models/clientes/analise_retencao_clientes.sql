-- models/analise_retencao_clientes.sql

{{ config(materialized='incremental', unique_key='id_cliente') }}

WITH compras_iniciais AS (
    SELECT
        id_cliente,
        MIN(data_pedido) AS data_primeiro_pedido
    FROM {{ ref('pedidos') }}
    GROUP BY id_cliente
),
segunda_compra AS (
    SELECT
        id_cliente,
        MIN(data_pedido) AS data_segundo_pedido
    FROM {{ ref('pedidos') }} p
    WHERE EXISTS (
        SELECT 1
        FROM compras_iniciais ci
        WHERE ci.id_cliente = p.id_cliente
        AND p.data_pedido > ci.data_primeiro_pedido
    )
    GROUP BY id_cliente
)

SELECT
    ci.id_cliente,
    ci.data_primeiro_pedido,
    sc.data_segundo_pedido
FROM compras_iniciais ci
LEFT JOIN segunda_compra sc ON ci.id_cliente = sc.id_cliente
