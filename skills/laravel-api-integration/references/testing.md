# Testing Saloon Integrations

Saloon never makes real HTTP requests during tests. Use `Saloon::fake()` or `MockClient::global()` to intercept requests and return controlled responses.

---

## Saloon::fake() — preferred for feature tests

`Saloon::fake()` is provided by `saloonphp/laravel-plugin` and is the cleanest option for Pest/PHPUnit feature tests. It hooks into the global Saloon instance automatically — no connector instance needed.

```php
use Modules\Sanity\Requests\GetArticleRequest;
use Saloon\Http\Faking\MockResponse;
use Saloon\Laravel\Facades\Saloon;

it('returns 200 for a valid slug', function (): void {
    Saloon::fake([
        GetArticleRequest::class => MockResponse::make([
            'result' => [
                '_id'         => '1',
                'title'       => 'Test Article',
                'slug'        => ['current' => 'test-article'],
                'publishedAt' => '2024-01-01T00:00:00Z',
            ],
        ]),
    ]);

    get(route('web.article.show', 'test-article'))->assertOk();
});
```

Always mirror the **real API response shape** in `MockResponse::make()`. If the live API wraps results in a `result` key, the mock body must do the same — the controller will parse it the same way.

---

## MockClient::global() — alternative

Use `MockClient::global()` when you cannot or do not want to use the facade (e.g. outside of Laravel's service container). Always call `MockClient::destroyGlobal()` in `afterEach` to avoid state leaking between tests.

```php
use Saloon\Http\Faking\MockClient;
use Saloon\Http\Faking\MockResponse;
use Modules\Sanity\Requests\GetSitemapArticlesRequest;

beforeEach(function (): void {
    MockClient::global([
        GetSitemapArticlesRequest::class => MockResponse::make([
            'result' => [
                ['slug' => ['current' => 'first-article'], 'publishedAt' => '2024-01-01T00:00:00Z'],
                ['slug' => ['current' => 'second-article'], 'publishedAt' => '2024-06-15T00:00:00Z'],
            ],
        ]),
    ]);
});

afterEach(function (): void {
    MockClient::destroyGlobal();
});
```

---

## Faking multiple requests at once

Pass all request classes the test touches in a single `fake()` call. Commonly done in `beforeEach` when every test in a file needs the same baseline:

```php
beforeEach(function (): void {
    Saloon::fake([
        GetFeaturedArticlesRequest::class => MockResponse::make([
            'result' => [[
                '_id'         => '1',
                'title'       => 'Test Article',
                'slug'        => ['current' => 'test-article'],
                'publishedAt' => '2024-01-01T00:00:00Z',
                'category'    => ['name' => 'Test', 'slug' => ['current' => 'test']],
            ]],
        ]),
        GetCategoriesRequest::class => MockResponse::make([
            'result' => [[
                '_id'          => '2',
                'name'         => 'Test Category',
                'slug'         => ['current' => 'test-category'],
                'articleCount' => 1,
            ]],
        ]),
    ]);
});
```

---

## Faking error responses

```php
Saloon::fake([
    GetArticleRequest::class => MockResponse::make(['result' => null], 200),
]);

get(route('web.article.show', 'does-not-exist'))->assertNotFound();
```

```php
Saloon::fake([
    GetArticleRequest::class => MockResponse::make(['message' => 'Unauthorized'], 401),
]);
```

---

## Asserting requests were sent

```php
use Saloon\Http\Faking\MockClient;
use Saloon\Http\Request;
use Saloon\Http\Response;

$mock = new MockClient([
    GetArticleRequest::class => MockResponse::make(['result' => null]),
]);

// attach to a specific connector instance
$connector->withMockClient($mock);
$connector->send(new GetArticleRequest($dataset, 'my-slug'));

$mock->assertSent(GetArticleRequest::class);

$mock->assertSent(function (Request $request, Response $response): bool {
    expect($request)->toBeInstanceOf(GetArticleRequest::class)
        ->and($response->status())->toBe(200);

    return true;
});

$mock->assertNotSent(GetCategoriesRequest::class);
$mock->assertNothingSent();
```

> `assertSent` / `assertNotSent` require a `MockClient` instance. They are not available on the `Saloon::fake()` facade directly — use `MockClient::global()` or `$connector->withMockClient()` when you need assertions.
