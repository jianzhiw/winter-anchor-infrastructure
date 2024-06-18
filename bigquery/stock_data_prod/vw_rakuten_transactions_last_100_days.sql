SELECT *
FROM `winter-anchor-259905.stock_data.acq_bursa_daily_data`
WHERE
    stock_name NOT LIKE '%-%' AND
    date >= DATE_ADD(CURRENT_DATE, INTERVAL -100 DAY)
ORDER BY stock_name, date
