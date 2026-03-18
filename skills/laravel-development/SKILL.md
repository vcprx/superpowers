---
name: laravel-development
description: >
  Use when working in a Laravel project OR writing PHP/Laravel code.

  AUTO-LOAD when any of these are detected in the project:
  - artisan file in the project root
  - composer.json containing "laravel/framework"
  - app/Http/ or app/Models/ directories present
  - any .php file is being read or edited

  TRIGGER when:
  - user writes PHP classes, controllers, models, jobs, commands, or service providers
  - user asks about Laravel architecture, modules, or coding conventions

  DO NOT TRIGGER when: working on non-PHP projects or pure front-end (JS/CSS) tasks.
user-invocable: false
disable-model-invocation: false
---

# Laravel Development

This skill bundles two reference files. Read them when relevant — do not load both upfront.

## References

**`references/laravel-guidelines.md`** — Read this file before writing or reviewing any Laravel/PHP code. Covers naming conventions, type declarations, control flow rules, and Spatie-style patterns. Read it when the user asks to write, edit, or review controllers, models, jobs, commands, service providers, or any PHP class.

**`references/developing-modular-laravel.md`** — Read this file when the task involves the modular architecture. Covers scaffolding module directories under `modules/`, registering service providers, wiring `Modules\` PSR-4 namespaces in `composer.json`, and setting up Eloquent factories with `#[UseFactory]`. Read it when the user asks to create a module, add a service provider, or establish the modular structure for a new project.
