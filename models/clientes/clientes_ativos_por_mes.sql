-- models/clientes_ativos_por_mes.sql

SELECT
    DATE_TRUNC('month', p.data_pedido) AS mes,
    COUNT(DISTINCT p.id_cliente) AS clientes_ativos
FROM {{ source('testdbt', 'pedidos') }} AS p
GROUP BY 1
ORDER BY 1
