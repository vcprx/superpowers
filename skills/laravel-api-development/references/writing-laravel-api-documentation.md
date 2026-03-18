---
name: writing-laravel-api-documentation
description: >
  Use when asked to write, add, or update l5-swagger OpenAPI documentation
  for a Laravel API. Handles controllers, form requests, API resources, and
  base controller setup.
user-invocable: true
context: fork
disable-model-invocation: false
---

# Writing Laravel API Documentation (l5-swagger ^9.0)

## Core Rule: Always Use PHP Attributes

**Never use docblock annotations.** Always use PHP 8 attributes:

```php
use OpenApi\Attributes as OA;
```

---

## 1. Base Controller Setup

Place `OA\Info`, `OA\Components`, and shared `OA\Schema` definitions on the abstract base `Controller` class.

```php
use OpenApi\Attributes as OA;

#[OA\Info(title: 'My API', version: '1.0.0')]
#[OA\Components(
    schemas: [
        new OA\Schema(
            schema: 'PaginationMeta',
            properties: [
                new OA\Property(property: 'current_page', type: 'integer', example: 1),
                new OA\Property(property: 'last_page', type: 'integer', example: 10),
                new OA\Property(property: 'per_page', type: 'integer', example: 15),
                new OA\Property(property: 'total', type: 'integer', example: 150),
            ]
        ),
    ],
    responses: [
        new OA\Response(response: 401, description: 'Unauthenticated'),
        new OA\Response(response: 403, description: 'Forbidden'),
        new OA\Response(response: 404, description: 'Not Found'),
        new OA\Response(
            response: 422,
            description: 'Unprocessable Entity',
            content: new OA\JsonContent(
                properties: [
                    new OA\Property(property: 'message', type: 'string'),
                    new OA\Property(property: 'errors', type: 'object'),
                ]
            )
        ),
    ]
)]
abstract class Controller { ... }
```

---

## 2. config/l5-swagger.php — Scan Paths

The `annotations` array must include every directory that contains annotated classes.
For modular Laravel apps, add each module root:

```php
'annotations' => [
    base_path('app'),
    base_path('modules'),   // add each module root
],
```

**Always check `config/l5-swagger.php` and add any missing scan paths before generating.**

---

## 3. FormRequest Annotations

Add `OA\Schema` directly on the class. The `schema` name matches the class short name.

```php
#[OA\Schema(
    schema: 'PaymentStoreRequest',
    required: ['amount', 'currency'],
    properties: [
        new OA\Property(property: 'amount', description: 'Amount in cents', type: 'integer', example: 1000),
        new OA\Property(property: 'currency', description: 'ISO 4217 currency code', type: 'string', example: 'USD'),
        // Nested object
        new OA\Property(
            property: 'metadata',
            type: 'object',
            properties: [
                new OA\Property(property: 'order_id', type: 'string', example: 'ORD-123'),
            ]
        ),
        // Array field
        new OA\Property(
            property: 'items',
            type: 'array',
            items: new OA\Items(type: 'string', example: 'item-uuid')
        ),
    ]
)]
class PaymentStoreRequest extends FormRequest { ... }
```

**Query-only FormRequests** — use `OA\Parameter` at class level instead of `OA\Schema`:

```php
#[OA\Parameter(
    parameter: 'PaymentFilterRequest',
    name: 'status',
    in: 'query',
    schema: new OA\Schema(type: 'string', enum: ['pending', 'paid', 'failed'])
)]
class PaymentFilterRequest extends FormRequest { ... }
```

---

## 4. API Resource Annotations

Use the **dual-schema pattern** on every `JsonResource`.

```php
// First schema: the data object
#[OA\Schema(
    schema: 'Payment',
    properties: [
        new OA\Property(property: 'id', type: 'string', format: 'uuid', example: 'a1b2c3d4-...'),
        new OA\Property(property: 'amount', type: 'integer', example: 1000),
        new OA\Property(property: 'currency', type: 'string', example: 'USD'),
        new OA\Property(property: 'status', type: 'string', example: 'pending'),
        new OA\Property(property: 'created_at', type: 'string', format: 'date-time'),
    ]
)]
// Second schema: the resource wrapper
#[OA\Schema(
    schema: 'PaymentResource',
    properties: [
        new OA\Property(property: 'data', ref: '#/components/schemas/Payment'),
    ]
)]
class PaymentResource extends JsonResource { ... }
```

**ResourceCollection** — schema with `data` as array + pagination meta:

