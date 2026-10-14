# Serverpod Online Shop (Serverpod 4.0)

Flutter + Serverpod (Dart) + PostgreSQL. Products, orders, order items, stock-safe checkout inside a DB transaction, email sign-in.

```
shop/
├── shop_server/    Serverpod backend (models, endpoints, config)
├── shop_client/    Client package (filled in by `serverpod generate`)
└── shop_flutter/   Flutter app (product list, search, cart, sign-in, checkout)
```

Targets **Serverpod 4.0.x** (CLI 4.0.4, Dart 3.12.2+). All `serverpod*` packages are pinned to `4.0.4`; if `serverpod version` prints something else, change the pins in the three `pubspec.yaml` files to match.

> The generated code (`shop_server/lib/src/generated/` and `shop_client/lib/`) is produced by `serverpod generate`, so it is not in this ZIP.

## Run it

Run from the project root (`shop/`):

```bash
# 1. Dependencies
(cd shop_server  && dart pub get)
(cd shop_flutter && flutter pub get)

# 2. Generate protocol + client code, then create the DB migration
(cd shop_server && serverpod generate && serverpod create-migration)

# 3. Start server + database + Flutter app together, with hot reload
serverpod start
```

`serverpod start` applies the migration, starts the embedded Postgres (no Docker needed), runs the server and launches the Flutter app. Prefer to run things yourself?

```bash
cd shop_server && dart run bin/main.dart --apply-migrations
cd ../shop_flutter && flutter run
```

To use Docker Postgres instead of the embedded one, delete the `dataPath:` line in `shop_server/config/development.yaml` and run `docker compose up -d` in `shop_server`.

On first start in development the server seeds 6 sample products if the table is empty.

## Signing in (development)
Checkout requires login. In the app tap **Sign in**, register with an email, and read the verification code from the **server log** (`[EmailIDP] Registration code ...`). No email provider is needed in development. Replace the two `_send...Code` functions in `shop_server/lib/server.dart` with a real mailer before staging/production.

## Endpoints
| Endpoint | Method | Notes |
|---|---|---|
| `product` | `listProducts({search, limit, offset})` | public, limit clamped to 1-100 |
| `product` | `getProduct(id)` | public |
| `order` | `createOrder(List<OrderItemRequest>)` | login required; transaction + row locks (`FOR UPDATE`), stock check/deduct, saves order + items |
| `order` | `myOrders()` | login required |
| `emailIdp`, `refreshJwtTokens` | auth | from `serverpod_auth_idp_server` |

## Before production
- Replace every secret in `shop_server/config/passwords.yaml` with long random values (never commit it), and create `production.yaml` from `development.yaml` without `dataPath`.
- Prices are `double`. For real payments use integer minor units (cents/KES).

## Troubleshooting
- **Version mismatch on `dart pub get`:** make all `serverpod*` pins equal to `serverpod version`.
- **`serializationDataType=jsonb` rejected:** remove that option in `product.spy.yaml`, then regenerate.
- **Android emulator can't reach the server:** `client.dart` already uses `10.0.2.2`; on a real device put your LAN IP there.
- **"Database does not match target state" on start:** stop, delete `shop_server/.dart_tool/serverpod`, rerun `serverpod start`.