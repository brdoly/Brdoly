const SECRET = 'aura_server_secret_9f3a2b7c8d1e4f5a6b2c9d8e7f1a3b4c';

function json(data, status = 200){
  return new Response(JSON.stringify(data), {
    status,
    headers: {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type'
    }
  });
}

async function sha256(str){
  const buf = new TextEncoder().encode(str);
  const h = await crypto.subtle.digest('SHA-256', buf);
  return [...new Uint8Array(h)].map(b => b.toString(16).padStart(2, '0')).join('');
}

export default {
  async fetch(request, env){
    const url = new URL(request.url);
    const path = url.pathname;

    if (request.method === 'OPTIONS'){
      return new Response(null, {
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
          'Access-Control-Allow-Headers': 'Content-Type'
        }
      });
    }

    if (path === '/issue'){
      const hub = url.searchParams.get('hub') || '1';
      const hwid = (url.searchParams.get('hwid') || '').toLowerCase();
      if (hwid.length !== 64) return json({ ok: false, err: 'bad_hwid' }, 400);

      const issuedAt = Date.now();
      const raw = SECRET + '|' + hub + '|' + hwid + '|' + issuedAt;
      const hash = await sha256(raw);
      const key = 'AURA-KEY-' + hash.slice(0, 10).toUpperCase();

      await env.AURA_KV.put('key:' + key, JSON.stringify({
        hub, hwid, issuedAt,
        expiresAt: issuedAt + 12 * 60 * 60 * 1000,
        used: false
      }), { expirationTtl: 60 * 60 * 24 * 2 });

      return json({ ok: true, key, expiresAt: issuedAt + 12 * 60 * 60 * 1000 });
    }

    if (path === '/check'){
      const key = (url.searchParams.get('key') || '').toUpperCase().trim();
      const hwid = (url.searchParams.get('hwid') || '').toLowerCase();

      if (!key.match(/^AURA\-KEY\-[0-9A-F]{10}$/)){
        return json({ ok: false, err: 'bad_format' });
      }

      const raw = await env.AURA_KV.get('key:' + key);
      if (!raw) return json({ ok: false, err: 'key_not_found' });

      const data = JSON.parse(raw);
      if (Date.now() >= data.expiresAt){
        await env.AURA_KV.delete('key:' + key);
        return json({ ok: false, err: 'expired' });
      }
      if (data.used){
        return json({ ok: false, err: 'already_used' });
      }

      data.used = true;
      data.usedAt = Date.now();
      await env.AURA_KV.put('key:' + key, JSON.stringify(data), {
        expirationTtl: Math.floor((data.expiresAt - Date.now()) / 1000) + 60
      });

      return json({ ok: true, hub: data.hub, expiresAt: data.expiresAt });
    }

    return json({ ok: false, err: 'not_found' }, 404);
  }
};
