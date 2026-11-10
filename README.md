# MASTIF STORE — Netlify + Supabase

## Setup
1. Create a Supabase project.
2. Run `supabase/schema.sql` in Supabase → SQL Editor.
3. In Supabase Project Settings → API, copy Project URL and anon/public key.
4. Edit `public/app.js` and replace `PASTE_SUPABASE_PROJECT_URL` and `PASTE_SUPABASE_ANON_PUBLIC_KEY`.
5. Upload this folder to a private GitHub repository.
6. In Netlify choose Add new site → Import an existing project, connect GitHub.
7. Build command: `npm run build`; publish directory: `public`.

## Included
- English storefront, emerald/blue design
- Supabase email registration/sign-in
- Live product catalog and customer order history
- Binance UID 1239877435 with copy button
- Upload payment proof to private Supabase Storage
- Manual-review order requests
- Telegram contact https://t.me/MastifSalle

## Important limitations
This is an initial Netlify-compatible storefront, not the complete final commerce system. There is no web admin dashboard or automated license issuance/approval yet. Telegram Stars is not integrated and is labelled coming soon. Product prices are initially zero and must be configured in Supabase. Do not publish for real payments until storage policies, admin workflows, privacy/terms/refund policies and security have been reviewed and tested. Never place Supabase service-role keys, bot tokens, passwords or payment-account credentials in frontend code. Involve a parent/guardian for real financial accounts and payment processing.
