-- CredResolve Collection Intelligence
-- SQL Analysis
-- Author: Vem Sai Akshaya

-- ============================================================
-- 1. Outstanding exposure by risk segment
-- ============================================================

SELECT
    risk_segment,
    COUNT(DISTINCT account_id) AS accounts,
    ROUND(SUM(outstanding_amount), 2) AS outstanding_exposure
FROM accounts_analysis
GROUP BY risk_segment
ORDER BY outstanding_exposure DESC;


-- ============================================================
-- 2. Collection rate by risk segment
-- ============================================================

SELECT
    risk_segment,
    ROUND(SUM(outstanding_amount), 2) AS outstanding_exposure,
    ROUND(SUM(total_payment), 2) AS payments_collected,
    ROUND(
        SUM(total_payment) * 100.0 /
        NULLIF(SUM(outstanding_amount), 0),
        2
    ) AS collection_rate
FROM accounts_analysis
GROUP BY risk_segment
ORDER BY collection_rate DESC;


-- ============================================================
-- 3. High-outstanding accounts with no payment
-- ============================================================

SELECT
    account_id,
    risk_segment,
    dpd,
    outstanding_amount,
    call_count,
    ptp_count
FROM accounts_analysis
WHERE total_payment = 0
ORDER BY outstanding_amount DESC
LIMIT 20;


-- ============================================================
-- 4. Accounts with PTP but no payment
-- ============================================================

SELECT
    account_id,
    risk_segment,
    dpd,
    outstanding_amount,
    ptp_count,
    promised_amount,
    total_payment
FROM accounts_analysis
WHERE ptp_count > 0
  AND total_payment = 0
ORDER BY promised_amount DESC
LIMIT 20;


-- ============================================================
-- 5. Accounts receiving the highest number of calls
-- ============================================================

SELECT
    account_id,
    risk_segment,
    outstanding_amount,
    call_count,
    total_payment
FROM accounts_analysis
ORDER BY call_count DESC
LIMIT 20;