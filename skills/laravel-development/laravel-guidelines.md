---
name: laravel-guidelines
description: >
  PHP and Laravel coding guidelines from Spatie. Apply when writing or reviewing Laravel code
  — covers naming conventions, type declarations, control flow, and Laravel-specific patterns.
user-invocable: true
context: fork
disable-model-invocation: false
---

# Laravel Guidelines Spatie Style influenced)

**Follow Laravel conventions first.** If Laravel has a documented way to do something, use it.
Only deviate when you have a clear justification.

---

## PHP Standards

- Follow PSR-1, PSR-2, and PSR-12
- Use short nullable notation: `?string` not `string|null`
- Always specify `void` return types when methods return nothing
- Use typed properties, not docblocks
- Use constructor property promotion when all properties can be promoted

### Method Visibility

- **Prefer `protected` over `private`** for non-public methods — it keeps classes extensible without sacrificing encapsulation
- Only use `private` when explicitly asked to, or when you have a strong reason to prevent subclass access
- `public` for the intended external API, `protected` for internal implementation details

```php
// Good — protected allows subclasses to override or reuse
protected function buildQuery(): Builder
{
    return $this->model->newQuery();
}

// Only when explicitly required or intentionally sealed
private function hashPassword(string $password): string
{
    return bcrypt($password);
}
```

---

## Docblocks

- Don't add docblocks for fully type-hinted methods unless a description is needed
- Always import classnames in docblocks — never use fully qualified names inline:
  ```php
  use Spatie\Url\Url;
  /** @return Url */
  ```
- Use one-line docblocks when possible: `/** @var string */`
- For iterables, always specify key and value types:
  ```php
  /** @return Collection<int, User> */
  ```
- Use array shape notation for fixed-key arrays, one key per line:
  ```php
  /** @return array{
     first: SomeClass,
     second: SomeClass
  } */
  ```

---

## Control Flow

- **Happy path last**: handle error conditions first, success case last
- **Avoid `else`**: use early returns instead of nested conditions
- **Always use curly braces** even for single-statement blocks
- **Ternary operators**: keep short ternaries on one line; multi-line ternaries — each part on its own line

```php
// Good — early returns
if (! $user) {
    return null;
}

if (! $user->isActive()) {
    return null;
}

// Good — multi-line ternary
$result = $object instanceof Model
    ? $object->name
    : 'A default value';
```

---

## Exception Handling

Always use the full, descriptive variable name in `catch` blocks — never single-letter abbreviations.

```php
// Bad
try {
    $this->process();
} catch (Exception $e) {
    Log::error($e->getMessage());
}

// Good
try {
    $this->process();
} catch (Exception $exception) {
    Log::error($exception->getMessage());
}
```

This follows the same rule as all other variables: `$exception` not `$e`, `$request` not `$r`.

---

## Naming Conventions

| Context | Style | Example |
|---|---|---|
| Classes / Enums | PascalCase | `OrderStatus` |
| Methods / Variables | camelCase | `getUserName`, `$firstName` |
| Routes / URLs | kebab-case | `/open-source` |
| Route names | camelCase | `->name('openSource')` |
| Route parameters | camelCase | `{userId}` |
| Config files | kebab-case | `pdf-generator.php` |
| Config keys | snake_case | `chrome_path` |
| Artisan commands | kebab-case | `delete-old-records` |
| Views | camelCase | `openSource.blade.php` |

- Never use single-letter variable names — use descriptive names (`$exception` not `$e`)
- Always use `use` statements — never inline fully qualified class names (e.g. `\Exception`)

---

## Laravel Conventions

### Controllers
- Singular resource names: `PostController`
- Stick to CRUD methods: `index`, `create`, `store`, `show`, `edit`, `update`, `destroy`
- Extract a new controller for non-CRUD actions instead of adding ad-hoc methods
- Use a nested resource controller for related resources: `PostCommentController`
- Route tuple notation: `[PostController::class, 'index']`

### Configuration
- Service configs go in `config/services.php` — don't create new config files for services
- Use `config()` helper; never call `env()` outside of config files

### Artisan Commands
- Always provide feedback: `$this->comment('All ok!')`
- Show progress for loops; print a summary at the end
- Print output **before** processing the item (easier debugging):
  ```php
  $items->each(function (Item $item) {
      $this->info("Processing item id `{$item->id}`...");
      $this->processItem($item);
  });

  $this->comment("Processed {$items->count()} items.");
  ```

### Validation
- Use array notation for rules (required when adding custom rule classes):
  ```php
  'email' => ['required', 'email'],
  ```

### Blade
- Indent with 4 spaces
- No spaces after control structure directives:
  ```blade
  @if($condition)
      Something
  @endif
  ```

### Authorization
- Policy method names: camelCase, use `view` instead of `show`

### Translations
- Use `__()` helper over `@lang` directive

### API Routes
- Plural resource names: `/errors`
- kebab-case paths: `/error-occurrences`

---

## Strings

- Use string interpolation over concatenation: `"Hello {$name}"` not `'Hello ' . $name`

---

## Enums

- Enum case names: PascalCase (`OrderStatus::Pending`)

---

## Comments

Code should be self-documenting. Comments that describe *what* code does are a smell — rename
the variable or extract a method instead.

Only add a comment when explaining **why** something non-obvious is done.

```php
// Bad — comment describes what
// Get failed checks for this site
$checks = $site->checks()->where('status', 'failed')->get();

// Good — name describes what
$failedChecks = $site->checks()->where('status', 'failed')->get();
```

Never add comments to tests — test names should be descriptive enough on their own.

---

## Whitespace

- Add blank lines between statements to let code breathe
- Exception: sequences of equivalent single-line operations can be grouped
- No extra empty lines inside `{}` brackets

---

## File / Class Naming

| Type | Convention             | Example |
|---|------------------------|---|
| Jobs | action-based           | `CreateUser`, `SendEmailNotification` |
| Events | tense-based            | `UserRegistering`, `UserRegistered` |
| Listeners | action + `Listener`    | `SendInvitationMailListener` |
| Commands | action + `Command`     | `PublishScheduledPostsCommand` |
| Mailables | purpose + `Mail`       | `AccountActivatedMail` |
| Resources | singular + `Resource`  | `UserResource` |
| Enums | descriptive, no prefix | `OrderStatus`, `BookingType` |
