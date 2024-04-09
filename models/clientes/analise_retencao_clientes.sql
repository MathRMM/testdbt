-- models/analise_retencao_clientes.sql
{{ config(materialized="incremental", unique_key="id_cliente") }}

with
    compras_iniciais as (
        select id_cliente, min(data_pedido) as data_primeiro_pedido
        from {{ source("testdbt", "pedidos") }}
        group by id_cliente-- models/cltv_analise.sql
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
