{{ config(materialized='table') }}

WITH historico_compras AS (
    SELECT
        id_cliente,
        MIN(data_pedido) AS data_primeira_compra,
        MAX(data_pedido) AS data_ultima_compra,
        COUNT(DISTINCT id_pedido) AS total_pedidos,
        SUM(total_pedido) AS gasto_total
    FROM {{ ref('agregacao_pedidos') }}
    GROUP BY id_cliente
)

SELECT
    c.id_cliente,
    c.nome,
    hc.data_primeira_compra,
    hc.data_ultima_compra,
    hc.total_pedidos,
    hc.gasto_total,
    hc.gasto_total / hc.total_pedidos AS valor_medio_pedido,
    CURRENT_DATE - hc.data_primeira_compra AS dias_cliente
FROM {{ source('testdbt', 'clientes') }} AS c
INNER JOIN historico_compras AS hc ON c.id_cliente = hc.id_cliente
