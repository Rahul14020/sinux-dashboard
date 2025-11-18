CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE IF NOT EXISTS users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email text UNIQUE NOT NULL,
  password_hash text NOT NULL,
  role text NOT NULL DEFAULT 'admin',
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS payments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  provider_id text UNIQUE,
  amount_cents bigint NOT NULL,
  currency varchar(8) NOT NULL DEFAULT 'INR',
  payment_method varchar(50),
  status varchar(30) DEFAULT 'success',
  received_at timestamptz NOT NULL,
  raw_payload jsonb,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_ref text UNIQUE,
  expected_amount_cents bigint NOT NULL,
  currency varchar(8) NOT NULL DEFAULT 'INR',
  customer_email text,
  order_created_at timestamptz,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS reconciliations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  payment_id uuid REFERENCES payments(id),
  order_id uuid REFERENCES orders(id),
  match_method varchar(50),
  status