```php
#[OA\Schema(
    schema: 'PaymentCollection',
    properties: [
        new OA\Property(
            property: 'data',
            type: 'array',
            items: new OA\Items(ref: '#/components/schemas/Payment')
        ),
        new OA\Property(property: 'meta', ref: '#/components/schemas/PaginationMeta'),
    ]
)]
class PaymentCollection extends ResourceCollection { ... }
```

**Nested resources** — always reference via `ref`, never inline:

```php
new OA\Property(property: 'user', ref: '#/components/schemas/User'),
```

---

## 5. Controller Endpoint Annotations

### Path Parameters — Define at Controller Class Level

Define reusable path parameters as `OA\Parameter` on the controller class (not on the base controller,
not inline in each method). Reference them inside methods via `ref:`.

```php
#[OA\Parameter(
    parameter: 'PaymentId',
    name: 'payment',
    in: 'path',
    required: true,
    schema: new OA\Schema(type: 'string', format: 'uuid'),
    description: 'Payment UUID'
)]
class PaymentController extends Controller
{
    #[OA\Get(
        path: '/api/payments',
        summary: 'List payments',
        tags: ['Payments'],
        responses: [
            new OA\Response(
                response: 200,
                description: 'Paginated list of payments',
                content: new OA\JsonContent(ref: '#/components/schemas/PaymentCollection')
            ),
            new OA\Response(ref: '#/components/responses/401'),
            new OA\Response(ref: '#/components/responses/403'),
        ]
    )]
    public function index(PaymentFilterRequest $request): PaymentCollection { ... }

    #[OA\Post(
        path: '/api/payments',
        summary: 'Create a payment',
        tags: ['Payments'],
        requestBody: new OA\RequestBody(
            required: true,
            content: new OA\JsonContent(ref: '#/components/schemas/PaymentStoreRequest')
        ),
        responses: [
            new OA\Response(
                response: 201,
                description: 'Payment created',
                content: new OA\JsonContent(ref: '#/components/schemas/PaymentResource')
            ),
            new OA\Response(ref: '#/components/responses/422'),
            new OA\Response(ref: '#/components/responses/401'),
        ]
    )]
    public function store(PaymentStoreRequest $request): PaymentResource { ... }

    #[OA\Get(
        path: '/api/payments/{payment}',
        summary: 'Get a payment',
        tags: ['Payments'],
        parameters: [
            new OA\Parameter(ref: '#/components/parameters/PaymentId'),
        ],
        responses: [
            new OA\Response(
                response: 200,
                description: 'Payment details',
                content: new OA\JsonContent(ref: '#/components/schemas/PaymentResource')
            ),
            new OA\Response(ref: '#/components/responses/404'),
            new OA\Response(ref: '#/components/responses/401'),
        ]
    )]
    public function show(Payment $payment): PaymentResource { ... }

    #[OA\Delete(
        path: '/api/payments/{payment}',
        summary: 'Delete a payment',
        tags: ['Payments'],
        parameters: [
            new OA\Parameter(ref: '#/components/parameters/PaymentId'),
        ],
        responses: [
            new OA\Response(response: 204, description: 'No Content'),
            new OA\Response(ref: '#/components/responses/404'),
            new OA\Response(ref: '#/components/responses/401'),
            new OA\Response(ref: '#/components/responses/403'),
        ]
    )]
    public function destroy(Payment $payment): Response { ... }
}
```

### Response Reference Rules

- **Common errors** (401, 403, 404, 422) → always reference from base controller via `new OA\Response(ref: '#/components/responses/...')`
- **Endpoint-specific errors** (e.g. a unique 400 message) → define inline only for that endpoint
- **Success responses** → always define inline with the appropriate schema ref

---

## 6. Generation Command

After annotating, generate the spec:

```bash
php artisan l5-swagger:generate
```

Fix any errors reported before considering the task complete.

---

## Checklist Before Finishing

- [ ] `OA\Info` present on base controller
- [ ] `OA\Components` with common error responses on base controller
- [ ] All scan paths added to `config/l5-swagger.php` `annotations` array
- [ ] FormRequests have `OA\Schema` (or `OA\Parameter` for query-only)
- [ ] Resources use dual-schema pattern (data object + wrapper)
- [ ] `ResourceCollection` schemas include `data` array + `meta` pagination ref
- [ ] Nested resources referenced via `ref:`, not inlined
- [ ] Path parameters defined at controller class level and referenced via `ref:` in methods
- [ ] Common error responses referenced via `ref:` (not duplicated inline)
- [ ] PHP attributes used throughout — no docblock annotations
- [ ] `php artisan l5-swagger:generate` runs without errors
