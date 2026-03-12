---
name: laravel-api-development
description: >
  Use when writing or documenting a Laravel API, or when working with Laravel
  controllers that serve JSON responses.

  TRIGGER when:
  - user adds or edits API endpoints
  - user adds or edits OpenAPI/Swagger annotations
  - user works with FormRequest or ApiResource classes
  - user asks about API documentation in a Laravel project

  DO NOT TRIGGER when: working on non-Laravel APIs or non-PHP projects.
user-invocable: false
disable-model-invocation: false
---

# Laravel API Development

This skill family covers common Laravel API development tasks. Each sub-skill handles a specific
concern; invoke the most appropriate one for the task at hand.

## Available Sub-Skills

| Sub-skill | File | When to invoke |
|-----------|------|----------------|
| `writing-laravel-api-documentation` | `writing-laravel-api-documentation.md` | Writing or updating API documentation — including OpenAPI annotations |

## When to Invoke Each Sub-Skill

**`writing-laravel-api-documentation`** — invoke when the user asks to:
- Add OpenAPI/Swagger documentation to a Laravel controller or endpoint
- Annotate a `FormRequest` class for l5-swagger
- Annotate an `ApiResource` or `ResourceCollection` class
- Set up the base controller with `OA\Info` / `OA\Components`
- Regenerate the OpenAPI spec (`php artisan l5-swagger:generate`)
- Fix or update existing l5-swagger annotations
