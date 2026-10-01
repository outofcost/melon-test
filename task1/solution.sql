-- карта передана если на одной кассе два разных чека в пределах 10 минут
-- касса = первые 3 символа id_check

WITH checks AS (
    -- в журнале строка = позиция, сворачиваем до чека
    SELECT
        ID_CARD,
        substr(ID_CHECK, 1, 3) AS ID_KASSA,
        MIN(TranDate)          AS TranDate
    FROM CashLog
    GROUP BY ID_CARD, ID_CHECK
),

prev AS (
    -- предыдущий чек этой же карты на этой же кассе
    SELECT
        ID_CARD,
        TranDate,
        LAG(TranDate) OVER (PARTITION BY ID_CARD, ID_KASSA ORDER BY TranDate) AS PREV_DATE
    FROM checks
)

SELECT DISTINCT ID_CARD
FROM prev
WHERE TranDate <= datetime(PREV_DATE, '+10 minutes')
ORDER BY ID_CARD;
