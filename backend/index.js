// backend/index.js
const express = require('express');
const path = require('path');
const { Pool } = require('pg');
const bodyParser = require('body-parser');
const dotenv = require('dotenv');
dotenv.config();

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const app = express();
app.use(bodyParser.json());

app.use('/', express.static(path.join(__dirname, '..', 'frontend')));

app.get('/api/health', (_req, res) => res.json({ ok: true }));

app.get('/api/payments', async (_req, res) => {
  try {
    const r = await pool.query('SELECT * FROM payments ORDER BY received_at DESC LIMIT 50');
    res.json({ items: r.rows });
  } catch (e) {
    res.status(500).json({ error: 'db' });
  }
});

app.post('/api/reconcile/auto', async (_req, res) => {
  try {
    const pays = await pool.query('SELECT * FROM payments LIMIT 200');
    let matched = 0;
    for (const p of pays.rows) {
      const ord = await pool.query(
        'SELECT * FROM orders WHERE expected_amount_cents=$1 LIMIT 1',
        [p.amount_cents]
      );
      if (ord.rowCount > 0) matched++;
    }
    res.json({ ok: true, matched });
  } catch (e) {
    res.status(500).json({ error: 'server' });
  }
});

app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, '..', 'frontend', 'index.html'));
});

const PORT = process.env.PORT || 4000;
app.listen(PORT, () => console.log('Running on port ' + PORT));
