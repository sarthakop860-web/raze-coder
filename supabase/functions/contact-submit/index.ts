import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { corsHeaders } from "../_shared/cors.ts";
Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });
  if (req.method !== "POST") return new Response(JSON.stringify({ error: "Method not allowed" }), { status: 405, headers: { ...corsHeaders, "Content-Type": "application/json" } });
  try {
    const body = await req.json();
    if (body.website) return new Response(JSON.stringify({ ok: true }), { headers: { ...corsHeaders, "Content-Type": "application/json" } });
    const name = String(body.name ?? "").trim(); const email = String(body.email ?? "").trim().toLowerCase();
    const subject = String(body.subject ?? "").trim(); const message = String(body.message ?? "").trim();
    if (name.length < 2 || name.length > 80 || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email) || email.length > 254 || subject.length < 2 || subject.length > 120 || message.length < 10 || message.length > 4000) {
      return new Response(JSON.stringify({ error: "Please check the form fields and try again." }), { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } });
    }
    const url = Deno.env.get("SUPABASE_URL"); const key = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
    if (!url || !key) throw new Error("Contact service is not configured.");
    const admin = createClient(url, key, { auth: { persistSession: false } });
    const forwarded = req.headers.get("x-forwarded-for")?.split(",")[0]?.trim() ?? "unknown";
    const digest = await crypto.subtle.digest("SHA-256", new TextEncoder().encode(forwarded));
    const ipHash = Array.from(new Uint8Array(digest)).map((b) => b.toString(16).padStart(2, "0")).join("");
    const { data: allowed, error: rateError } = await admin.rpc("consume_contact_rate_limit", { p_ip_hash: ipHash });
    if (rateError) throw rateError;
    if (!allowed) return new Response(JSON.stringify({ error: "Too many messages. Please wait a few minutes before trying again." }), { status: 429, headers: { ...corsHeaders, "Content-Type": "application/json" } });
    const { error } = await admin.from("contact_messages").insert({ name, email, subject, message });
    if (error) throw error;
    return new Response(JSON.stringify({ ok: true }), { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } });
  } catch (error) {
    console.error("contact-submit:", error);
    return new Response(JSON.stringify({ error: "We could not submit your message. Please try again later." }), { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } });
  }
});
