# Sumário de pedidos

Esta é uma aplicação de linha de comando capaz de calcular o valor
final de pedidos de uma empresa. Atualmente as entradas

## Entrada

O programa deve receber 4 arquivos em formato CSV sem cabeçalho

### CSV de Coupons
1. Id do cupom
2. Valor do desconto, em float
3. Tipo de desconto, que pode ser percentual ou valor absoluto, em string: “percent”, ou “absolute"
4. Data de expiração do cupom
5. Número de vezes que o cupom pode ser utilizado

Ex: 135, 50.0, absolute, 2016/02/29, 3
(Cupom com ID 135, de R$ 50,00 de desconto e pode ser utilizado 3 vezes até o fim de fevereiro)

### CSV de Products
1. Id do produto
2. Preço em float

### CSV de Pedidos
1. Id do pedido
2. Id do cupom utilizado no pedido

### CSV de Produtos em cada Pedido
1. Id do pedido
2. Id do produto

## Cálculo do Valor Final do Pedido

O valor total do pedido é a soma do valor dos produtos do pedido menos o Desconto. Cada pedido possui no máximo uma unidade de cada produto.

## Cálculo do Desconto do Pedido
Há dois tipos de desconto: Desconto dado por um Cupom, ou Desconto Progressivo. Eles não são cumulativos, e o desconto a ser aplicado no pedido é o maior entre os dois.
O Desconto por Cupom é definido pelo tipo de cupom (percentual, ou valor absoluto). Cupons vencidos, ou que já foram utilizados o número máximo de vezes (na ordem em que aparecem no CSV de pedidos), devem ser ignorados.
O Desconto Progressivo é aplicado dependendo da quantidade de produtos presentes no pedido.
O desconto progressivo inicia-se em 10% para pedidos com 2 produtos, e soma-se 5% de desconto para cada produto adicional (ou seja, um pedido com 5 produtos ganha 25% de desconto progressivo).
Este desconto estende-se até o máximo de 40% de desconto (ou seja, o desconto progressivo máximo ocorre em pedidos com 8 produtos).

## Formato de Saída
O arquivo de saída deve ser também em formato CSV, no formato:
1. Id do pedido
2. Valor do pedido em float

## Execução
Para gerar os resultados da aplicação, execute no shell

˜˜˜shell
$  ruby order_prices.rb cupons.csv products.csv orders.csv order_items.csv totals.csv
˜˜˜

## Testes
Para testar a aplicação, execute no shell

˜˜˜shell
$ ruby tests/models.rb
˜˜˜
