WITH base AS (
    SELECT
        stock_code AS stock_name,
        date AS transaction_date,
        quantity,
        price,
        SUM(quantity) OVER (PARTITION BY stock_code ORDER BY date) AS total_quantity,
        SUM(quantity) OVER (PARTITION BY stock_code ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS previous_total_quantity,
        quantity * price AS gross_amount,
        brokerage_fee + stamp_duty_fee + clearing_fee + service_tax AS transaction_fees,
        comments
    FROM `winter-anchor-259905.stock_data.stg_rakuten_stock_transaction`
),

transac AS (
    SELECT
        stock_name,
        transaction_date,
        quantity,
        price,
        total_quantity,
        previous_total_quantity,
        gross_amount,
        transaction_fees,
        comments,
        SUM(CASE WHEN previous_total_quantity = 0 THEN 1 ELSE 0 END) OVER (PARTITION BY stock_name ORDER BY transaction_date) AS transaction_id,
    FROM base
)

SELECT
    CAST(transaction_id AS STRING) AS transaction_id,
    stock_name,
    transaction_date,
    quantity,
    price,
    total_quantity,
    SUM(price * quantity) OVER (PARTITION BY stock_name, transaction_id ORDER BY transaction_date) AS total_price,
    previous_total_quantity,
    gross_amount,
    transaction_fees,
    comments
FROM transac
WHERE 1 = 1
