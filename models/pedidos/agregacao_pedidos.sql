{{ config(materialized='incremental', unique_key='id_pedido') }}

SELECT
    p.id_pedido,
    p.id_cliente,
    p.data_pedido,
    SUM(dp.quantidade * dp.preco) AS total_pedido
FROM {{ source('testdbt', 'pedidos') }} p
INNER JOIN {{ source('testdbt', 'detalhes_pedidos') }} dp ON p.id_pedido = dp.id_pedido
GROUP BY p.id_pedido
