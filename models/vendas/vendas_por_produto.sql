{{ config(materialized='table') }}

WITH detalhes_vendas AS (
    SELECT
        p.id_produto,
        p.nome AS nome_produto,
        SUM(dp.quantidade) AS quantidade_vendida,
        SUM(dp.preco * dp.quantidade) AS valor_total_vendas
    FROM testdbt.produtos p
    JOIN testdbt.detalhes_pedidos dp ON p.id_produto = dp.id_produto
    GROUP BY p.id_produto
)

SELECT
    dv.*,
    p.categoria,
    p.preco_unitario,
    p.estoque
FROM detalhes_vendas dv
JOIN testdbt.produtos p ON dv.id_produto = p.id_produto
