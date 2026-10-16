# Kenya Shop

An online shop for Kenyan sellers and shoppers, with M-Pesa checkout. Built end to end in Dart for a Flutter app on a Serverpod 4 backend with PostgreSQL.

**Demo video:** [https://www.youtube.com/watch?v=jnVRe011E2k]
**Demo video 2:** [https://www.youtube.com/watch?v=vywCBs7sCGo]

**pics of what to expect
![alt text](<Screenshot from 2026-10-14 19-49-52.png>)







## What it is

Small sellers in Kenya need a shop that takes M-Pesa. Shoppers browse and search products, fill a cart and pay with M-Pesa. Shop owners manage the catalogue from inside the same app: add, edit, hide and delete products, with no separate admin tool.

## Features

**Shoppers**
- Product grid with search, endless scrolling and detail pages
- Cart with quantity limits based on live stock
- Email sign-up and sign-in
- Checkout with M-Pesa (STK Push), live payment status, and clear success, failed and still-waiting screens
- Order history with status chips

**Shop owners (admin accounts)**
- Add, edit and delete products, with price in KES, stock, image link and extra details
- Hide a product from the shop without deleting it, so order history stays intact

**Platform**
- Android, web and desktop from one Flutter codebase; bottom navigation on phones, side rail on wide screens
- Light and dark themes

## Built with Serverpod 4

| Serverpod feature | Where it is used |
|---|---|
| YAML models, ORM and migrations | `shop_server/lib/src/models/*.spy.yaml` define four tables (`product`, `shop_order`, `order_item`, `mpesa_payment`), enums, a request DTO and an exception |
| Typed endpoints and generated client | `product`, `order`, `payment` and `admin` endpoints; the app calls `client.order.createOrder(...)` with no hand-written HTTP |
| Database transactions and row locks | `createOrder` and the payment result handler run in one transaction with `FOR UPDATE` locks |
| Authentication | Email sign-in with JWT tokens; `requireLogin` on the order, payment and admin endpoints |
| Custom web server route | `POST /payments/callback/<token>` receives the payment result from Safaricom Daraja |
| Serializable exceptions | `ShopException` is thrown on the server and caught by type in the Flutter app |
| Server config and secrets | Run-mode specific `passwords.yaml` |
| Sessions outside requests | The development payment simulator creates its own session with `pod.createSession` |

## Architecture

```
Flutter app ──typed client──▶ Serverpod server ──ORM──▶ PostgreSQL
(Android / web)                ├─ endpoints: product, order, payment, admin, emailIdp
                               ├─ web route: POST /payments/callback/<token> ◀── Safaricom Daraja
                               └─ M-Pesa client ──▶ Daraja (STK Push / STK Query)
```

**Order and payment flow**
1. `createOrder` checks stock, deducts it and saves the order and its lines in one transaction. The order is `pending`.
2. `startMpesaPayment` sends an STK Push (or starts the simulator in development) and saves an `mpesa_payment` row.
3. The result arrives through the callback route. If the callback is lost, `getPaymentStatus` asks Daraja directly (STK Query) after 15 seconds.
4. One idempotent function applies the result: success marks the order `paid`; failure or cancellation marks it `cancelled` and returns the stock.

**Data model**

| Table | Notes |
|---|---|
| `product` | name, description, price, stock, imageUrl, metadata (JSONB), isActive |
| `shop_order` | userId (UUID), totalAmount, status (`pending`, `paid`, `shipped`, `delivered`, `cancelled`), createdAt |
| `order_item` | order, product, quantity, and the price at purchase time |
| `mpesa_payment` | order, phone, amount, Daraja request IDs, status, receipt, result code and description |

## Run it locally

**Requirements:** Flutter, Dart 3.12+, Serverpod CLI 4.0.4 (`dart pub global activate serverpod_cli`). Docker is optional. Ports 8080 to 8082 and 8090 must be free.

```bash
# from the project root
cp shop_server/config/passwords.example.yaml shop_server/config/passwords.yaml
(cd shop_server  && dart pub get)
(cd shop_flutter && flutter pub get)
serverpod start
```

`serverpod start` applies the committed migrations, starts an embedded PostgreSQL (no Docker needed), runs the server and launches the web app. All `serverpod*` packages are pinned to `4.0.4`; if `serverpod version` prints something else, change the pins in the three `pubspec.yaml` files to match.

Generated code is committed, so `serverpod generate` is only needed after you change a model or endpoint:

```bash
cd shop_server && serverpod generate && serverpod create-migration
```

To use Docker Postgres instead of the embedded one, delete the `dataPath:` line in `shop_server/config/development.yaml` and run `docker compose up -d` in `shop_server`.

### Configuration (`shop_server/config/passwords.yaml`)

| Key | Purpose |
|---|---|
| `adminUserIds` | Comma-separated user IDs allowed to manage products |
| `mpesaSimulate` | `'true'` in development fakes the M-Pesa prompt (see below) |
| `mpesaConsumerKey`, `mpesaConsumerSecret`, `mpesaPasskey`, `mpesaShortcode` | Daraja sandbox credentials (only for real sandbox calls) |
| `mpesaCallbackBaseUrl`, `mpesaCallbackToken` | Public HTTPS address and secret path token for the Daraja callback |
| `smtpHost`, `smtpUsername`, `smtpPassword`, `smtpFrom` | Optional email delivery (tested with Resend). If unset in development, emails are written to the server log instead |

`passwords.yaml` is git-ignored. Never commit it.

## Try it in five minutes (testing guide)

No Safaricom account or email provider is needed.

1. Run `serverpod start`. The web app opens in Chrome.
2. **Create the admin.** Open **Account**, register with any email, and read the verification code from the server console (a line starting `[Email to ...]`).
3. **Make that account an admin.** In **Account** (debug builds), tap **Copy my user ID**, paste it into `adminUserIds` in `passwords.yaml`, and restart the server. A **Manage products** row appears in **Account**.
4. **Add products** in **Manage products**, then check the **Shop** tab.
5. **Buy as a customer.** Sign out, register a second account, add items to the cart and check out with any valid Safaricom-style number, such as `0712345678`. After about six seconds the simulated payment succeeds, the order shows as **Paid**, and the stock drops. A number ending in `0000`, such as `0700000000`, simulates a cancelled payment: the order is cancelled and the stock returns.

## M-Pesa: simulator and Daraja sandbox

- **Simulator (default in development).** With `mpesaSimulate: 'true'`, the server never contacts Safaricom. It waits six seconds and applies a success or cancellation through the same code path as the real callback. The receipt starts with `SIM` and the app labels the payment as a test. It does nothing outside the `development` run mode.
- **Real Daraja sandbox.** Set `mpesaSimulate` to `'false'`, fill in the Daraja credentials, expose the web server port (8082) through an HTTPS tunnel such as ngrok, and set `mpesaCallbackBaseUrl` to that address. The sandbox does not send prompts to real phones and callback delivery can be unreliable, which is why the STK Query fallback exists.
- **Production** needs a Paybill or Till number, Safaricom Go Live approval and a permanent HTTPS address for the callback. The code path is the same; only credentials and the base URL change.

## Run on Android

The Android emulator reaches the server at `10.0.2.2` automatically. For a physical phone on the same Wi-Fi as your computer:

```bash
hostname -I | awk '{print $1}'        # your computer's address
cd shop_flutter
flutter build apk --debug --dart-define=API_URL=http://YOUR_COMPUTER_IP:8080/
flutter install
```

Over USB you can instead run `adb reverse tcp:8080 tcp:8080` and use `API_URL=http://localhost:8080/`. Debug builds allow plain HTTP; release builds need HTTPS.

## API reference

| Endpoint | Method | Access | Notes |
|---|---|---|---|
| `product` | `listProducts({search, limit, offset})` | public | Active products only; limit clamped to 1 to 100 |
| `product` | `getProduct(id)` | public | Returns nothing for hidden products |
| `order` | `createOrder(items)` | signed in | Transaction and row locks, stock check and deduction, rejects hidden products |
| `order` | `myOrders()` | signed in | The caller's orders, newest first |
| `payment` | `startMpesaPayment(orderId, phone)` | signed in | Order owner only; STK Push or simulator |
| `payment` | `getPaymentStatus(orderId)` | signed in | Order owner only; STK Query fallback after 15 seconds |
| `admin` | `isAdmin()`, `myUserId()` | signed in | Used by the app to show admin options |
| `admin` | `listAllProducts`, `saveProduct`, `deleteProduct` | admin only | Checked on the server against `adminUserIds` |
| `emailIdp`, `refreshJwtTokens` | auth | public | From `serverpod_auth_idp_server` |
| `POST /payments/callback/<token>` | web route | token in path | Receives Daraja's payment result |

## Project structure

```
shop_server/    Serverpod backend: models, endpoints, M-Pesa client, callback route, config
shop_client/    Generated client package
shop_flutter/   Flutter app: shop, cart, checkout, orders, account, admin screens
```

## Honest limitations

- Payments use the Daraja sandbox or the built-in simulator. No real money moves.
- Money is stored as `double` and charged in whole shillings. A production system should use integer minor units.
- Admin access is an allow-list of user IDs rather than Serverpod role scopes.
- Orders that are never paid are not expired automatically, so they hold stock until they fail.
- Product photos are links, not uploads. The cart is held in memory only.
- There are no automated tests yet. The "no overselling" behaviour comes from the transaction and row-lock design and has been exercised by hand only.
- Email delivery was tested with Resend using an unverified domain, which only delivers to the account owner's address. Development uses the server log instead.

## Use of AI tools

[EDIT SO THIS IS ACCURATE.] This project was built with assistance from Claude (Anthropic) for code generation, debugging and documentation. The author ran, tested and integrated all code. No AI-generated media is used in the app.

## Troubleshooting

- **Version mismatch on `dart pub get`:** make all `serverpod*` pins equal to `serverpod version`.
- **`serializationDataType=jsonb` rejected:** remove that option in `product.spy.yaml`, then regenerate.
- **Server crashes at startup while reading passwords:** `passwords.yaml` is not valid YAML. Keep every value inside single quotes.
- **Phone shows "Could not load products":** the app can't reach your computer. Check the address in `API_URL`, that both devices share the Wi-Fi, and that `serverpod start` is running.
- **"Database does not match target state" on start:** stop, delete `shop_server/.dart_tool/serverpod`, and run `serverpod start` again.
- **Ports in use:** the backend needs 8080 to 8082 free, and 8090 for the database.