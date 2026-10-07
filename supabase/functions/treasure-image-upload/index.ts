import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "npm:@supabase/supabase-js@2";

const cors = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

function json(data: unknown, status = 200) {
  return new Response(JSON.stringify(data), {
    status,
    headers: { ...cors, "Content-Type": "application/json", "Cache-Control": "no-store" },
  });
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: cors });
  if (req.method !== "POST") return json({ error: "Method not allowed" }, 405);

  try {
    const body = await req.json();
    const adminKey = String(body.adminKey || "");
    const route = String(body.route || "");
    const point = Number(body.point);
    const contentType = String(body.contentType || "image/webp");
    let encoded = String(body.imageBase64 || "");

    if (!["blu", "gialla", "rossa"].includes(route)) return json({ error: "Percorso non valido" }, 400);
    if (!Number.isInteger(point) || point < 1 || point > 999) return json({ error: "Punto non valido" }, 400);
    if (!["image/webp", "image/jpeg", "image/png"].includes(contentType)) return json({ error: "Formato immagine non valido" }, 400);

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") || Deno.env.get("SUPABASE_SECRET_KEY");
    if (!serviceKey) return json({ error: "Server storage key non disponibile" }, 500);

    const admin = createClient(supabaseUrl, serviceKey, {
      auth: { persistSession: false, autoRefreshToken: false },
    });

    const check = await admin.rpc("admin_check_treasure_key", { p_admin_key: adminKey });
    if (check.error || check.data !== true) return json({ error: "Admin key non valida" }, 401);

    const comma = encoded.indexOf(",");
    if (encoded.startsWith("data:") && comma >= 0) encoded = encoded.slice(comma + 1);

    const binary = atob(encoded);
    if (binary.length > 8 * 1024 * 1024) return json({ error: "Immagine troppo grande" }, 413);

    const bytes = Uint8Array.from(binary, (c) => c.charCodeAt(0));
    const ext = contentType === "image/png" ? "png" : contentType === "image/jpeg" ? "jpg" : "webp";
    const path = `${route}/${point}-${Date.now()}-${crypto.randomUUID().slice(0, 8)}.${ext}`;

    const upload = await admin.storage.from("treasure-images").upload(path, bytes, {
      contentType,
      cacheControl: "31536000",
      upsert: false,
    });
    if (upload.error) return json({ error: upload.error.message }, 500);

    const pub = admin.storage.from("treasure-images").getPublicUrl(path);
    return json({ path, publicUrl: pub.data.publicUrl });
  } catch (e) {
    return json({ error: e instanceof Error ? e.message : String(e) }, 500);
  }
});
