---
name: developing-modular-laravel
description: >
  Use when scaffolding or extending a modular Laravel application — covers namespace
  registration, ModuleServiceProvider, per-module directory structure, service provider
  wiring, and connecting module models to centralized Eloquent factories.
user-invocable: true
context: fork
disable-model-invocation: false
---

# Developing Modular Laravel

This guide documents the modular architecture pattern: all feature code lives in
`modules/{ModuleName}/`, isolated by namespace, and wired together through a single
central `ModuleServiceProvider`.

---

## 1. Composer Namespace Registration

Add `Modules\\` to `autoload.psr-4` in `composer.json`:

```json
{
    "autoload": {
        "psr-4": {
            "App\\": "app/",
            "Modules\\": "modules/",
            "Database\\Factories\\": "database/factories/",
            "Database\\Seeders\\": "database/seeders/"
        }
    }
}
```

Then regenerate the autoloader:

```bash
composer dump-autoload
```

**Do this once when setting up the project.** All module namespaces (`Modules\Payment\...`,
`Modules\User\...`, etc.) resolve automatically after this.

---

## 2. ModuleServiceProvider — Central Entrypoint

Create a single top-level provider that registers every module's own provider:

```php
// modules/ModuleServiceProvider.php
<?php

declare(strict_types=1);

namespace Modules;

use Illuminate\Support\ServiceProvider;
use Modules\Payment\Providers\PaymentServiceProvider;

class ModuleServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        $this->app->register(PaymentServiceProvider::class);
        // Add each new module's provider here
    }
}
```

Register it in `bootstrap/providers.php`:

```php
// bootstrap/providers.php
return [
    App\Providers\AppServiceProvider::class,
    Modules\ModuleServiceProvider::class,
];
```

**Rule:** `bootstrap/providers.php` lists only `ModuleServiceProvider`. Individual module
providers are registered inside `ModuleServiceProvider::register()`, not directly in
`bootstrap/providers.php`.

---

## 3. Module Directory Structure

Every module follows the same layout:

```
modules/
└── Payment/
    ├── Actions/
    ├── Builders/
    ├── Casts/
    ├── DataTransferObjects/
    ├── Enums/
    ├── Events/
    ├── Exceptions/
    ├── Http/
    │   ├── Controllers/
    │   ├── Requests/
    │   └── Resources/
    ├── Jobs/
    ├── Listeners/
    ├── Models/
    ├── Providers/
    │   └── PaymentServiceProvider.php
    ├── Rules/
    ├── ValueObjects/
    ├── config.php          (optional)
    ├── console.php         (optional — scheduled commands)
    └── routes.php
```

Only create directories and files that the module actually uses. Everything is on-demand.

---

## 4. Module ServiceProvider

Each module's provider lives in `modules/{Module}/Providers/{Module}ServiceProvider.php`:

```php
// modules/Payment/Providers/PaymentServiceProvider.php
<?php

declare(strict_types=1);

namespace Modules\Payment\Providers;

use Illuminate\Support\ServiceProvider;
use Modules\Payment\Providers\PaymentGatewayIntegrationServiceProvider;

class PaymentServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        $this->mergeConfigFrom(__DIR__ . '/../config.php', 'payment');
        $this->app->register(PaymentGatewayIntegrationServiceProvider::class);
    }

    public function boot(): void
    {
        $this->loadRoutesFrom(__DIR__ . '/../routes.php');
    }
}
```

Key points:
- `mergeConfigFrom` — merge the module's `config.php` under a named key in `register()`
- `loadRoutesFrom` — load the module's `routes.php` in `boot()`
- Sub-providers and singleton bindings go in `register()` so they're available when other providers boot

---

## 5. Eloquent Model ↔ Database Factory

### Model

Module models live in `Modules\{Name}\Models\`. Use the `#[UseFactory]` attribute
(Laravel 11+) to point the model at its centralized factory:

```php
// modules/Payment/Models/Payment.php
<?php

declare(strict_types=1);

namespace Modules\Payment\Models;

use Database\Factories\PaymentFactory;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Attributes\UseFactory;

#[UseFactory(PaymentFactory::class)]
class Payment extends Model
{
    use HasFactory;

    protected $table = 'payments';

    protected function casts(): array
    {
        return [
            'amount'     => 'integer',
            'status'     => \Modules\Payment\Enums\PaymentStatus::class,
        ];
    }

    // Relationships and scopes defined here, inside the module
    public function order(): \Illuminate\Database\Eloquent\Relations\BelongsTo
    {
        return $this->belongsTo(\Modules\Order\Models\Order::class);
    }
}
```

### Factory

Factories remain centralized in `database/factories/` (Laravel convention):

```php
// database/factories/PaymentFactory.php
<?php

declare(strict_types=1);

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;
use Modules\Payment\Models\Payment;

class PaymentFactory extends Factory
{
    protected $model = Payment::class;

    public function definition(): array
    {
        return [
            'amount'     => $this->faker->numberBetween(100, 100000),
            'currency'   => $this->faker->randomElement(['USD', 'EUR', 'GBP']),
            'status'     => \Modules\Payment\Enums\PaymentStatus::Pending,
        ];
    }
}
```

**Summary of the connection:**
- `#[UseFactory(PaymentFactory::class)]` on the model replaces the default factory discovery
- `protected $model = Payment::class` on the factory completes the two-way link
- `HasFactory` trait is included on the model — `Payment::factory()` then works as expected

---

## 6. Adding a New Module — Checklist

- [ ] Directory created at `modules/{Module}/` with `Providers/` and `Models/` subdirs
- [ ] `{Module}ServiceProvider.php` created in `modules/{Module}/Providers/`
- [ ] `routes.php` created in `modules/{Module}/` and loaded via `loadRoutesFrom` in provider
- [ ] Module provider registered inside `ModuleServiceProvider::register()`
- [ ] `Modules\\` autoload entry present in `composer.json` (one-time project setup)
- [ ] `composer dump-autoload` run after any `composer.json` change
- [ ] `ModuleServiceProvider::class` present in `bootstrap/providers.php` (one-time project setup)
- [ ] Model uses `#[UseFactory(MyModelFactory::class)]` attribute
- [ ] Factory in `database/factories/` with `protected $model` set and `definition()` implemented
