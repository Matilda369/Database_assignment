SELECT COUNT(*) FROM users;
SELECT COUNT (*) FROM transfers WHERE send_amount_currency = 'CFA';
SELECT COUNT (*) FROM users FROM (COUNT (*) FROM transfers WHERE send_amount_currency = 'CFA');
SELECT COUNT (*) FROM agent_transactions WHERE when_created IN '2018';
SELECT COUNT (atx_id) FROM agent_transactions WHERE (amount > 0 OR amount<0) AND when_created BETWEEN'2020-08-03 00:00:01' AND '2020-08-10 00:00:01';

SELECT COUNT (atx_amount) AS "atx volume city summary",ag.city FROM agent_transactions AS atx
LEFT OUTER JOIN agents AS ag ON atx.atx_id = ag.agent_id
WHERE atx.when_created BETWEEN NOW()::DATE-EXTRACT(DOW FROM NOW())::INTEGER-7 AND NOW()::DATE-EXTRACT(DOW FROM NOW())::INTEGER;
GROUP BY ag.city;

SELECT COUNT(atx.atx_id) AS "atx_volume",COUNT(ag_city) AS "City", COUNT(ag_country) AS "Country"
FROM agent_transactions AS atx INNER JOIN agents AS ag ON atx.atx_id=ag.agent_id GROUP BY ag.country;

SELECT w.ledger_location AS "Country",tn.send_amount_currency AS "kind", SUM(tn.send_amount_scalar) AS "Volume"
FROM transfers AS tn INNER JOIN wallets AS w ON tn.transfer_id = w.wallet_id
WHERE tn.when_created= CURRENT_DATE-INTERVAL '1 week'
GROUP BY w.ledger_location,tn.send_amount_currency;

SELECT COUNT(transfers.source_wallet_id) AS "Unique_senders" COUNT(transfer_id) AS Transaction_count,ttansfers.kind AS Transfer_kind,wallets.ledger_location AS Country,
SUM(transfers.send_amount_scalar) AS Volume, FROM transfers INNER JOIN wallets ON transfer.source_wallet_id = wallet.wallet_id
WHERE(transfers.when_created >(NOW()-INTERVAL '1 week')) GROUP BY wallets.ledger_location,transfers.kind;

SELECT SUM(transfers.send_amount_scalar) FROM transfers
JOIN wallets ON wallets.wallet_id = transfers.source_wallet_id
WHERE transfers.send_amount_scalar > 10000000 AND
transfers.send_amount_currency = 'CFA' AND
transfers.when_created > CURRENT_DATE - interval '1 month';