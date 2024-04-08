-- models/analise_retencao_clientes.sql
{{ config(materialized="incremental", unique_key="id_cliente") }}

with
    compras_iniciais as (
        select id_cliente, min(data_pedido) as data_primeiro_pedido
        from {{ source("testdbt", "pedidos") }}
        group by id_cliente-- models/cltv_analise.sql

{{ config(materialized='table') }}

WITH historico_compras AS (
    SELECT
        id_cliente,
        MIN(data_pedido) AS data_primeira_compra,
        MAX(data_pedido) AS data_ultima_compra,
        COUNT(DISTINCT id_pedido) AS total_pedidos,
…    hc.total_pedidos,
    hc.gasto_total,
    hc.gasto_total / hc.total_pedidos AS valor_medio_pedido,
    CURRENT_DATE - hc.data_primeira_compra AS dias_cliente
FROM {{ source('testdbt', 'clientes') }} AS c
INNER JOIN historico_compras AS hc ON c.id_cliente = hc.id_cliente

    ),
    segunda_compra as (
        select id_cliente, min(data_pedido) as data_segundo_pedido
        from {{ source("testdbt", "pedidos") }} p
        where
            exists (
                select 1
                from compras_iniciais ci
                where
                    ci.id_cliente = p.id_cliente
                    and p.data_pedido > ci.data_primeiro_pedido
            )
        group by id_cliente
    )

select ci.id_cliente, ci.data_primeiro_pedido, sc.data_segundo_pedido
from compras_iniciais ci
left join segunda_compra sc on ci.id_cliente = sc.id_cliente
