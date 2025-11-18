CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE TABLE IF NOT EXISTS payments(
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
 provider_id text,
 amount_cents bigint,
 received_at timestamptz DEFAULT now()
);
CREATE TABLE IF NOT EXISTS orders(
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
 order_ref text,
 expected_amount_cents bigint
);
