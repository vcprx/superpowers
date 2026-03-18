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

This skill bundles one reference file. Read it when relevant.

## References

**`references/writing-laravel-api-documentation.md`** — Read this file when the task involves writing or updating OpenAPI/Swagger documentation. Covers l5-swagger annotations for controllers, `FormRequest` classes, `ApiResource` and `ResourceCollection` classes, base controller setup (`OA\Info` / `OA\Components`), and regenerating the spec with `php artisan l5-swagger:generate`. Read it when the user asks to add, fix, or regenerate API docs.
