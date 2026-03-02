---
name: laravel-api-development
description: >
  Use when working on a Laravel API project — routing tasks to the appropriate
  sub-skill (e.g. writing API documentation with l5-swagger).
user-invocable: false
disable-model-invocation: false
---

# Laravel API Development

This skill family covers common Laravel API development tasks. Each sub-skill handles a specific
concern; invoke the most appropriate one for the task at hand.

## Available Sub-Skills

| Sub-skill | File | When to invoke |
|-----------|------|----------------|
| `writing-laravel-api-documentation` | `writing-laravel-api-documentation.md` | Writing, adding, or updating l5-swagger OpenAPI annotations on controllers, form requests, and API resources |

## When to Invoke Each Sub-Skill

**`writing-laravel-api-documentation`** — invoke when the user asks to:
- Add OpenAPI/Swagger documentation to a Laravel controller or endpoint
- Annotate a `FormRequest` class for l5-swagger
- Annotate an `ApiResource` or `ResourceCollection` class
- Set up the base controller with `OA\Info` / `OA\Components`
- Regenerate the OpenAPI spec (`php artisan l5-swagger:generate`)
- Fix or update existing l5-swagger annotations
