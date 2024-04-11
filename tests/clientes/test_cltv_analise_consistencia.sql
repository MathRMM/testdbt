WITH resultado_teste AS (
  SELECT
    id_cliente,
    valor_medio_pedido
  FROM {{ ref('cltv_analise') }}
  WHERE valor_medio_pedido <= 0 OR valor_medio_pedido IS NULL
)

SELECT * FROM resultado_teste


/* Este teste irá falhar se houver qualquer registro na cltv_analise onde 
valor_medio_pedido seja nulo ou menor ou igual a zero, indicando um problema 
potencial nos dados. */